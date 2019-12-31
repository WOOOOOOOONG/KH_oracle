--> SAMPLE 계정에서 작업

/*
    < 동의어 SYNONYM >
    다른 DB가 가진 객체에 대한 별명 혹은 줄임말
    여러 사용자가 테이블을 공유할 경우, 다른 사용자가 테이블에 접근할 경우
    '사용자명.테이블명' 으로 표현함
    
    * 동의어 구분
    - 비공개 동의어 : 객체에 대한 접근권한을 부여받은 사용자가 정의한 동의어로 해당 사용자만 사용 가능
    - 공개 동의어 : 모든 권한을 주는 사용자(DBA)가 정의한 동의어는 모든 사용자가 사용할 수 있음(PUBLIC) -- EX. DUAL
*/

/*
    1. SYNONYM 생성 방법(비공개 동의어) -> 해당 사용자 계정에서 만드는 방법
    [표현식]
    CREATE SYNONYM 별명(줄임말)
    FOR 사용자명.객체명;
*/

SELECT * FROM kh.EMPLOYEE;
-- 1) SELECT의 권한을 부여받아야 한다.

-- kh.EMPLOYEE 테이블의 별명을 EMP로 지정
CREATE SYNONYM EMP FOR kh.EMPLOYEE;
--> SYNONYM 또한 권한이 필요

SELECT * FROM EMP;
--> 이런 식으로 앞으로 조회 가능(단, 비공개 동의어기 때문에 SAMPLE 계정에서만 사용 가능한 동의어)

/*
    2. SYNONYM 생성 방법(공개 동의어) -> 시스템 계정에서 만드는 방법
    
    [표현식]
    CREATE PUBLIC SYNONYM 별명(줄임말)
    FOR 사용자명.객체명;
*/

-- 시스템 계정에서 공개 동의어 만든 뒤 SAMPLE 계정에서도 사용 가능한지 테스트
SELECT * FROM DEPT;
-- 공개 동의어라도 권한이 없으면 접근 불가능

-----------------------------------------------------------------------------------
-- 3. SYNONYM 삭제
DROP SYNONYM EMP;

-- 불가능
SELECT * FROM EMP;

-- 공개 동의어 삭제는 당연히 SYS 계정에서.
DROP PUBLIC SYNONYM DEPT;



