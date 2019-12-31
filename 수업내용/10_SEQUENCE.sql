-- 시퀀스(SEQUENCE)
-- 자동 번호 발생기 역할을 하는 객체
-- 순차적으로 정수 값을 자동으로 생성해줌
--> UNIQUE한 값을 컬럼에 입력할 수 있음. 일반적으로 PRIMARY KEY 값을 생성하기 위해 사용.
-- 테이블과 독립적으로 저장되고 생성되므로 하나의 시퀀스는 여러 테이블에서 사용 가능

---------------------------------------------------------------------------------
-- 1. SEQUENCE 생성

-- [표현식]
/*
    CREATE SQUENCE 시퀀스이름
    [START WITH 숫자] -- 처음 발생시킬 시작값 지정, 생략하면 자동 1이 기본
    [INCREMENT BY 숫자] -- 다음 값에 대한 증가치, 생략하면 자동 1이 기본
    [MAXVALUE 숫자 | NOMAXVALUE] -- 발생시킬 최대값 지정
    [MINVALUE 숫자 | NOMINVALUE] -- 발생시킬 최소값 지정
    [CYCLE | NOCYCLE] -- 값 순환 여부 지정
    [CACHE 바이트크기 | NOCACHE] -- 캐쉬 메모리 기본 값은 20바이트, 최소값은 2바이트
    --> 할당 된 크기만큼 미리 다음 값들을 생성해 저장해둠
*/

CREATE SEQUENCE SEQ_EMPID
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;

-- 사용자가 생성한 시퀀스 확인하기
SELECT * FROM USER_SEQUENCES;

--------------------------------------------------------------------------------

-- 2. SEQUENCE 사용
/*
    시퀀스명.CURRVAL : 현재 생성된 시퀀스의 값
    시퀀스명.NEXTVAL : 시퀀스를 증가시킴. 기존 시퀀스 값에서 증가치만큼 증가한 값.
    -> 시퀀스명.NEXTVAL = 시퀀스명.CURRVAL + INCREMENT BY로 지정한 값                   
*/

-- NEXTVAL를 실행하지 않고 방금 생성 된 시퀀스의 CURRVAL 호출 시
SELECT SEQ_EMPID.CURRVAL FROM DUAL; -- 오류 발생!!!
-- 시퀀스명.CURRVAL는 마지막으로 호출 된 시퀀스명.NEXTVAL의 값을 저장하여 보여주는 임시값

SELECT SEQ_EMPID.NEXTVAL FROM DUAL; -- 300
SELECT SEQ_EMPID.CURRVAL FROM DUAL; -- 300
SELECT SEQ_EMPID.NEXTVAL FROM DUAL; -- 305
SELECT SEQ_EMPID.CURRVAL FROM DUAL; -- 305

SELECT SEQ_EMPID.NEXTVAL FROM DUAL; -- 310
SELECT SEQ_EMPID.NEXTVAL FROM DUAL; -- 지정한 MAXVALUE값을 초과하였기 때문에 에러

SELECT * FROM USER_SEQUENCES;
-- MAX_VALUE : 310, LAST_NUMBER : 315

SELECT SEQ_EMPID.CURRVAL FROM DUAL;
-- CURRVAL은 성공적으로 호출된 마지막 NEXTVAL의 값을 저장하고 출력

/*
    CURRVAL / NEXTVAL 사용 가능 여부
    
    1) 사용 가능
    - 서브쿼리가 아닌 SELECT문
    - INSERT문의 SELECT절
    - INSERT문의 VALUES절
    - UPDATE문의 SET절
    
    2) 사용 불가
    - VIEW의 SELECT절
    - DISTINCT 키워드가 있는 SELECT문
    - GROUP BY, HAVING, ORDER BY절의 SELECT문
    - SELECT, DELETE, UPDATE문의 서브쿼리
    - CREATE TABLE, ALTER TABLE 명령의 DEFAULT값

*/

CREATE SEQUENCE SEQ_EID
START WITH 300
INCREMENT BY 1
MAXVALUE 10000
NOCYCLE
NOCACHE;

COMMIT;

-- 사용 가능 예시(INSERT문의 VALUES절)
INSERT INTO EMPLOYEE
VALUES(SEQ_EID.NEXTVAL, '김영희', '610410-2111111', 'young_123@kh.or.kr', '01012344444',
       'D1', 'J1', 'S1', 500000, 0.2, 200, SYSDATE, NULL, DEFAULT);

SELECT * FROM EMPLOYEE;

INSERT INTO EMPLOYEE
VALUES(SEQ_EID.NEXTVAL, '김철수', '810410-1222222', 'young_123@kh.or.kr', '01012344444',
       'D1', 'J1', 'S1', 500000, 0.2, 200, SYSDATE, NULL, DEFAULT);

SELECT * FROM EMPLOYEE;     

-- 사용 불가 예시(CREATE TABLE, ALTER TABLE 명령의 DEFAULT 값)
CREATE TABLE TMP_EMPLOYEE(
    E_ID NUBMER DEFAULT SEQ_EID.CURRVAL,
    E_NAME VARCHAR2(30)
);

ROLLBACK;
------------------------------------------------------------------------------
-- 3. SEQUENCE 변경
-- [표현식]
/*
    ALTER SEQUENCE 시퀀스이름
    [INCREMENT BY 숫자]
    [MAXVALUE 숫자 | NOMAXVALUE]
    [MINVALUE 숫자 | NOMINVALUE]
    [CYCLE | NOCYCLE]
    [CACHE 바이트크기 | NOCACHE];
*/
-- START WITH는 변경 불가
-- 재설정 필요 시 기존 시퀀스 DROP 후 재생성

ALTER SEQUENCE SEQ_EMPID
INCREMENT BY 10
MAXVALUE 400
NOCYCLE
NOCACHE;

-- 시퀀스 변경 확인
SELECT * FROM USER_SEQUENCES;

SELECT SEQ_EMPID.NEXTVAL FROM DUAL;
SELECT SEQ_EMPID.CURRVAL FROM DUAL;
-----------------------------------------------------------------------------
-- 4. SEQUENCE 삭제
DROP SEQUENCE SEQ_EMPID;

SELECT * FROM USER_SEQUENCES;