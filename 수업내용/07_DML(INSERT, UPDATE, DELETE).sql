-- DML(INSERT, UPDATE, DELETE)

-- DDL : 데이터 정의어, 데이터베이스의 구조(스키마)를 생성, 변경, 삭제
-- CREATE, ALTER, DROP
--> 하나의 DDL 구문이 하나의 트랙잭션 (AUTO COMMIT)

-- DML : 데이터 조작어, 데이터베이스의 데이터를 조회, 삽입, 변경, 삭제
-- SELECT(DQL), INSERT, UPDATE, DELETE
--> 여러 DML 구문이 하나의 트랙잭션

-- TCL, DCL : 데이터 제어어, 권한을 주거나 회수할 수 있으며 트랜잭션 관리를 함
-- GRANT, REVOKE, COMMIT, ROLLBACK
--> 하나의 DCL 구문이 하나의 트랙잭션(AUTO COMMIT)

-- TRANSACTION의 시작은 첫 DML 구문 실행 시
-- COMMIT 또는 ROLLBACK 실행 시 반영
-- DDL 또는 DCL 구문 실행 시, 정상 종료 시(AUTO COMMIT)
-- 시스템 장애 시(AUTO ROLLBACK)

------------------------------------------------------------------------------------------------
-- 1. INSERT

-- 새로운 행을 추가하는 구문
-- 테이블의 행 개수가 증가

-- [표현식]
-- INSERT INTO 테이블명(컬럼명, 컬럼명, 컬럼명, ... )
-- VALUES (데이터1, 데이터2, 데이터3, ... );
-- 테이블에 내가 선택한 컬럼에 대한 값만 INSERT 할 때 사용
-- 선택 안 된 컬럼은 NULL 값이 들어감
INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL,
                      SALARY, BONUS, MANAGER_ID, HIRE_DATE, ENT_DATE, ENT_YN)
VALUES (900, '장채현', '901123-1080503', 'jang_ch@kh.or.kr', '01055569512', 'D1', 'J7', 'S3',
        4300000, 0.2, '200', SYSDATE, NULL, DEFAULT);

SELECT * FROM EMPLOYEE
WHERE EMP_NAME = '장채현';

-- INSERT INTO 테이블명 VALUES(데이터, 데이터, ...)
-- 테이블에 모든 컬럼에 대한 값을 INSERT 할 때 사용
-- INSERT 하고자 하는 컬럼이 모든 컬럼인 경우 컬럼명 생략 가능
-- 단, 컬럼의 순서를 지켜서 VALUES 값을 기입해야 함
ROLLBACK;

INSERT INTO EMPLOYEE
VALUES (900, '장채현', '901123-1080503', 'jang_ch@kh.or.kr', '01055569512', 'D1', 'J7', 'S3',
        4300000, 0.2, '200', SYSDATE, NULL, DEFAULT);
        
COMMIT;

SELECT * FROM EMPLOYEE
WHERE EMP_NAME = '장채현';

-- INSERT시 VALUES 대신 서브쿼리 사용 가능
CREATE TABLE EMP_01(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(30),
    DEPT_TITLE VARCHAR2(20)
);

INSERT INTO EMP_01 (
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE
    FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
);

SELECT *
FROM EMP_01;

-------------------------------------------------------------------------------------------

-- 2. INSERT ALL

-- INSERT시 서브쿼리가 사용하는 테이블이 같은 경우, 두 개 이상의 테이블에 INSERT ALL을 이용하여 한번에
-- 삽입 가능. 단, 각 서브쿼리의 조건절이 같아야 함

-- INSERT ALL 예시1
CREATE TABLE EMP_DEPT_D1
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
   FROM EMPLOYEE
   WHERE 1 = 0;
-- WHERE절에 1 = 0인 경우 모든 행에 대해 FALSE가 나와 아무 조건도 충족하지 않으므로
-- 값은 삽입되지 않고 테이블 컬럼만 생성된다.
SELECT *
FROM EMP_DEPT_D1;

CREATE TABLE EMP_MANAGER
AS SELECT EMP_ID, EMP_NAME, MANAGER_ID
   FROM EMPLOYEE
   WHERE 1 = 0;

