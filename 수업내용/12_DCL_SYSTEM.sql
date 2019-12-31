/*
    DCL(DATA CONTROL LANGUAGE) : 데이터를 제어하는 언어
    : 데이터베이스, 데이터베이스 객체에 대한 접근 권한을 제어(부여, 회수)
      하는 언어.
    GRANT(부여), REVOKE(회수)
    
    시스템 권한 : 사용자에게 시스템 권한을 부여하는 권한
                (객체 생성 권한 등)    
    객체 권한 : 특정 객체를 조작할 수 있는 권한
*/

/*
    시스템 권한 종류
    
    - CREATE SESSION : 데이터베이스 접속 권한
    - CREATE TABLE : 테이블 생성 권한
    - CREATE VIEW : 뷰 생성 권한
    - CREATE SEQUENCE : 시퀀스 생성 권한
    - CREATE PROCEDURE : 프로시져 생성 권한
    - CREATE USER : 계정 생성 권한
    - DROP USER : 계정 삭제 권한
    - DROP ANY TABLE : 임의 테이블 삭제 권한
    등등...
    [표기법]
    GRANT 권한1, 권한2, ... TO 사용자이름;
*/

-- 1. SAMPLE 계정 생성
CREATE USER SAMPLE IDENTIFIED BY SAMPLE;

-- 2. 해당 계정에 접속하기 위해서 CREATE SESSION 권한 부여
GRANT CREATE SESSION TO SAMPLE;

-- 3_1. 해당 계정에서 테이블을 생성할 수 있는 CREATE TABLE 권한 부여
GRANT CREATE TABLE TO SAMPLE;

-- 3_2. 테이블 스페이스 할당량 부여
--      테이블 스페이스 : 테이블, 뷰, 인덱스 등등 DB 객체들이 저장되는 공간
ALTER USER SAMPLE QUOTA 2M ON SYSTEM;
----------------------------------------------------------
/*
    객체 권한
    특정 객체들을 조작할 수 있는 권한
    
    권한 종류        설정 객체
    SELECT          TABLE, VIEW, SEQUENCE
    INSERT          TABLE, VIEW
    UPDATE          TABLE, VIEW
    DELETE          TABLE, VIEW
    ALTER           TABLE, SEQUENCE
    REFERENCES      TABLE
    등등
    
    [표기법]
    GRANT 권한종류[(컬럼명)] | ALL
    ON 객체명|ROLE이름|PUBLIC
    TO 사용자이름

*/
SELECT *
FROM DBA_SYS_PRIVS
--WHERE GRANTEE = 'CONNECT';
WHERE GRANTEE = 'RESOURCE';

-- 4. SELECT 권한 부여
GRANT SELECT
ON kh.EMPLOYEE
TO SAMPLE;

-- 5. INSERT 권한 부여
GRANT INSERT
ON kh.DEPARTMENT
TO SAMPLE;

-- 6. 권한 회수
REVOKE SELECT
ON kh.EMPLOYEE
FROM SAMPLE;








