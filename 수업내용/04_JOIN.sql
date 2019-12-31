-- JOIN 
-- 하나 이상의 테이블에서 데이터를 조회하기 위해 사용
-- 수행 결과는 하나의 Result Set으로 나옴

/*
    관계형 데이터베이스에서 SQL을 이용해 테이블간 '관계'를 맺는 방법
    
    관계형 데이터베이스는 최소한의 데이터를 테이블에 담고 있어
    원하는 정보를 테이블에서 조회하려면 한 개 이상의 테이블에서 데이터를 읽어와야 되는 경우가 많음
    이 때, 무작정 데이터를 가져오는 것이 아닌 테이블간 연결고리로 관계가 맺어진 데이터를 추출해야 함
    --> JOIN을 통해 이를 구현
*/
---------------------------------------------------------------------------------------
-- 직원번호, 직원명, 부서코드, 부서명을 조회하고자 할 때
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;
-- 직원번호, 직원명, 부서코드는 EMPLOYEE 테이블에서 조회 가능

-- 부서명은 DEPARTMENT 테이블에서 조회 가능
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;

-- 1. 내부 조인(INNER JOIN) (== 등가 조인(EQUAL JOIN))
--> 연결되는 컬럼의 값이 일치하는 행들만 조인됨(일치하는 값이 없는 행은 조인에서 제외)

-- 작성 방법은 크게 오라클 구문과 ANSI 구문으로 나뉘고, ANSI에서 ON을 쓰는 방법과 USING을 쓰는 방법으로 나뉨

-- 오라클 전용 구문
-- FROM절에 ','로 구분하여 합치게 될 테이블명을 기술하고
-- WHERE절에 합치기에 사용할 컬럼명을 명시한다.

-- 1) 연결에 사용할 두 컬럼명이 다른 경우
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;

-- 2) 연결에 사용할 두 컬럼명이 같은 경우
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- 3) 별칭 사용
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;

-------------------------------------------------------------------------------------------
-- ANSI 표준 구문
-- ANSI는 미국 국립 표준 협회를 뜻함. 미국의 산업표준을 제정하는 민간단체로 국제표준화기구 ISO에 가입되어 있음.
-- ANSI에서 제정된 표준을 ANSI라고 하고 여기서 제정한 표준 중 가장 유명한 것이 아스키코드임.

-- 1) 연결에 사용할 컬럼명이 같은 경우 : USING(컬럼명)
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);

-- 2) 연결에 사용할 컬럼명이 다른 경우 : ON(컬럼명=컬럼명)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- 부서 테이블에서 부서별 지역명을 조회하세요
-- 오라클 구문
SELECT DEPT_TITLE, LOCAL_NAME
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE;
-- ANSI 구문
SELECT DEPT_TITLE, LOCAL_NAME
FROM DEPARTMENT
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE);
---------------------------------------------------------------------------------------------

-- 2. 외부 조인(OUTER JOIN)
-- 두 테이블의 지정하는 컬럼 값이 일치하지 않는 행도 조인에 포함을 시킴
--> *** 반드시 OUTER JOIN임을 명시해야 함 ***

-- OUTER JOIN과 비교할 INNER JOIN 쿼리문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 1) LEFT [OUTER] JOIN : 합치기에 사용한 두 테이블 중 왼편에 기술된 테이블의 컬럼 수를 기준으로 JOIN
-- ANSI 표준
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
--LEFT OUTER JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID); -- OUTER 생략 가능

-- 오라클 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);

-- 2) RIGHT [OUTER] JOIN : 합치기에 사용한 두 테이블 중 오른편에 기술 된 테이블의 컬럼 수를 기준으로 JOIN
-- ANSI 표준
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
RIGHT OUTER JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 오라클 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE(+) = D.DEPT_ID;

-- 3) FULL [OUTER] JOIN : 합치기에 사용한 두 테이블이 가진 모든 행을 결과에 포함
-- ANSI 표준
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
FULL OUTER JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- 오라클 구문은 FULL OUTER JOIN을 사용 못함!!
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE(+) = D.DEPT_ID(+);

------------------------------------------------------------------------------------------

-- 3. 교차 조인(CROSS JOIN == 카티지언 곱(CARTESAIN PRODUCT))
-- 조인 되는 테이블의 각 행들이 모두 매핑 된 데이터가 검색 되는 방법(곱집합)
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT;