SELECT *
FROM EMP_MANAGER;

-- EMP_DEPT_D1 테이블에 EMPLOYEE 테이블에 있는 부서코드가 D1인 직원을 조회해서
-- 사번, 이름, 소속부서, 입사일을 삽입하고,
-- EMP_MANAGER 테이블에 EMPLOYEE 테이블에 있는 부서코드가 D1인 직원을 조회해서
-- 사번, 이름, 관리자 사번을 조회해서 삽입

-- 각각 INSERT할 경우
INSERT INTO EMP_DEPT_D1(
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
    FROM EMPLOYEE
    WHERE DEPT_CODE = 'D1'
);

SELECT *
FROM EMP_DEPT_D1;

INSERT INTO EMP_MANAGER(
    SELECT EMP_ID, EMP_NAME, MANAGER_ID
    FROM EMPLOYEE
    WHERE DEPT_CODE = 'D1'
);

SELECT *
FROM EMP_MANAGER;

-- 서브쿼리의 조건절이 DEPT_CODE = 'D1'으로 같음
ROLLBACK;

INSERT ALL
INTO EMP_DEPT_D1 VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
INTO EMP_MANAGER VALUES(EMP_ID, EMP_NAME, MANAGER_ID)
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
    FROM EMPLOYEE
    WHERE DEPT_CODE = 'D1';

SELECT * FROM EMP_DEPT_D1;
SELECT * FROM EMP_MANAGER;

-- INSERT ALL 예시2
-- EMPLOYEE 테이블의 구조를 복사하여 사번, 이름, 입사일, 급여를 기록할 수 있는
-- 테이블 EMP_OLD와 EMP_NEW 생성
CREATE TABLE EMP_OLD
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
   FROM EMPLOYEE
   WHERE 1 = 0;
   
CREATE TABLE EMP_NEW
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
   FROM EMPLOYEE
   WHERE 1 = 0;
   
-- EMPLOYEE 테이블의 입사일 기준으로 2000년 1월 1일 이전에 입사한 사원의 사번, 이름, 입사일, 급여를
-- 조회해서 EMP_OLD 테이블에 삽입하고 그 후에 입사한 사원의 정보는 EMP_NEW 테이블에 삽입
INSERT ALL
WHEN HIRE_DATE < '2000/01/01' THEN
     INTO EMP_OLD VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
WHEN HIRE_DATE >= '2000/01/01' THEN
     INTO EMP_NEW VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
FROM EMPLOYEE;

SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

-----------------------------------------------------------------------------------------------
-- 3. UPDATE
-- 테이블에 기록 된 컬럼의 값을 수정하는 구문
-- 테이블 전체 행 개수에는 변화가 없음

-- [표현식]
-- UPDATE 테이블명 SET 컬럼명 = 바꿀값 [WHERE 컬럼명 비교연산자 비교값];

CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY;

-- DEPT_COPY 테이블에서 DEPT_ID가 'D9'인 행의 DEPT_TITLE을 '전략기획팀'으로 수정
UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획팀'
WHERE DEPT_ID = 'D9';

SELECT * FROM DEPT_COPY;

COMMIT;

-- 조건절을 설정하지 않고 UPDATE 구문 실행 시 모든 행의 컬럼 값 변경
UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획팀';

SELECT * FROM DEPT_COPY;

ROLLBACK;

-- UPDATE 시에도 서브쿼리를 사용 가능
-- [표현식]
-- UPDATE 테이블명
-- SET 컬럼명 = (서브쿼리)

-- 평상 시 유재식 사원을 부러워하던 방명수 사원의 급여와 보너스율을 유재식 사원과 동일하게 
-- 변경해주기로 했다. 이를 반영하는 UPDATE 문을 작성하시오.
CREATE TABLE EMP_SALARY
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS
   FROM EMPLOYEE;

SELECT * FROM EMP_SALARY
WHERE EMP_NAME IN('유재식', '방명수');

UPDATE EMP_SALARY
SET SALARY = (SELECT SALARY
              FROM EMPLOYEE
              WHERE EMP_NAME = '유재식'),
    BONUS = (SELECT BONUS
             FROM EMPLOYEE
             WHERE EMP_NAME = '유재식')
