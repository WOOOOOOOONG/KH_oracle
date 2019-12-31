-- SUBQUERY
/*
    - 하나의 SQL문 안에 포함된 또 다른 SQL문
    - 메인 쿼리(기존 쿼리)
    -
*/

-- 서브쿼리 예시
-- 부서코드가 노옹철 사원과 같은 소속의 직원 명단 조회

-- 1) 사원명이 노옹철인 사람의 부서 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철';

-- 2) 부서 코드가 D9인 직원 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- 3) 서브쿼리 이용
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '노옹철');
                   
-- 서브쿼리 예시2
-- 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의 사번, 이름, 직업코드, 봉급 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT AVG(SALARY)
                FROM EMPLOYEE);
-- 서브쿼리는 알려지지 않은 기준을 이요한 검색을 위해 사용            
                                      
----------------------------------------------------------
-- <서브쿼리 유형>

-- 단일행 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 1개일 때
-- 다중행 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 여러개일 때
-- 다중열 서브쿼리 : 서브쿼리 SELECT절에 나열된 항목 수가 여러개일 때
-- 다중행 다중열 서브쿼리 : 조회 결과 행수와 열수가 여러개일 때
--> 서브쿼리가 메인쿼리 컬럼을 가지고 있지 않는 형태의 서브쿼리로
--  메인쿼리에 값(서브쿼리가 실행된 결과)을 제공하기 위한 목적으로 주로 사용

-- 상(호연)관 서브쿼리 : 서브쿼리가 만든 결과 값을 메인 쿼리가 비교 연산할 때
--                      메인 쿼리 테이블의 값이 변경되면 서브쿼리의 결과 값도 바뀌는 서브쿼리
-- 스칼라 서브쿼리 : 상관 커리이면서 결과 값이 하나인 서브쿼리

--> 서브쿼리가 메인쿼리 칼럼을 가지고 있는 형태의 서브쿼리
-- 일반적으로는 메인쿼리가 먼저 수행되어 읽혀진 데이터를 서브쿼리에서 조건이 맞는지 확인하고자 할 때 주로 사용

-- *** 서브쿼리의 유형에 따라 서브쿼리 앞에 붙는 연산자가 다름***
--------------------------------------------------------------------
-- 1. 단일행 서브쿼리(SINGLE ROW SUBQUERY)
-- 서브 쿼리의 조회 결과 값의 개수가 1일 때
-- 단일행 서브쿼리 앞에는 일반 연산자 사용
-- <, >, <=, >=, =, !=/<>/^= (서브쿼리)

-- 예제 1-1
-- 전 직원의 급여 평균보다 많은 급여를 받는 직원의 이름, 직급, 부서, 급여 조회
-- 직급 순 정렬
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= (SELECT AVG(SALARY)
                FROM EMPLOYEE)
ORDER BY 2;

-- 예제 1-2
-- 노옹철 사원의 급여보다 많이 받는 직원의 사번, 이름, 부서, 직급, 급여를 조회
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '노옹철');
                
-- 예제 1-3
-- 가장 적은 급여를 받는 직원의 사번, 이름, 직급, 부서, 급여, 일사일 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, DEPT_CODE, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY)
                FROM EMPLOYEE);
                
-- *** 서브쿼리는 WHERE절뿐만 아니라 SELECT, HAVING, FROM에도 사용 가능 ***
-- 예제 1-4
-- 부서별(부서가 없는 사람 포함) 급여의 합계 중 가장 큰 부서의 부서명 급여 합계 조회
-- 1) 부서별 급여 합계
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
JOIN DEPARTMENT
-- 부서가 없는 직원도 있음 -> 전 직원에 대한 조회를 위해 LEFT JOIN
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE;

-- 2) 급여 합계가 가장 큰 부서의 급여 합계
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 3) 부서별 급여의 합계 중 가장 큰 부서
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE
-- 부서별 그룹 합계가 가장 큰 그룹 -> 그룹에 대한 조건은 HAVING
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                    FROM EMPLOYEE
                    GROUP BY DEPT_CODE);

----------------------------------------------------------
-- 2. 다중행 서브쿼리(MULTI ROW SUBQUERY)
-- 서브쿼리의 조회 결과 값의 개수가 여러개일 때

