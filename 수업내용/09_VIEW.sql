-- VIEW(뷰)
-- SELECT 쿼리의 실행 결과를 화면에 저장한 논리적 *가상* 테이블

-- SELECT 쿼리 실행의 결과 화면을 저장한 객체
-- 논리적인 가상 테이블
-- 실질적으로 데이터를 저장하지 않는다
-- 테이블을 사용하는 것과 동일하게 사용 가능

-- 사용 이유 ?
-- 특정 데이터나 컬럼의 정보를 선별적으로 보여줄 수 있음(민감한 정보 보호)
-- 사용 빈도가 높은 복잡한 쿼리가 있다면 이를 VIEW로 만들어 사용하면 편리하다.

-- [표현식]
-- CREATE [OR REPLACE] VIEW 뷰이름 AS 서브쿼리
-- [OR REPLACE] : 뷰 생성시 기존에 같은 이름의 뷰가 있다면 해당 경로 부정
--> OR REPLACE 구문없이 같은 이름의 뷰 생성시 이미 다른 객체가 사용중이라고 에러 발생.

-- [참고]
-- 뷰에 대한 정보를 확인하는 데이터 딕셔너리
SELECT *
FROM USER_VIEWS;

--------------------------------------
-- 1. VIEW 사용 예시
-- 사번, 이름, 부서명, 근무지역을 조회하고 극 결과를 V_EMPLOYEE라는 뷰를 생성해서 저장
CREATE TABLE V_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
LEFT JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
LEFT JOIN NATIONAL USING(NATIONAL_CODE);

--> * ORA-01031 : INSUFFICIENT PRILIEGE(오류 발생)

-- 1) SYSTEM 계정 로그인
-- 2) KH계정에 뷰 생성 권한 부여
SELECT * FROM V_EMPLOYEE;

-- 뷰 조회
SELECT * FROM V_EMPLOYEE;

-- *** 베이스 테이블의 정보가 변경이 되면 VIEW도 변경됨 ***
COMMIT;

-- 사번 205번인 직원의 이름을 '정중앙'으로 변경
UPDATE EMPLOYEE
SET EMP_NAME = '정중앙'
WHERE EMP_ID = 205;

-- 베이스 테이블 확인
SELECT * FROM EMPLOYEE WHERE EMP_ID = 205;

SELECT * FROM V_EMPLOYEE
WHERE EMP_ID = 205;

ROLLBACK;

-- 생성 된 뷰 컬럼에 별칭 부여
-- 서브쿼리의 SELECT절에 함수가 사용된 경우 반드시 별칭 지정
-- 뷰 서브쿼리 안에 연산의 결과도 포함될 수 있다.
CREATE OR REPLACE VIEW V_EMP_JOB(사번, 이름, 직급, 성별, 근무년수) -- 별칭 없으면 에러
AS SELECT EMP_ID, EMP_NAME, JOB_NAME, DECODE(SUBSTR(EMP_NO, 8), 1, '남', 2, '여'),
          EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
   FROM EMPLOYEE
   JOIN JOB USING(JOB_CODE);
   
SELECT * FROM V_EMP_JOB;
   
DROP VIEW V_EMP_JOB;

-- 생성된 뷰를 이용해 DML(INSERT, UPDATE, DELETE) 사용 가능
-- 뷰에서 요청한 DML 구문은 베이스 테이블도 변경함.
CREATE OR REPLACE VIEW V_JOB
AS SELECT JOB_CODE, JOB_NAME
   FROM JOB;
   
SELECT * FROM V_JOB;

-- 뷰에 INSERT 사용
INSERT INTO V_JOB VALUES('J8', '인턴');

-- 베이스 테이블도 변경되었는지 확인
SELECT * FROM V_JOB;
--> JOB에도 들어옴

-- 뷰에 UPDATE 사용
UPDATE V_JOB
SET JOB_NAME = '알바'
WHERE JOB_CODE = 'J8';

SELECT * FROM V_JOB;
SELECT * FROM JOB;

DELETE FROM V_JOB
WHERE JOB_CODE = 'J8';

SELECT * FROM V_JOB;
SELECT * FROM JOB;

----------------------------------------------------------------
-- 2. DML 명령어로 조작이 불가능한 경우
-- 1) 뷰 정의에 포함되지 않은 컬럼을 조작하는 경우
CREATE OR REPLACE VIEW V_JOB2
AS SELECT JOB_CODE
   FROM JOB;
   