WHERE EMP_NAME = '방명수';

SELECT * FROM EMP_SALARY
WHERE EMP_NAME IN('유재식', '방명수');

-- 방명수 사원의 급여 인상 소식을 전해들은 다른 멤버들이 단체로 파업을 진행했다
-- 노옹철, 전형돈, 정중하, 하동운 사원의 급여와 보너스를 유재식 사원의 급여와 보너스와 같게
-- 변경하는 UPDATE문을 작성하시오(다중행 다중열 서브쿼리를 이용) : EMP_SALARY에 적용
SELECT * FROM EMP_SALARY
WHERE EMP_NAME IN ('노옹철', '전형돈', '정중하', '하동운');

UPDATE EMP_SALARY
SET (SALARY, BONUS) = (SELECT SALARY, BONUS
                       FROM EMP_SALARY
                       WHERE EMP_NAME = '유재식')
WHERE EMP_NAME IN ('노옹철', '전형돈', '정중하', '하동운');

SELECT * FROM EMP_SALARY
WHERE EMP_NAME IN ('유재식', '노옹철', '전형돈', '정중하', '하동운');

-- 아시아 지역 근무 직원 보너스 0.3으로 변경 : EMP_SALARY에 적용
SELECT EMP_ID, EMP_NAME, SALARY, BONUS, LOCAL_NAME 
FROM EMP_SALARY
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE LOCAL_NAME LIKE 'ASIA%';
-- DEPARTMENT를 먼저 JOIN하지 않으면 LOCATION JOIN 불가능

-- 아시아 지역 근무 직원 보너스 0.3으로 변경
UPDATE EMP_SALARY
SET BONUS = 0.3
WHERE EMP_ID IN (SELECT EMP_ID
                 FROM EMPLOYEE
                 JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
                 JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
                 WHERE LOCAL_NAME LIKE 'ASIA%');

SELECT EMP_ID, EMP_NAME, SALARY, BONUS, LOCAL_NAME 
FROM EMP_SALARY
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE LOCAL_NAME LIKE 'ASIA%';

-- UPDATE시 변경할 값은 해당 컬럼에 대한 제약조건에 위배되지 않아야 함

-- EMPLOYEE에 제약조건 설정
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT(DEPT_ID);
ALTER TABLE EMPLOYEE ADD UNIQUE(EMP_NO);

UPDATE EMPLOYEE
SET DEPT_CODE = '65'
WHERE DEPT_CODE = 'D6'; -- FOREIGN KEY 제약 조건 위배됨

UPDATE EMPLOYEE
SET EMP_NAME = NULL
WHERE EMP_ID = 200; -- NOT NULL 제약조건 위배됨

UPDATE EMPLOYEE
SET EMP_NO = '621231-1985634'
WHERE EMP_ID = 201; -- UNIQUE 제약조건 위배됨

COMMIT;

UPDATE EMPLOYEE
SET ENT_YN = DEFAULT
WHERE EMP_ID = 222;

SELECT * FROM EMPLOYEE;

ROLLBACK;
-------------------------------------------------------------------------------------------------

-- 4. MERGE(병합)
-- 구조가 같은 두 개의 테이블을 하나로 합치는 기능
-- 테이블에 지정하는 조건의 값이 존재하면 UPDATE
-- 조건의 값이 없으면 INSERT 됨.
CREATE TABLE EMP_M01
AS SELECT * FROM EMPLOYEE;

CREATE TABLE EMP_M02
AS SELECT * FROM EMPLOYEE
   WHERE JOB_CODE = 'J4';
   
INSERT INTO EMP_M02
VALUES (999, '곽두원', '561016-1234567', 'kwack_dw@kh.or.kr', '01011112222', 
        'D9', 'J4', 'S1', 90000000, 0.5, NULL, SYSDATE, NULL, DEFAULT);

UPDATE EMP_M02
SET SALARY = 0;

SELECT * FROM EMP_M01;
SELECT * FROM EMP_M02;