-- 다중행 서브쿼리 앞에는 일반 비교 연산자 사용 못한다(다중으로 비교해야 하니까)
-- IN/NOT IN
-- ANY, < ANY : 여러 개의 결과 값 중에서 한 개라도 큰 / 작은 경우
-- ALL, < ALL : 모든 값보다 큰 / 작은 경우
-- EXIST / NOT EXISTS : 값이 존재하는가 존재하지 않는가

-- 예제 2-1
-- 부서별 최고 급여를 받는 직원의 이름, 직급, 부서, 급여 조회
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN (SELECT MAX(SALARY)
                FROM EMPLOYEE
                GROUP BY DEPT_CODE)
ORDER BY 3;

-- 예제 2-2
-- 관리자에 해당하는 직원에 대한 정보 추출 조회
-- 사번, 이름, 부서명, 직급, 구분(관리자/직업)

-- 1) 관리자에 해당하는 사원 번호 조회
SELECT DISTINCT MANAGER_ID -- 관리자 한명이 여러명 관리할 수 있으므로 중복 제거
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL;

-- 2) 직원의 사번, 이름, 부서명, 직급 코드
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, GOB_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE);

-- 3) 관리자에 해당하는 직원에 대한
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '관리자' AS 구분
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
            WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID 
            FROM EMPLOYEE
            WHERE MANAGER_ID IS NOT NULL);
            
-- 4) 관리자에 해당하지 않는 직원에 대한 추출 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '사원' AS 구분
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
            WHERE EMP_ID NOT IN (SELECT DISTINCT MANAGER_ID 
            FROM EMPLOYEE
            WHERE MANAGER_ID IS NOT NULL);
            
-- 5) 3, 4의 조회 결과를 하나로 합침 -> UNION       
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '관리자' AS 구분
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
            WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID 
            FROM EMPLOYEE
            WHERE MANAGER_ID IS NOT NULL)
            
UNION

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '사원' AS 구분
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
            WHERE EMP_ID NOT IN (SELECT DISTINCT MANAGER_ID 
            FROM EMPLOYEE
            WHERE MANAGER_ID IS NOT NULL);
            
-- *** SELECT절에서도 서브쿼리 사용할 수 있음 ***
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME,
       CASE WHEN EMP_ID IN (SELECT DISTINCT(MANAGER_ID)
                            FROM EMPLOYEE
                            WHERE MANAGER_ID IS NOT NULL) THEN '관리자'
            ELSE '직원'
       END AS 구분
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE);

-- 예제 2-3
-- 대리 직급의 직원들 중에서 과장 직급의 최소 급여보다 많이 받는 직원의 사번, 이름, 직급, 급여 조회
-- 단, > ANY 혹은 < ANY 연산자를 사용하세요
-- 1) 대리 직급인 애들
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
AND SALARY >= '2000000';

-- 2) 과장 직급 직원의 급여
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장';

-- 3) ANY 연산자 사용
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
AND SALARY >= ANY (SELECT SALARY --> ANY 여러개의 결과 값 중에서 한 개라도 큰 경우
                    FROM EMPLOYEE
                 JOIN JOB USING(JOB_CODE)
                    WHERE JOB_NAME = '과장');
                    
-- 예제 2-4
-- 차장 직급의 급여의 가장 큰 값보다 많이 받는 과장 직급 직원의 사번, 이름, 직급, 급여 조회(단, > ALL 혹은 < ALL 연산자 사용)
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장'
AND SALARY >= ALL (SELECT SALARY
                   FROM EMPLOYEE
                   JOIN JOB USING(JOB_CODE)
                   WHERE JOB_NAME = '차장');                
-------------------------------------------------------------
-- 3. 다중 열 서브쿼리
-- 서브쿼리 SELECT절에 나열 된 양쪽 수가 여러개일 때

-- 예제 3-1
-- 퇴사한 여직원과 같은 부서, 같은 직급에 해당하는 사원의 이름, 직급, 부서, 입사일을 조회

-- 1) 퇴사한 여직원
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = 2
AND ENT_YN = 'Y';

-- 2) 퇴사한 여직원과 같은 부서, 같은 직급 (단일열 표현 시 -> 하나의 컬럼만 비교)
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
-- 같은 부서
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE SUBSTR(EMP_NO, 8, 1) = 2
                    AND ENT_YN = 'Y')
-- 같은 직급
AND JOB_CODE = (SELECT JOB_CODE
                FROM EMPLOYEE
                WHERE SUBSTR(EMP_NO, 8, 1) = 2
                AND ENT_YN = 'Y')