SELECT * FROM V_JOB2;
--> INSERT INTO V_JOB2 VALUES('J8', '인턴'); -> 안됨

UPDATE V_JOB2
SET JOB_NAME = '인턴'
WHERE JOB_CODE = 'J7';
-- 안되는 예시 1, 1
DELETE FROM V_JOB2
WHERE JOB_NAME = '사원';

-- 뷰에 정의된 컬럼만 조작 가능
INSERT INTO V_JOB VALUES('J8');
SELECT * FROM JOB;

-- 삭제하기
DELETE FROM JOB
WHERE JOB_CODE = 'J8';


-- 2) 뷰에 포함되지 않은 컬럼 중에, 베이스가 되는 테이블 컬럼이 NOT NULL 제약조건이 지정된 경우(INSERT시 오류. NOT NULL이면 안되니까)
CREATE OR REPLACE VIEW V_JOB3
AS SELECT JOB_NAME
    FROM JOB;
    
SELECT * FROM V_JOB3;

INSERT INTO V_JOB3 VALUES ('인턴');
INSERT INTO V_JOB3 VALUES ('JB', '인턴');
-- 에러 남

-- UPDATE/DELETE는 가능
INSERT INTO JOB VALUES ('J8', '인턴'); -- 베이스 테이블
UPDATE V_JOB3 SET JOB_NAME = '알바' WHERE JOB_NAME = '인턴';

DELETE FROM V_JOB3 WHERE JOB_NAME = '알바';


-- 3) 산술표현식으로 정의된 경우
CREATE OR REPLACE VIEW EMP_SAL
AS SELECT EMP_ID, EMP_NAME, SALARY,
         (SALARY + (SALARY*NVL(BONUS,0)))*12 연봉
   FROM EMPLOYEE;

SELECT * FROM EMP_SAL;

-- 뷰에 산술 계산식이 포함된 경우 INSERT/UPDATE 시 에러 발생
INSERT INTO EMP_SAL VALUES(800, '정진훈', 3000000, 3600000);
--안됨
UPDATE EMP_SAL
SET 연봉 = 8000000
WHERE EMP_ID = 200;
-- 안됨
COMMIT;
DELETE FROM EMP_SAL
WHERE 연봉 = 124800000; -- 선동일

SELECT * FROM EMP_SAL;
SELECT * FROM EMPLOYEE;

ROLLBACK;


-- 4) 그룹함수나 GROUP BY절을 표함한 경우
CREATE OR REPLACE VIEW V_GROUPDEPT
AS SELECT DEPT_CODE, SUM(SALARY) 합계, AVG(SALARY) 평균
   FROM EMPLOYEE
   GROUP BY DEPT_CODE;

SELECT * FROM V_GROUPDEPT;

-- 그룹함수 또는 GROUP BY 함수를 사용한 경우 INSERT/UPDATE/DELETE 안됨.
INSERT INTO V_GROUPDEPT
VALUES ('D10', 600000, 4000000); --에러

UPDATE V_GROUPDEPT
SET DEPT_CODE = 'D10'
WHERE DEPT_CODE = 'D1'; -- 에러

DELETE FROM V_GROUPDEPT
WHERE DEPT_CODE = 'D1';


-- 5) DISTINCT를 포함한 경우 (INSERT, UPDATE, DELETE 다 안됨)
CREATE OR REPLACE VIEW V_DT_EMP
AS SELECT DISTINCT JOB_CODE
   FROM EMPLOYEE;
   
SELECT * FROM V_DT_EMP;

INSERT INTO V_DT_EMP VALUES('J9'); -- ERROR
UPDATE V_DT_EMP SET JOB_CODE = 'J9' WHERE JOB_CODE = 'J7'; -- ERROR
DELETE FROM V_DT_EMP WHERE JOB_CODE = 'J1'; -- ERROR


-- 6) JOIN을 이용해 여러 테이블을 연결한 경우 (INSERT, UPDATE 불가능 DELETE 가능)
CREATE OR REPLACE VIEW V_JOINEMP
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE
   FROM EMPLOYEE
   JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE);
   
INSERT INTO V_JOINEMP VALUES ('22521', '임웅', '통신과'); --ERROR
UPDATE V_JOINEMP SET EMP_NAME = '신환' WHERE EMP_NAME = '임웅'; -- ERROR. 참고로 두 개 테이블에 걸쳐있는 컬럼이 아니면 업데이트 가능. 그럼 INSERT도 안걸쳐있으면 가능하겠네
DELETE FROM V_JOINEMP WHERE EMP_NAME = '임웅'; -- 가능

