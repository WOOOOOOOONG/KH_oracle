SELECT * FROM EMPLOYEE;

-- 오라클의 SQL Plus와 SQL Developer
-- SQL Plus는 CLI(Command Line Interface) 기반의 툴, 오라클 설치 시 기본으로 제공
-- SQL Developer는 GUI(Graphic User Interface) 기반의 툴, 사용자 편의성이 크며 추가적으로 설치
-- 두 개 모두 오라클 데이터베이스에 SQL 및 PL/SQL문장을 실행할 수 있는 환경을 제공

-- DML : 데이터 조작어, 데이터베이스의 데이터를 조회(SELECT), 삽입(INSERT), 변경(UPDATE), 삭제(DELETE)할 수 있다.
-- DDL : 데이터 정의어, 데이터베이스의 구조(스키마)를 생성(CREATE), 변경(ALTER), 삭제(DROP)할 수 있다.
-- TCL : 데이터 제어어, 권한을 주거나(GRANT) 회수(REVOKE)할 수 있으며 트랜잭션 관리(COMMIT, ROLLBACK)를 한다.

-- *** SELECT ***
-- Result Set : SELECT 구문으로 데이터를 조회한 결과물, 반환된 행들의 집합을 의미

-- EMPLOYEE 테이블의 사원 번호, 직원명, 급여 조회
-- 조회하고자 하는 컬럼명을 입력
SELECT EMP_ID, EMP_NAME, EMP_SALARY FROM EMPLOYEE;

-- 대소문자 구분하지 않음
-- SQL Developer에서 ALT + '를 통해 바꿀 수 있음
SELECT * FROM EMPLOYEE;

SELECT * FROM JOB;
SELECT JOB_NAME FROM JOB;

-- -------------------------------------
-- *** 컬럼값 산술연산 ***
-- SELECT시 컬럼명 입력 부분에 계산에 필요한 컬럼명, 숫자, 연산자를 이용하여 결과를 조회할 수 있다
-- EMPLOYEE 테이블에서 직원의 직원, 연봉 조회(연봉은 급여 * 12)
SELECT EMP_NAME, SALARY * 12 FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 직원의 직원명, 연봉, 보너스를 추가한 연봉 조회
SELECT EMP_NAME, SALARY * 12, (SALARY + (SALARY * BONUS) * 12) FROM EMPLOYEE;

---------------- 실습 문제 ----------------
SELECT EMP_NAME, SALARY, (SALARY + (SALARY * BONUS)) * 12, (SALARY + (SALARY * BONUS)) * 12 - (SALARY * 12 * 0.03) FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, SYSDATE - HIRE_DATE FROM EMPLOYEE;

-- **컬럼 별칭** --
-- 형식 : 컬럼명 AS 별칭 / 컬럼명 별칭 / 컬렴명 AS "별칭" / 컬럼명 "별칭"
-- 컬럼명, 테이블명 등을 예명을 이용해 단순화하고, 명확하게 할 수 있다
-- FROM절의 테이블명 Alias 설정 시 해당 Alias는 테이블 이름 대신 사용 가능
-- 별칭에 숫자, 기호가 포함될 때는 반드시 ""로 묶어서 표현해야 한다.

-- EMPLOYEE 테이블에서 직원의 직원명(별칭:이름), 연봉(별칭:연봉(원)), 보너스를 추가한 연봉(별칭:총소득(원)) 조회
SELECT EMP_NAME 이름, SALARY*12 "연봉(원)", SALARY*(1+BONUS)*12 AS "총소득(원)"
FROM EMPLOYEE;

-------------------- 리터럴 ---------------
-- 임의로 지정한 문자열을 SELECT절에 사용하면, 테이블에 존재하는 데이터처럼 사용 가능
-- 문자나 날짜 리터럴은 ''기호 사용
-- 리터럴은 Result Set의 모든 행에 반복표시 됨.

-- EMPLOYEE 테이블에서 직원의 직원번호, 사원명, 급여, 단위(데이터 값 : 원) 조회
SELECT EMP_ID, EMP_NAME, SALARY, '원' AS 단위 FROM EMPLOYEE;

--------------DISTINCT--------------
-- 컬럼에 포함된 중복값을 한 번씩만 표시하고자 할 때 사용
-- EMPLOYEE 테이블에서 직원의 직급 코드 조회
SELECT DISTINCT JOB_CODE
FROM EMPLOYEE;
-- DISTINCT는 SELECT절에 한 번만 쓸 수 있다.
SELECT DISTINCT DEPT_CODE, JOB_CODE
FROM EMPLOYEE;

-------------WHRER절-----------
-- 조회할 테이블에서 조건에 맞는 값을 가진 행을 골라 SOA
/*
SELECT 컬럼명
FROM 테이블명
WHRER 조건
*/

-- *** 비교 연산자 ***
-- = 같다, > 크다, < 작다, >= 크거나 같다, <= 작거나 같다
-- !=, ^=, <> 같지 않다

-- EMPLOYEE 테이블에서 부서코드가 'D9'인 직원의 이름, 부서코드 조회
SELECT EMP_NAME, DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE = 'D9';