-- 이태림 사원 이름 제거
AND EMP_NAME <> (SELECT EMP_NAME
                FROM EMPLOYEE
                WHERE SUBSTR(EMP_NO, 8, 1) = 2
                AND ENT_YN = 'Y');
                
-- 3) 다중열로 수정     
-- 다중열은 가져오려는 열의 개수와 이름, 서브쿼리에서 가져오는 열의 개수와 이름을 맞춘다.
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) IN (SELECT DEPT_CODE, JOB_CODE
                                FROM EMPLOYEE
                                WHERE SUBSTR(EMP_NO, 8, 1) = 2
                                AND ENT_YN = 'Y')
AND EMP_NAME <> (SELECT EMP_NAME
                FROM EMPLOYEE
                WHERE SUBSTR(EMP_NO, 8, 1) = 2
                AND ENT_YN = 'Y');
                
----------------------------실습 문제-------------------------------------
-- 1. 노옹철 사원과 같은 부서, 같은 직급인 사원을 조회(단, 노옹철 사원 제외)
-- 사번, 이름, 부서코드, 직급코드, 부서명, 직급명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
JOIN JOB USING(JOB_CODE)
WHERE (DEPT_CODE, JOB_CODE) IN (SELECT DEPT_CODE, JOB_CODE
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '노옹철')
AND EMP_NAME != '노옹철';
                
-- 2. 2000년도에 입사한 사원의 부서와 직급을 가진 모든 사원 조회
-- 사번, 이름, 부서코드, 직급코드, 고용일
SELECT EMP_ID, EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                                FROM EMPLOYEE
                                WHERE EXTRACT(YEAR FROM HIRE_DATE) = 2000);

-- 3. 77년생 여자 사원의 부서와 관리자를 가진 모든 사원을 조회
-- 사번, 이름, 부서코드, 관리자번호, 주민번호, 고용일
SELECT  EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID, EMP_NO, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, MANAGER_ID) = (SELECT DEPT_CODE, MANAGER_ID
                                FROM EMPLOYEE
                                WHERE SUBSTR(EMP_NO, 1, 2) = 77 AND SUBSTR(EMP_NO, 8, 1) = 2);
                                
---------------------------4. 다중 행 다중 열 서브쿼리-----------------------------------                                
-- 서브쿼리 조회 결과 행수와 열수가 여러개일 때

-- 예제 4-1
-- 자기 직급의 평균급여를 받고 있는 직원의 사번, 이름, 직급, 급여 조회
-- 단, 급여와 급여 평균은 십만원 단위로 계산

-- 1) 급여를 200, 600만원 받는 직원
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN (2000000, 6000000);

-- 2) 직급별 평균 급여(십만원 단위로 절삭)
SELECT JOB_CODE, TRUNC(AVG(SALARY), -5)
FROM EMPLOYEE
GROUP BY JOB_CODE;

-- 3) 자기 직급의 평균 급여를 받고 있는 직원
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, TRUNC(AVG(SALARY), -5)
                            FROM EMPLOYEE
                            GROUP BY JOB_CODE);
                            
----------------------5. 상[호연]관 서브쿼리--------------------------
-- 일반적으로 서브쿼리가 만든 결과 값을 메인쿼리가 비교 연산하는 구조인데,
-- 상관쿼리는 메인쿼리가 사용하는 테이블 값을 서브쿼리가 이용해서 결과를 만든다.
-- 메인쿼리의 테이블 값이 변경되면 서브쿼리의 결과값도 바뀌게 되는 구조

-- 예제 5-1
-- 관리자 사번이 EMPLOYEE 테이블에 존재하는 직원의 사번, 이름, 부서명, 관리자 사번 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE EXISTS (SELECT EMP_ID
                FROM EMPLOYEE M
                WHERE E.MANAGER_ID = M.EMP_ID);