MERGE INTO EMP_M01 M1 USING EMP_M02 M2 ON(M1.EMP_ID = M2.EMP_ID)
WHEN MATCHED THEN
UPDATE SET
M1.EMP_NAME = M2.EMP_NAME,
M1.EMP_NO = M2.EMP_NO,
M1.EMAIL = M2.EMAIL,
M1.PHONE = M2.PHONE,
M1.DEPT_CODE = M2.DEPT_CODE,
M1.JOB_CODE = M2.JOB_CODE,
M1.SAL_LEVEL = M2.SAL_LEVEL,
M1.SALARY = M2.SALARY,
M1.BONUS = M2.BONUS,
M1.MANAGER_ID = M2.MANAGER_ID,
M1.HIRE_DATE = M2.HIRE_DATE,
M1.ENT_DATE = M2.ENT_DATE,
M1.ENT_YN = M2.ENT_YN
WHEN NOT MATCHED THEN
INSERT VALUES(M2.EMP_ID, M2.EMP_NAME, M2.EMP_NO, M2.EMAIL, M2.PHONE, M2.DEPT_CODE, 
                M2.JOB_CODE, M2.SAL_LEVEL, M2.SALARY, M2.BONUS, M2.MANAGER_ID, M2.HIRE_DATE, M2.ENT_DATE, M2.ENT_YN);

SELECT * FROM EMP_M01;

-----------------------------------------------------------------------------------------------------------------------

-- 5. DELETE

-- 테이블의 행을 삭제하는 구문
-- 테이블의 행의 개수가 줄어듦

-- [표현식] 
-- DELETE FROM 테이블명 WHERE 조건설정
-- 만약 WHERE 조건을 설정하지 않으면 모든 행이 다 삭제됨

DELETE FROM EMPLOYEE
WHERE EMP_NAME = '장채현';

SELECT * FROM EMPLOYEE;

ROLLBACK;

DELETE FROM EMPLOYEE;

SELECT * FROM EMPLOYEE;

ROLLBACK;

DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D1'; -- FOREIGN KEY 제약조건이 설정되어 있는 경우 참조되고 있는 값에 대해서는 삭제 불가

DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D3'; -- FOREIGN KEY 제약조건이 설정되어 있어도 참조되고 있지 않은 값은 삭제 가능 
--> 포레인 키 자체는 상관없지만 다른 키에 참조되고 있으면 곤란해질 수 있으므로 참조되는 값은 삭제 안됨.

ROLLBACK;

-- 삭제 시 FOREIGN KEY 제약조건으로 컬럼 삭제가 불가능한 경우 제약조건을 비활성화 할 수 있다.
ALTER TABLE EMPLOYEE_COPY
DISABLE CONSTRAINT SYS_C007141 CASCADE;
--> EMPLOYEE_COPY의 FOREIGN KEY 비활성화

ALTER TABLE EMPLOYEE
DISABLE CONSTRAINT SYS_C007178 CASCADE;
--> EMPLOYEE의 FOREIGN KEY 비활성화
--> 제약 조건을 두 개 걸어서 EMPLOYEE_COPY꺼 삭제한 후에 또 뜨는 에러를 이중으로 비활성화 시켜야 한다.

DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D1';

SELECT * FROM DEPARTMENT;
SELECT * FROM EMPLOYEE;

ROLLBACK;

-- 비활성화된 제약 조건을 다시 활성화
ALTER TABLE EMPLOYEE
ENABLE CONSTRAINT SYS_C007178;

-- EMPLOYEE_COPY의 FOREIGN KEY 활성화
ALTER TABLE EMPLOYEE_COPY
ENABLE CONSTRAINT SYS_C007141;

-- TRUNCATE : 테이블의 전체 행을 삭제할 시 사용
--            DELETE보다 수행 속도가 더 빠름
--            ROLLBACK을 통해 복구할 수 없음(DML이 아닌 DDL 종류라서)
SELECT * FROM EMP_SALARY;
COMMIT;

-- DELETE 테스트
DELETE FROM EMP_SALARY;

SELECT * FROM EMP_SALARY;

ROLLBACK;

SELECT * FROM EMP_SALARY;

-- TRUNCATE 테스트
TRUNCATE TABLE EMP_SALARY;

SELECT * FROM EMP_SALARY;

ROLLBACK;

SELECT * FROM EMP_SALARY; -- 이미 지워져 돌이킬 수 없음.ㅋ
