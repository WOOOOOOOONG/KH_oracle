-- GROUP BY & HAVING

/*
    실행 순서
    5 : SELECT 컬럼명 AS 별칭, 계산식, 함수식
    1 : FROM 참조할 테이블명
    2 : WHERE 컬럼명 | 함수식 비교연산자 비교값
    3 : GROUP BY 그룹을 묶을 컬럼명
    4 : HAVING 그룹함수식 비교연산자 비교값
    6 : ORDER BY 컬럼명 | 별칭 | 컬럼순번 정렬방식 [NULLS FIRST | LAST]
*/

------------------------------------------------------
-- GROUP BY절 : 깥은 값들이 여러개 기록된 컬럼을 가지고 같은 값들을 하나의 그룹으로 묶음
-- GROUP BY 컬럼명 | 함수식, ...
-- 여러 개의 값을 묶어서 하나로 처리할 목적으로 사용함
-- 그룹으로 묶은 값에 대해서 SELECT절에서 그룹 함수를 사용함

-- 그룹 함수는 단 한개의 결과 값만 산출하기 때문에 그룹이 여러 개일 경우 오류 발생
-- 여러개의 결과값을 산출하기 위해 그룹 함수가 적용된 그룹의 기준을 GROUP BY 절에 기술하여 사용
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- EMPLOYEE 테이블에서 부서코드, 그룹별 급여의 합계, 그룹별 급여의 평균(정수처리),
-- 인원수를 조회하고 부서 코드 순으로 정렬
SELECT DEPT_CODE 부서코드, SUM(SALARY) 합계, FLOOR(AVG(SALARY)) 평군, COUNT(*) 인원수
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

--EMPLOYEE 테이블에서 부서코드와 부서별 보너스 받는 사원 수 조회하고 부서코드 순으로 정렬
SELECT DEPT_CODE, COUNT(BONUS)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

--EMPLOYEE 테이블에서 직급코드별, 보너스를 받는 사원의 수를 조회하여 직급코드 순으로 오름차순 정렬
-- 보너스 받는 사원이 없다면 직급코드 표시하지 않음
SELECT DEPT_CODE, COUNT(BONUS)
FROM EMPLOYEE
WHERE BONUS IS NOT NULL
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

-- EMPLOYEE 테이블에서 성별과 성별별 급여 평균(정수처리), 급여 합계, 인원 수 조회하고 인원수로 내림차순
SELECT DECODE(SUBSTR(EMP_NO, 8, 1), 1, '남', 2, '여') 성별,
    FLOOR(AVG(SALARY)) 평균, SUM(SALARY) 합계, COUNT(*) 인원수
FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO, 8, 1), 1, '남', 2, '여');

----------------------------------------------------------------------
-- HAVING절 : 그룹 함수로 구해 올 그룹에 대해 조건을 설정할 때 사용(= 그룹에 거는 조건절)
-- HAVING 컬럼명 | 함수식 비교연산자 비교값

-- 급여 300만 이상인 직원들의 부서 그룹별 급여 평균 조회(부서코드 순 정렬)
SELECT DEPT_CODE, FLOOR(AVG(SALARY)) 평균
FROM EMPLOYEE
WHERE SALARY >= 3000000
GROUP BY DEPT_CODE
ORDER BY 1;

-- 부서 그룹별 급여 평균이 300만 이상인 그룹 조회(부서코드 순 정렬)
SELECT DEPT_CODE, FLOOR(AVG(SALARY)) 평균
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING FLOOR(AVG(SALARY)) >= 3000000
ORDER BY 1;

-- 부서별 그룹의 급여 합계 중 9백만원을 초과하는 부서코드와 급여 합계 조회(부서코드순 정렬)
SELECT DEPT_CODE, SUM(SALARY) 급여합계
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) > 9000000
ORDER BY 1; -- SELECT문의 첫번째로 쓴 DEPT_CODE 기준

-- [참고]
-- 급여 합계가 가장 많은 부서의 부서코드와 부서 합계를 구하시오
-- 서브 쿼리(하위 쿼리) 사용
SELECT DEPT_CODE, MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                      FROM EMPLOYEE
                      GROUP BY DEPT_CODE);
                      