SELECT * FROM V_JOINEMP;

---------------------------------------------------------------------------------------------------------------------
-- 3. VIEW 구조
-- 뷰 정의 시 사용한 쿼리 문장이 TEXT 컬럼에 저장되어 있으며
-- 뷰가 실행될 때는 TEXT에 기록된 SELECT에 문자이 다시 실행되면서 결과를 보여주는 구조

-- 사용자 정의 뷰 확인 데이터 딕셔너리(USER_VIEWS)
SELECT * FROM USER_VIEWS; -- 내가 정의한 VIEW들의 구조가 나온다.

---------------------------------------------------------------------------------------------------------------------
-- 4) VIEW 옵션
-- VIEW 생성 표현식
/*
    CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW 뷰이름 [(ALIAS[, ALIAS]...]
    AS SUBQUERY
    [WITH CHECK OPTION]
    [WITH READ ONLY];
*/

-- 1) OR REPLACE : 기존에 동일한 뷰 이름이 존재하는 경우 덮어쓰고, 존재하지 않으면 새로 생성
-- 2) FORCE | NOFORCE
--    FORCE : 서브쿼리에 사용된 테이블이 존재하지 않아도 뷰 생성
--    NOFORCE : 서브쿼리에 사용된 테이블이 존재해야만 뷰 생성(NOFORCE가 기본값)
-- 3) WITH CHECK OPTION : 옵션을 설정한 컬럼의 값을 수정 불가능하게 함
-- 4) WITH READ ONLY : 뷰에 대해 조회만 가능(DML 수행 불가)
---------------------------------------------------------------------------------------------------------------------
-- 1) OR REPLACE 옵션 : 기존에 동일한 뷰 이름이 존재하는 경우 덮어쓰고, 존재하지 않으면 새로 생성
CREATE OR REPLACE VIEW V_EMP2
AS SELECT EMP_NO, EMP_NAME 
   FROM EMPLOYEE;

SELECT * FROM V_EMP2;

-- OR REPLACE 옵션 사용 시 덮어쓰기
CREATE OR REPLACE VIEW V_EMP2
AS SELECT EMP_NO, EMP_NAME, SALARY
   FROM EMPLOYEE;
   
SELECT * FROM V_EMP2;

-- OR REPLACE 옵션 제거 시 덮어쓰기 되지 않음
CREATE VIEW V_EMP2
AS SELECT EMP_NO, EMP_NAME, SALARY
   FROM EMPLOYEE;
   
SELECT * FROM V_EMP2;

-------------------------------------------
-- 2) FORCE / NOFORCE
CREATE OR REPLACE FORCE VIEW V_EMP
AS SELECT TCODE, TNAME, TCONTENT
   FROM TT;
-- 경고 메시지가 뜨고 뷰 생성은 성공함

SELECT * FROM V_EMP;
SELECT * FROM USER_VIEWS;

-- 뷰 생성 불가능. 
CREATE OR REPLACE NOFORCE VIEW V_EMP
AS SELECT TCODE, TNAME, TCONTENT
   FROM TT;
   
-----------------------------------------
-- 3) WITH CHECK OPTION : 옵션을 설정한 컬럼의 값을 수정 불가능하게 함(삭제는 가능). WHERE 조건 뒤에다
CREATE OR REPLACE VIEW V_EMP3
AS SELECT * FROM EMPLOYEE
WHERE DEPT_CODE = 'D1' WITH CHECK OPTION;

INSERT INTO V_EMP3
VALUES(666, '오현정', '6666666-6666666', 'oh_hj@kh.or.kr', '01012344321', 'D1', 'J7', 'S1', 
        8000000, 0.1, 201, SYSDATE, NULL, DEFAULT);

UPDATE V_EMP3
SET DEPT_CODE = 'D2'
WHERE DEPT_CODE = 'D1';

COMMIT;

-- 삭제만 가능
DELETE FROM V_EMP3
WHERE DEPT_CODE = 'D1';

ROLLBACK;

----------------------
-- 4) WITH READ ONLY : 뷰에 대해 조회만 가능(DML 수행 불가)
CREATE OR REPLACE VIEW V_DEPT
AS SELECT * FROM EMPLOYEE 
WHERE DEPT_CODE = 'D1'
WITH READ ONLY;
-- 마지막에 달아주기

-----------
-- 인라인 뷰 : 별칭으로 사용하는 것과 같이 뷰를 생성 후 객체를 다룰 수 있는 방법을 말하는듯.