-- EMPLOYEE 테이블에서 급여가 4000000 이상인 직원의 이름, 급여 조회
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY >= 4000000;

-- EMPLOYEE 테이블에서 부서코드가 D9가 아닌 사원의 사번, 이름, 부서코드 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE <> 'D9'; /* <> != ^= */

-- EMPLOYEE 테이블에서 퇴사 여부가 N인 직원을 조회하고
-- 근무 여부를 재직중으로 표시해 사번, 이름, 고용일, 근무여부 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE, '재직중' 근무여부
FROM EMPLOYEE
WHERE ENT_YN = 'N';

-- 실습 문제 --
-- 1. EMPLOYEE 테이블에서 월급이 3000000 이상인 사원의 이름, 월급, 고용일 조회
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY >= 3000000;

-- 2. EMPLOYEE 테이블에서 SA_LEVEL이 S1인 사원의 이름, 월급, 고용일, 연락처 조회
SELECT EMP_NAME, SALARY, HIRE_DATE, PHONE
FROM EMPLOYEE
WHERE SAL_LEVEL = 'S1';

-- 3. EMPLOYEE 테이블에서 실수령액(총수령액 - (연봉 * 세금3%))이 5천만원 이상인 사원의 이름, 월급, 실수령액, 고용일 조회
SELECT EMP_NAME, SALARY, SALARY*(1+BONUS)*12 - (SALARY*12*0.03) AS 실수령액, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY*(1+BONUS)*12 - (SALARY*12*0.03) >= 50000000;

---------논리 연산자(AND/OR)-------
-- 여러개 조건 작성 시 사용
-- 부서 코드가 'D6'이고 급여를 2백만보다 많이 받는 직원의 이름, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6'
AND SALARY > 2000000;

-- 부서 코드가 'D6'이거나 급여를 2백만보다 많이 받는 직원의 이름, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6'
OR SALARY > 2000000;

-- EMPLOYEE 테이블에서 급여를 350만원 이상 600만원 이하를 받는 직원의 사번, 이름, 급여, 부서코드, 직급코드를 조회
SELECT EMP_ID, EMP_NAME, SALARY, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE SALARY >= 3500000 AND SALARY <= 6000000;

------------- 실습 문제 -------------------
-- 1. EMPLOYEE 테이블에서 월급이 4백 이상이고 JOB_CODE가 J2인 사원의 전체 내용 조회
SELECT *
FROM EMPLOYEE
WHERE SALARY >= 4000000 AND JOB_CODE = 'J2';

-- 2. EMPLOYEE 테이블에서 DEPT_CODE가 D9 이거나 D5인 사원 중 고용일이 00년 1월 1일보다 빠른 사원의 이름, 부서코드, 고용일 조회
--    날짜 표현 '00/01/01/
SELECT EMP_NAME, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE = 'D9' OR DEPT_CODE = 'D5')
AND HIRE_DATE < '00/01/01';
-- OR와 AND 연산자가 있을 때 AND가 우선이다

------- BETWEEN AND -------
-- 비교대상컬럼명 BETWEEN 하한값 AND 상한값
-- 하한값 이상 상한값 이하

--급여가 350만원 이상 600만원 이하의 사원 이름, 급여 조회
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 6000000;

-- 반대로 급여를 350만원 미만, 또는 600 초과하는 직원의 사번, 이름, 부서코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE /*여기에 NOT도 가능*/SALARY NOT BETWEEN 3500000 AND 6000000; /* 비트윈 안의 조건에 해당하지 않는 것들 조회 */

------------실습문제------------
-- 1. EMPLOYEE 테이블에 고용일이 90/01/01 ~ 01/01/01인 사원의 전체 내용 조회
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01';

-----------LIKE-------------
-- 비교하려고 하는 값이 지정한 특정 패턴을 만족시키는지 조회할 때 비교대상 LIKE '문자패턴'
-- '%'와 '_'를 와일드 카드로 사용할 수 있음
-- 문자 패턴 : '글자%' (글자로 시작하는 값)
--           '%글자%' (글자가 포함된 값)
--           '%글자'% (글자로 끝나는 값)
-- 문자 수 : '_' (한글자)
--          '__' (두글자)

-- EMPLOYEE 테이블에서 성이 전씨인 사번, 이름, 고용일 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '전%';

-- EMPLOYEE 테이블에서 '하'가 포함된 직원의 이름, 주민번호, 부서코드 조회
SELECT EMP_NAME, EMP_NO, DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%';

-- EMPLOYEE 테이블에서 전화번호 4번째 자리가 9로 시작하는 사원의 사번, 이름, 전화번호 조회
SELECT EMP_ID, EMP_NAME, PHONE
FROM EMPLOYEE
WHERE PHONE LIKE '___9%';

-- 이메일 중 _앞글자가 3자리인 이메일 주소를 가진 사원의 사번, 이름, 이메일 주소 조회
SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '___\_%' ESCAPE '\'; /* ESCAPE 문자는 내가 임의로 사용해도 된다. */
--> 와일드 카드 문자와 패턴의 특수문자가 동일한 경우에는 처리할 기호 앞에 임의로 특수문자를 사용하고 이스케이프 옵션 등록 