------------------------------------------------
-- 집계 함수(ROLLUP, CUBE)    SQLD 단골문제로 나옴, 중요할 듯
-- 그룹별 산출한 결과 값의 집계를 계산하는 함수
-- 묶기 + 합계

-- EMPLOYEE 테이블에서 각 직급 코드별 급여 합계와
-- 마지막 행에 전체 급여 총합 조회(직급코드 순 정렬)
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY 1;

SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE)
ORDER BY 1;
-- 합해서 따로 출력

SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE)
ORDER BY 1;
-- CUBE를 사용해도 같은 결과

-- ROLLUP 함수 : 그룹별로 중간 집계 처리를 하는 함수
-- GROUP BY 절에서만 사용하는 함수
-- 그룹별로 묶여진 값에 대한 중간 집계와 총 집계를 구할 때 사용
-- *** 인자로 전달받은 그룹 중 가장 먼저 지정한 그룹별 합계와 총 합계를 구하는 함수 ***

-- EMPLOYEE 테이블에서 각 부서 코드마다 직급 코드별 급여 합, 부서별 급여 합, 총합 조회
-- 부서 코드순 정렬
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE) -- 여러 개 들어올 수 있다. 첫 번째 인자에 대한 중간 합계를 제공하고, 최종 합계도 첫 번째 인자의 합계 (뒷 인자는 무시한다고 봐도 되나 ?)
ORDER BY 1;

-- CUBE 함수 : 그룹별 산출한 결과를 집계하는 함수
-- *** 그룹으로 지정된 모든 그룹에 대한 집계와 총 합계를 구하는 함수 ***
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE) -- 앞 인자에 대해 ROLLUP처럼 하고, 뒤 인자에 대해서도 중간합계가 나온다.
ORDER BY 1;

-- GROUPING 함수 : ROLLUP이나 CUBE에 의한 산출물이 인자로 전달받은 컬럼의 집합의 산출물이면 0을 반환하고, 아니면 1을 반환하는 함수
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY),
    GROUPING(DEPT_CODE) "부서별그룹묶인상태",
    GROUPING(JOB_CODE) "직급별그룹묶인상태"
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE;

SELECT DEPT_CODE, JOB_CODE, SUM(SALARY),
    CASE WHEN GROUPING(DEPT_CODE) = 0 AND GROUPING(JOB_CODE) = 1 THEN '부서별합계'
         WHEN GROUPING(DEPT_CODE) = 1 AND GROUPING(JOB_CODE) = 0 THEN '직급별합계'
         WHEN GROUPING(DEPT_CODE) = 0 AND GROUPING(JOB_CODE) = 0 THEN '그룹별합계'
        ELSE '총합계'
    END 구분
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1;

-----SET OPERATION-----
-- 여러가지 조건이 있을 때 그에 해당하는 여러 개 결과값을 결합시키고 싶을 때 사용
-- UNION, INTERSECT, UNION ALL(여러개 쿼리 결과를 하나로 합치고, 중복 데이터 한번 더 가져옴. 합집합 + 교집합), MINUS, GROUPING SETS

-- UNION : 여러개의 쿼리 결과를 하나로 합치는 연산자
-- 중복된 영역을 제외하여 하나로 합친다
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

UNION

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- INTERSECT : 여러 개의 SELECT 한 결과에서 공통 부분만 결과로 추출(교집합)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

INTERSECT

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- UNION ALL
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

UNION ALL

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- MINUS : 선행 SELECT 결과에서 다음 SELECT 결과와 겹치는 부분을 제외한 나머지 부분만 추출(차집합)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

MINUS

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- GROUPING SETS : 그룹별로 처리된 여러개의 SELECT문을 하나로 합칠 때 사용
-- SET OPERATION 사용한 결과와 동일
SELECT DEPT_CODE, JOB_CODE, MANAGER_ID, COUNT(*), FLOOR(AVG(SALARY))
FROM EMPLOYEE
GROUP BY GROUPING SETS(
    (DEPT_CODE, JOB_CODE, MANAGER_ID),
    (DEPT_CODE, MANAGER_ID),
    (JOB_CODE, MANAGER_ID));