------------------------------------------------------------------------------------------
-- 4. 비등가 조인 (NON EQUAL JOIN)

-- '='(등호)를 사용하지 않는 조인문
-- 지정한 컬럼 값이 일치하는 경우가 아닌, 값의 범위에 포함되는 행들을 연결하는 방식

-- ANSI 구문
SELECT EMP_NAME, SALARY, E.SAL_LEVEL, S.SAL_LEVEL
FROM EMPLOYEE E
JOIN SAL_GRADE S ON(SALARY BETWEEN MIN_SAL AND MAX_SAL);

-- 오라클 구문으로 작성하기
SELECT EMP_NAME, SALARY, E.SAL_LEVEL, S.SAL_LEVEL
FROM EMPLOYEE E, SAL_GRADE S
WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;

---------------------------------------------------------------------------------------------
-- 5. 자체 조인(SELF JOIN)
-- 같은 테이블을 조인, 자기 자신과 조인을 맺음

-- 오라클 구문
SELECT E.EMP_ID, E.EMP_NAME 사원이름, E.DEPT_CODE, E.MANAGER_ID, M.EMP_NAME 관리자이름
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MANAGER_ID = M.EMP_ID;

-- ANSI 표준
SELECT E.EMP_ID, E.EMP_NAME 사원이름, E.DEPT_CODE, E.MANAGER_ID, M.EMP_NAME 관리자이름
FROM EMPLOYEE E
JOIN EMPLOYEE M ON(E.MANAGER_ID = M.EMP_ID);

---------------------------------------------------------------------------------------------
-- 6. 다중 조인
-- N개의 테이블을 조회할 때 사용

-- 오라클 전용
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE, DEPARTMENT, LOCATION
WHERE DEPT_CODE = DEPT_ID
AND LOCATION_ID = LOCAL_CODE;

-- ANSI 표준
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE);

-- 조인 순서를 지키지 않은 경우
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);
-- LOCATION_ID는 DEPARTMENT에 있음
-- 첫번째 조인에서는 DEPARTMENT와 아직 조인 관계가 맺어지지 않은 상태이므로
-- LOCATION_ID를 통해 LOCAL_CODE에 접근하려고 하는 것은 에러 발생!!!

---------------------------------------------------------------------------------------------
--[다중 조인 연습 문제]
-- 직급이 대리이면서 아시아 지역에 근무하는 직원 조회
-- 사번, 이름, 직급명, 부서명, 근무지역명, 급여를 조회하세요
-- 오라클 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME, SALARY
FROM EMPLOYEE, JOB, LOCATION, NATIONAL, DEPARTMENT
WHERE LOCATION.NATIONAL_CODE = NATIONAL.NATIONAL_CODE
    AND EMPLOYEE.JOB_CODE = JOB.JOB_CODE
    AND JOB_NAME = '대리' 
    AND (NATIONAL_NAME = '한국' OR NATIONAL_NAME = '일본' OR NATIONAL_NAME = '중국');

-- ANSI 표준
SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
JOIN LOCATION ON(LOCAL_CODE = LOCATION_ID)
JOIN NATIONAL USING(NATIONAL_CODE)
WHERE JOB_NAME = '대리' 
    AND (NATIONAL_NAME = '한국' OR NATIONAL_NAME = '일본' OR NATIONAL_NAME = '중국');

-- [실습문제]
-- 1 모든 직원의 사원명, 직급명, 부서명, 지역명 조회 (INNER JOIN)
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE, JOB, DEPARTMENT, LOCATION
WHERE EMPLOYEE.JOB_CODE= JOB.JOB_CODE
    AND DEPT_ID = DEPT_CODE
    AND LOCATION_ID = LOCAL_CODE;

-- 2 이름에 '형'자가 들어가는 직원의 사원 번호, 사원명, 직급명을 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE
    AND INSTR(EMP_NAME, '형') != 0;

-- 3 보너스를 받지 않는 J4, J7의 직급코드를 가진 직원의 직원명, 직급명, 월급 조회
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE
    AND (JOB.JOB_CODE = 'J4' OR JOB.JOB_CODE = 'J7')
    AND BONUS IS NULL;