-- EXISTS : 서브쿼리에 해당하는 행이 적어도 한 개 이상 존재할 경우가 충적되면 SELECT 실행
-- 서브쿼리에서 메인쿼리의 테이블 값인 E.MANAGER_ID를 이용하여 결과를 만듦
-- 이 예제에서 동작 순서 )
-- 1) 메인쿼리에서 관리자 사번(E.MANAGER_ID)을 읽어 서브쿼리로 전달
--    (관리자 사번에 존재하지 않으면 NULL 전달)
-- 2) 서브쿼리는 메인쿼리에서 받은 관리자 사번에 해당하는 사번(EMP_ID)을 SELECT
--    (NULL이 전달되었다면 해당하는 행이 0개)
-- 3) 다시 메인쿼리는 서브쿼리에서 SELECT된 행이 적어도 한 개 이상 존재한다면 SELECT 실행(EXIST 동작)
--    (NULL이 전달 되었다면 SELECT가 동작하지 않아서 최종 결과에 불포함

-- 예제 5-2
-- 직급별 급여 평균보다 급여를 많이 받는 직원의 이름, 직급, 급여 조회
-- 단, 급여와 급여 평균은 십만원 단위 계산
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE E
WHERE SALARY > (SELECT TRUNC(AVG(SALARY), 5)
                FROM EMPLOYEE M
                WHERE E.JOB_CODE = M.JOB_CODE);
-- 1) 메인쿼리에서 직급코드(E.JOB_CODE)를 읽어 서브쿼리로 전달
-- 2) 서브쿼리는 메인쿼리에서 받은 직급코드로 평균급여 계산
-- 3) 다시 메인쿼리는 서브쿼리의 평균 급여보다 큰 급여의 직원 출력

-----------------------------6. 스칼라 서브쿼리-----------------------------------
-- 상관쿼리의 한 종류
-- SELECT문에 사용되는 서브쿼리 결과로 1행만 반환
-- SQL에서 단일값을 가르켜 '스칼라'라고 한다
-- 사용 빈도 꽤 됨

-- 예제 6
-- 모든 사원의 사번, 이름, 관리자사번, 관리자명 조회
-- 단, 관리자가 없는 경우 '없음'으로 표시
SELECT E.EMP_ID, E.EMP_NAME, E.MANAGER_ID,
        NVL((SELECT M.EMP_NAME
            FROM EMPLOYEE M
            WHERE E.MANAGER_ID = M.EMP_ID), '없음') AS 관리자명
FROM EMPLOYEE E
ORDER BY 1;

-----------------------------------------------------------------------------------
-- 7. 인라인 뷰(INLINE_VIEW)
-- FROM절에서 서브쿼리를 사용
-- 서브쿼리가 만든 결과 집합(RESULT SET)을 테이블 대신에 사용함

-- 예제 7-1 : 인라인뷰를 활용한 TOP-N 분석
-- 전 직원 중 급여가 높은 상위 5명의 순위, 이름, 급여 조회

-- *** ROWNUM : 조회된 순서대로 1부터 번호를 매김 *** 

-- 방법 1
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM <= 5 -- 상위 5명
ORDER BY SALARY DESC;
-- ORDER BY를 SALARY로 했다고 해서 원하는대로 되지 않고, 원래 데이터시트에서 첫 번째꺼 기준임
-- *** ROWNUM은 FROM절을 수행하면서 붙여지기 때문에 TOP-N분석 시 SELECT절에 사용한 ROWNUM이 의미 없음(ORDER BY 안먹힘)
--> ORDER BY한 결과에 ROWNUM을 붙여 해결

-- 방법 2
SELECT ROWNUM, EMP_NAME, SALARY
FROM (SELECT * FROM EMPLOYEE
      ORDER BY SALARY DESC)
WHERE ROWNUM <= 5;

-- 급여 평균 3위안에 드는 부서의 부서코드와 부서명, 평균 급여를 조회
SELECT DEPT_CODE, DEPT_TITLE, "평균 급여"
FROM (SELECT DEPT_CODE, DEPT_TITLE, FLOOR(AVG(SALARY)) "평균 급여"
        FROM EMPLOYEE
        LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
        GROUP BY DEPT_CODE, DEPT_TITLE
        ORDER BY 3 DESC) -- 평균 급여를 조사한 테이블을 테이블로 쓰고, 그 테이블에서 순번을 매겨 다시 3위 안에 드는 부서를 조회
WHERE ROWNUM <= 3;

-------------------8. WITH-------------------------
-- 서브쿼리에 이름을 붙여주고 사용 시 이름을 사용하게 한다.
-- 인라인뷰로 사용될 서브쿼리에 주로 이용된다
-- 같은 서브 쿼리가 여러번 사용될 경우 중복 작성을 줄일 수 있고
-- 실행 속도도 빨라진다는 장점이 있다
-- 많이 쓰이진 않는다.

-- 예제 8
-- 전 직원의 급여 순위
-- 순위, 이름, 급여 조회
WITH TOPN_SAL AS (SELECT EMP_ID, EMP_NAME, SALARY --미리 정의하고 씀
                    FROM EMPLOYEE
                    ORDER BY SALARY DESC)
SELECT ROWNUM, EMP_NAME, SALARY
FROM TOPN_SAL;

-- RANK() OVER : 동일한 순위 이후의 등수를 동일한 인원 수만큼 건너뛰고 순위 계산---
-- ROWNUM과는 동일한 등수 이후의 처리 부분이 다르다.
-- EX) 공동 1위가 2명이면 다음 수상자는 2등이 아닌 3등

SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) AS 순위
FROM EMPLOYEE;
-- 공동 19등 뒤 21등이 온다

-- DENSE_RANK() OVER : 중복되는 순위 이후의 등수를 이후의 등수로 처리
-- EX) 공동 1위가 2명이어도 다음 수상자는 2등
SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) AS 순위
FROM EMPLOYEE;
-- 공동 20등 뒤 20등

-----------------------------------------------------
-- 부서별 급여 합계가 전체 급여 총 합의 평균보다 20%보다 많은 부서의 부서명과 부서별 급여 합계 조회
--> 단일행 서브쿼리
SELECT DEPT_TITLE, TRUNC("평균 급여", -5)
FROM (SELECT DEPT_TITLE, AVG(SALARY) "평균 급여"
        FROM EMPLOYEE
        LEFT JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
        GROUP BY DEPT_TITLE)
WHERE "평균 급여" >= (SELECT AVG(SALARY)
                    FROM EMPLOYEE);


-- 직원 테이블에서 보너스 포함한 연봉이 높은 5명의 사번, 이름, 부서명, 직급명, 입사일 순위 조회
--> 인라인 뷰
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE
FROM (SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE
        FROM EMPLOYEE
        LEFT JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
        JOIN JOB USING (JOB_CODE)
        ORDER BY ((SALARY * (1 + NVL(BONUS, 0))) * 12) DESC)
WHERE ROWNUM <= 5;

-- HOMEWORK 18번 문제
SELECT STUDENT_NO, STUDENT_NAME
FROM (SELECT STUDENT_NO, STUDENT_NAME
        FROM TB_STUDENT
        JOIN TB_GRADE USING(STUDENT_NO)
        JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
        WHERE DEPARTMENT_NAME = '국어국문학과'
        GROUP BY STUDENT_NO, STUDENT_NAME
        ORDER BY AVG(POINT) DESC)
WHERE ROWNUM = 1;
        
-- DB 배운거 총 집합해서 문제 만들기(KH계정에서)
---- 부서별 평균 급여 순위가 1위에서 3위까지인 부서에 해당하는 직원 중, 전체 부서의 급여 평균보다 높은 사람을 출력하시오
---- 이름, 부서명, 부서 평균급여
---- 급여는 10만원 단위로 계산
WITH AVGSALARY AS (SELECT DEPT_TITLE, DEPT_CODE, AVG(SALARY) "부서 평균급여"
               FROM EMPLOYEE 
               JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
               GROUP BY DEPT_TITLE, DEPT_CODE
               ORDER BY 2 DESC)
SELECT EMP_NAME, SALARY, DEPT_TITLE, TRUNC("부서 평균급여", -5) "부서 평균급여"
      FROM  AVGSALARY, EMPLOYEE
WHERE AVGSALARY.DEPT_CODE = EMPLOYEE.DEPT_CODE
AND SALARY > (SELECT AVG(SALARY)
                FROM EMPLOYEE);


-- 부서별 평균 급여 순위가 1위에서 3위까지에 해당하는 부서의 이름, 부서 평균급여, 순위 출력
-- 급여는 10만원 단위로 계산
SELECT DEPT_TITLE, TRUNC("부서 평균급여", -5) "부서 평균급여", ROWNUM "부서 급여순위"
      FROM  (SELECT DEPT_TITLE, DEPT_CODE, AVG(SALARY) "부서 평균급여"
               FROM EMPLOYEE 
               JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
               GROUP BY DEPT_TITLE, DEPT_CODE
               ORDER BY 2 DESC)
WHERE ROWNUM <= 3;