-- 4 성이 '전'씨인 70년대생 여자 직원의 직원명, 주민등록번호, 부서명, 직급명을 조회
SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE, DEPARTMENT, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE
    AND DEPT_ID = DEPT_CODE
    AND SUBSTR(EMP_NAME, 1, 1) = '전';

-- 5 부서코드가 D5, D6인 사원의 사원명, 직급명, 부서코드, 부서명을 조회
SELECT EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE
    AND DEPT_ID = DEPT_CODE
    AND DEPT_CODE IN('D5', 'D6');


-- 6 보너스를 받는 직원의 사원명, 보너스, 부서명, 지역명을 조회
SELECT EMP_NAME, BONUS, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE, DEPARTMENT, LOCATION
WHERE DEPT_ID = DEPT_CODE
    AND LOCATION_ID = LOCAL_CODE
    AND BONUS IS NOT NULL;

-- 7 한국식 나이로 가장 어린 사람의 사원번호, 사원명, 나이, 부서명, 직급명
-- 가장 어린 사람이라는 조건은 서브 쿼리로 MIN 연산자 활용할 것
-- 오라클
SELECT EMP_ID, EMP_NAME, 
       EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2), 'RR'))) + 1 AS 나이,
       DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT, JOB J
WHERE DEPT_CODE = DEPT_ID
AND E.JOB_CODE = J.JOB_CODE
AND EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2), 'RR'))) + 1 = 
(SELECT MIN(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2), 'RR'))) + 1) FROM EMPLOYEE);

-- ANSI
SELECT EMP_ID, EMP_NAME, 
       EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2), 'RR'))) + 1 AS 나이,
       DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2), 'RR'))) + 1 =
(SELECT MIN(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2), 'RR'))) + 1) FROM EMPLOYEE);


-- 8 SALARY 테이블의 MIN_SAL 기준을 초과한 월급을 받는 사원의 사원명, 직급명, 월급, 연봉(보너스 포함) 조회
-- 오라클
SELECT EMP_NAME, JOB_NAME, SALARY, SALARY*12+SALARY*NVL(BONUS,0) 
FROM EMPLOYEE E, JOB J, SAL_GRADE S
WHERE E.JOB_CODE = J.JOB_CODE
AND E.SAL_LEVEL = S.SAL_LEVEL
AND E.SALARY > S.MIN_SAL;

-- ANSI
SELECT EMP_NAME, JOB_NAME, SALARY, SALARY*12+SALARY*NVL(BONUS,0) 
FROM EMPLOYEE E
JOIN JOB USING(JOB_CODE)
JOIN SAL_GRADE S USING(SAL_LEVEL)
WHERE E.SALARY > S.MIN_SAL;

-- 9 한국과 일본에서 일하는 직원들의 직원명, 부서명, 지역명, 국가명 조회
-- 오라클
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE, DEPARTMENT, LOCATION L, NATIONAL N
WHERE DEPT_CODE = DEPT_ID
AND LOCATION_ID = LOCAL_CODE
AND L.NATIONAL_CODE = N.NATIONAL_CODE
AND NATIONAL_NAME IN('한국', '일본');

-- ANSI
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING(NATIONAL_CODE)
WHERE NATIONAL_NAME IN('한국', '일본');

-- 10 EMPLOYEE 테이블을 DEPT_CODE를 기준으로 셀프 조인하여 사원명1, DEPT_CODE, 사원명2 조회하고 사원명1 오름차순 정렬
--  단, 사원명1과 사원명2가 동일한 경우는 제외(결과 총 60행)
-- 오라클
SELECT D.EMP_NAME "사원명1" , E.DEPT_CODE, E.EMP_NAME "사원명2"
FROM EMPLOYEE E, EMPLOYEE D
WHERE E.DEPT_CODE = D.DEPT_CODE
AND E.EMP_NAME != D.EMP_NAME
ORDER BY 1;

-- ANSI
SELECT D.EMP_NAME "사원명1" , E.DEPT_CODE, E.EMP_NAME "사원명2"
FROM EMPLOYEE E
JOIN EMPLOYEE D ON(E.DEPT_CODE = D.DEPT_CODE)
WHERE E.EMP_NAME != D.EMP_NAME
ORDER BY 1;


