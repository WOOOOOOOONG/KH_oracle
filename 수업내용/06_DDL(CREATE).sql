-- DDL(CREATE)

-- DDL(DATA DEFINITION LANGUAGE) : 데이터 정의 언어
-- 데이터베이스 스키마 객체를 정의하거나 조작하는 명령어로 데이터베이스 객체들을 정의, 변경, 삭제
-- CREATE, ALTER, DROP, TRUNCATE문
-- ** 스키마 : DB의 구조와 제약 조건에 관해 전반적인 명세를 기술한 것 **

-- 객체를 만들고(CREATE), 수정하고(ALTER), 삭제(DROP)하는 등 데이터의 전체 구조를 정의하는 언어로, 주로 DB관리자, 설계자가 사용함

-- 오라클에서의 객체 : 테이블(TABLE), 뷰(VIEW), 시퀀스(SEQUENCE), 인덱스(INDEX), 패키지(PACKAGE), 트리거(TRIGGER), 프로시져(PROCEDURE),
--                    함수(FUNCTION), 동의어(SYNONYM), 사용자(USER)
----------------------------------------------------------------------------------------------------------------------------
/*
    <데이터 딕셔너리>
    - 데이터베이스의 전반적인 정보를 제공
    - 데이터베이스의 설정된 정보들을 확인 가능
    - DDL 명령이 실행될 때마다 데이터 사전에 접근하여 정보가 반영됨
    - 읽기 전용 VIEW로 생성되어 있음
*/

-----------------------------------------------------------------------------------------------------------------------------
-- CREATE
-- 테이블이나 인덱스, 뷰 등 다양한 데이터베이스 객체를 생성하는 구문
-- 테이블로 생성된 객체는 DROP구문을 통해 제거할 수 있음.

-- 1. 테이블 만들기
-- 테이블이란 ?
-- 행과 열로 구성되는 가장 기본적인 DB 객체
-- 데이터베이스 내에서 모든 데이터는 테이블 통해 저장된다.

-- [표현식]
-- CREATE TABLE 테이블명 (컬럼명 자료형(크기), 컬럼명 자료형(크기), ...);
CREATE TABLE MEMBER(
    MEMBER_ID VARCHAR2(20),
    MEMBER_PWD VARCHAR2(20),
    MEMBER_NAME VARCHAR2(20),
    MEMBER_DATE DATE DEFAULT SYSDATE -- 입력되는 값이 없거나, DEFAULT일 경우에 커럼값 지만
);
-- 만든 테이블 확인
SELECT * FROM MEMBER;

-- 컬럼에 주석 달기
-- [표현식]
-- COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
COMMENT ON COLUMN MEMBER.MEMBER_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEMBER_PWD IS '비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS  '회원이름';
COMMENT ON COLUMN MEMBER.MEMBER_DATE IS '회원가입일';

-- 레이블 주석 확인
SELECT * FROM USER_COL_COMMENTS
WHERE TABLE_NAME = 'MEMBER';

SELECT * FROM USER_TABLES;
-- USER_TABLES = 사용자가 작성한 테이블을 확인하는 뷰
-- 데이터 빅셔너리에 정의되어 있음.

 SELECT * FROM USER_TAB_COLUMNS
 WHERE TABLE_NAME = 'MEMBER';
 -- UYSER_TAB_COLUMNS : 테이블, 뷰, 클러스터 컬럼과 관련된 정보 조회
 -- 데이터 딕셔너리에 정의되어 있음
 
  INSERT INTO MEMBER VALUES('MEM1', '123ABC', '우별림', '2019-09-20');
  SELECT * FROM MEMBER;
  
  INSERT INTO MEMBER VALUES('MEM2', 'QWER1234', '김영희', SYSDATE);
  INSERT INTO MEMBER VALUES('MEM3', 'ZZ9786', '박영희', DEFAULT);
  INSERT INTO MEMBER(MEMBER_ID, MEMBER_PWD, MEMBER_NAME)
  VALUES ('MEM', 'ASDQWE', '한영희');
  
  SELECT * FROM MEMBER;
  
-----------------------------------------------------------------------------------------------------------
-- 제약 조건(CONSTRAINTS)
-- 사용자가 원하는 조건의 데이터만 유지하기 위해서 특정 컬럼에 설정하는 제약
-- 테이블 작성 시 각 칼럼에 대한 값 기록에 대한 제약 조건 설정 가능
-- 테이블 무결성 보장이 목적
-- 입력 데이터에 문제가 없는지 자동으로 검사하는 목적
-- 데이터의 수정/삭제/가능 여부 검사 등을 목적으로 함
-- PRIMARY KEY, NOT NULL, UNIQUE, CHECK, FOREIGN KEY

-- 제약 조건 확인
DESC USER_CONSTRAINTS;

SELECT * FROM USER_CONSTRAINTS;
-- USER_CONSTRAINTS : 사용자가 작성한 제약조건을 확인하는 뷰

DESC USER_CONS_COLUMNS;
SELECT * FROM USER_CONS_COLUMNS;
-- USER_CONS_COLUMNS : 제약조건이 걸려 있는 컬럼을 확인하는 뷰

-- 3. NOT NULL 
-- 해당 컬럼에 반드시 값이 기록되어야 하는 경우 사용
-- 삽입/수정 시 NULL값을 허용하지 않도록 컬럼 레벨에서 제한

-- NOT NULL 제약조건 설정을 하지 않은 경우
CREATE TABLE USER_NOCONS(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20),
    USER_PWD VARCHAR2(30),
    USER_NAME VARCHAR2(30),
    GENDER VARCHAR2(10),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50)
);

INSERT INTO USER_NOCONS
VALUES (1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr');



INSERT INTO USER_NOCONS
VALUES (2, null, null, null, null, '010-1234-5678', 'hong123@kh.or.kr');
-- 컬럼에 NULL값이 있어도 삽입 성공
SELECT * FROM USER_NOCONS;

-- NOT NULL 제약 조건 설정 O인 경우
CREATE TABLE USER_NOTNULL(
    USER_NO NUMBER NOT NULL, -- 컬럼 레벨 제약조건 설정
    USER_ID VARCHAR2(20) NOT NULL,
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30) NOT NULL,
    GENDER VARCHAR2(10),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50)
);

INSERT INTO USER_NOTNULL
VALUES (1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr');



INSERT INTO USER_NOTNULL
VALUES (2, 'user02', 'pass01', null, null, '010-1234-5678', 'hong123@kh.or.kr');
-- NOT NULL 제약조건에 위배되어 오류 발생

SELECT * FROM USER_NOTNULL;

-- 작성한 제약 조건 확인
SELECT *
FROM USER_CONSTRAINTS C1
JOIN USER_CONS_COLUMNS C2 USING(CONSTRAINT_NAME)
WHERE C1.TABLE_NAME = 'USER_NOTNULL';

-----------------------------------------------------------------------------------------------------------
-- 4. UNIQUE 제약조건
-- 컬럼의 입력 값에 대해서 중복을 제한한다는 조건
-- 컬럼 레벨과 테이블 레벨에서 설정 가능

SELECT * FROM USER_NOCONS;

-- 중복 데이터 삽입
INSERT INTO USER_NOCONS
VALUES (1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr');

SELECT * FROM USER_NOCONS;

-- UNIQUE 제약 조건 테이블 생성
CREATE TABLE USER_UNIQUE(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20) UNIQUE, -- 컬럼 레벨에서 제약조건
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30),
    GENDER VARCHAR2(10),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50)
);

-- 중복 데이터 삽입
INSERT INTO USER_UNIQUE
VALUES (1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr');

INSERT INTO USER_UNIQUE
VALUES (1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr');
--> 같은 아이디인 데이터가 이미 테이블에 있으므로 UNIQUE 제약 조건에 위배되어 오류 발생

-- 오류 보고에 나타나는 SYS_C007050 같은 제약 조건명으로
-- 해당 제약 조건이 설정된 테이블명, 컬럼, 제약 조건 타입 조회
SELECT UCC.TABLE_NAME, UCC.COLUMN_NAME, UC.CONSTRAINT_TYPE
FROM USER_CONSTRAINTS UC, USER_CONS_COLUMNS UCC
WHERE UCC.CONSTRAINT_NAME = UC.CONSTRAINT_NAME
AND UCC.CONSTRAINT_NAME = 'SYS_C007050';

-- 테이블 레벨에서 제약조건 설정
/*
    CREATE TABLE 테이블명(
        컬럼명 자료형,
        ...
        [CONSTRAINT 제약조건명] 제약조건타입 (컬럼명)
    );
*/

CREATE TABLE USER_UNIQUE2(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20),
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30),
    GENDER VARCHAR2(10),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50),
    UNIQUE(USER_ID) -- 테이블 레벨에서 제약조건 설정
);

INSERT INTO USER_UNIQUE2
VALUES (1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr');

INSERT INTO USER_UNIQUE2
VALUES (1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr');
--> 같은 아이디인 데이터가 이미 테이블에 있으므로 UNIQUE 제약 조건에 위배되어 오류 발생

-- 두 개의 컬럼을 묶어서 하나의 UNIQUE 제약 조건을 설정함
CREATE TABLE USER_UNIQUE3(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20),
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30),
    GENDER VARCHAR2(10),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50),
    UNIQUE(USER_NO, USER_ID) -- 테이블 레벨에서 제약조건 설정 (NOT NULL은 안됨)
);

INSERT INTO USER_UNIQUE3
VALUES (1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kh');

INSERT INTO USER_UNIQUE3
VALUES (2, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kh');

INSERT INTO USER_UNIQUE3
VALUES (2, 'user02', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kh');
-- > 여러 칼럼을 묶어 UNIQUE 제약 조건이 설정되어 있으면 <두 컬럼 모두 중복>되는 값일 경우에만 오류가 발생하게 된다.

SELECT UC.TABLE_NAME, UCC.COLUMN_NAME, UCC.CONSTRAINT_NAME, UC.CONSTRAINT_TYPE
FROM USER_CONSTRAINTS UC
JOIN USER_CONS_COLUMNS UCC ON(UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME)
WHERE UCC.CONSTRAINT_NAME = 'SYS_007054';
--> 두개의 UNIQUE 제약 조건이 하나의 제약 조건명으로 되어있는 것 확인(난 안나오네)

-- 제약 조건에 이름 설정
-- 제약 조건 이름 설정의 이점 : 문제가 일어난 데이터를 찾기 편하다
CREATE TABLE CONS_NAME(
    TEST_DATA1 VARCHAR2(20) CONSTRAINT NN_TEST_DATA1 NOT NULL,
    TEST_DATA2 VARCHAR2(20) CONSTRAINT UK_TEST_DATA2 UNIQUE,
    TEST_DATA3 VARCHAR2(20),
    CONSTRAINT UK_TEST_DATA3 UNIQUE(TEST_DATA3)
);

SELECT *
FROM USER_CONSTRAINTS C1
JOIN USER_CONS_COLUMNS C2 USING(CONSTRAINT_NAME)
WHERE C1.TABLE_NAME = 'CONS_NAME';

DROP TABLE CONS_NAME;

-----------------------------------------------------------------------------------------------------------
-- 5. PRIMARY KEY(기본키) 제약조건

-- 테이블에서 한 행의 정보를 찾기 위해 사용할 칼럼을 의미함
-- 테이블에 대한 식별자(IDENTIFIER) 역할을 함
-- NOT NULL + UNIQUE 제약 조건의 의미
-- 한 테이블 당 한 개의 설정만 할 수 있음
-- 컬럼 레벨, 테이블 레벨 둘 다 설정 가능
-- 한 개 컬럼에 설정할 수도 있고, 여러 개의 컬럼을 묶어 설정할 수도 있음

/*                      <기본키의 조건>
    1. 유일성 : 주식별자에 의해 엔티티 내 모든 인스턴스들을 유일하게 구분함 (UNIQUE)
    2. 존재성 : 주식별자가 지정되면 반드시 데이터 값이 존재해야 함 (NOT NULL)
    3. 최소성 : 최소한의 속성으로 식별자 구성
    4. 불변성 : 식별자가 한 번 특정 엔티티에서 지정되면 그 식별자는 변하지 않아야 함
*/

CREATE TABLE USER_PRIMARYKEY(
    USER_NO NUMBER CONSTRAINT PK_USER_NO PRIMARY KEY, -- 컬럼 레벨 지정
    USER_ID VARCHAR2(20) UNIQUE,
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30),
    GENDER VARCHAR2(10),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50)
    -- CONSTRAINT PK_USER_NO PRIMARY KEY(USER_NO) -- 테이블 레벨 지정
);

INSERT INTO USER_PRIMARYKEY
VALUES (1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr');

INSERT INTO USER_PRIMARYKEY
VALUES (1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr');
--> 기본키 중복 오류

INSERT INTO USER_PRIMARYKEY
VALUES (NULL, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr');
--> 기본키 null이므로  오류

-- 기본키를 복합키로 설정하기 (테이블 레벨에서만 설정 가능)
CREATE TABLE USER_PRIMARYKEY2(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20) UNIQUE,
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30),
    GENDER VARCHAR2(10),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50),
    CONSTRAINT PK_USERNO_USERID PRIMARY KEY(USER_NO, USER_ID) -- 복합키
);

INSERT INTO USER_PRIMARYKEY2
VALUES (1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr');

INSERT INTO USER_PRIMARYKEY2
VALUES (1, 'user02', 'pass02', '이순신', '남', '010-1234-5679', 'LEE123@kh.or.kr');

INSERT INTO USER_PRIMARYKEY2
VALUES (2, 'user01', 'pass01', '유관순', '여', '010-1234-5670', 'YOO123@kh.or.kr');
-- USER_ID 속성에 유니크가 따로 걸려있어서 안됨

-- 복합키는 둘 중 하나만 바뀌면 잘 들어감.

-- 6. FOREIGN KEY(외부키 / 외래키) 제약 조건

-- 참조된 다른 테이블이 제공하는 값만 사용할 수 있다
-- FOREIGN KEY 제약조건에 의해서 테이블간의 관계가 형성됨
-- 제공하는 값 외에는 NULL을 사용할 수 있음

-- 컬럼 레벨의 경우
-- 컬럼명 자료형(크기) [CONSTRAINT 이름] PREFERENCES 참조할테이블명 [(참조할컬럼)] [삭제룰]

-- 테이블 레벨의 경우
-- [CONSTRAINT 이름] FOREIGN KEY (적용할 컬럼명) PREFERENCES 참조할테이블명 [(참조할컬럼)] [삭제룰]

-- *참조될 수 있는 컬럼은 RPIMARY KEY 컬럼과 UNIQUE로 지정된 컬럼만 외래키로 사용할 수 있음*
-- *참조할 테이블의 참조할 컬럼명이 생략이 되면, PRIMARY KEY로 설정된 컬럼이 자동으로 참조할 컬럼이 됨*
CREATE TABLE USER_GRADE(
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30) NOT NULL
);

INSERT INTO USER_GRADE VALUES (10, '일반회원');
INSERT INTO USER_GRADE VALUES (20, '우수회원');
INSERT INTO USER_GRADE VALUES (30, '특수회원');

SELECT * FROM USER_GRADE;

CREATE TABLE USER_FOREIGNKEY(
    USER_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(20) UNIQUE,
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30),
    GENDER VARCHAR2(10),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50),
    GRADE_CODE NUMBER,
    CONSTRAINT FK_GRADE_CODE FOREIGN KEY (GRADE_CODE) REFERENCES USER_GRADE(GRADE_CODE)
);

INSERT INTO USER_FOREIGNKEY
VALUES (1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr', 10);

INSERT INTO USER_FOREIGNKEY
VALUES (2, 'user02', 'pass02', '이순신', '남', '010-5678-9012', 'lee123@kh.or.kr', 10);

INSERT INTO USER_FOREIGNKEY
VALUES (3, 'user03', 'pass03', '유관순', '여', '010-4412-5915', 'YOO123@kh.or.kr', 30);

INSERT INTO USER_FOREIGNKEY
VALUES (4, 'user04', 'pass04', '안중금', '남', '010-5555-5555', 'ahn123@kh.or.kr', null);
--> 기존의 존재하는 값 + null을 넣어도 가능하다

SELECT * FROM USER_FOREIGNKEY;

INSERT INTO USER_FOREIGNKEY

VALUES (5, 'user05', 'pass05', '윤봉길', '남', '010-6666-1234', 'yoon123@kh.or.kr', 50);
--> 50이라는 값은 USER_GRADE 테이블 GRADE_CODE 컬럼에서 제공하는 값이 아니어서 외래키 제약 조건에 위배되어 오류 발생

-- [참고] 자연 조인
-- USER_FOREIGNKEY 테이블에서
-- 회원 아이디, 이름, 성별, 연락처, 회원등급명 조회
SELECT USER_ID, USER_NAME, GENDER, PHONE, GRADE_NAME
FROM USER_FOREIGNKEY
--LEFT JOIN USER_GRADE USING(GRADE_CODE);
NATURAL LEFT JOIN USER_GRADE;
--> 동일한 타입, 이름을 가진 컬럼이 있다면 자동으로 조인해주는 방법

-- *FOREIGN KEY 삭제옵션
-- 부모 테이블의 데이터 삭제 시 자식 테이블의 데이터를 어떤식으로 처리할지에 대한 내용을 설정할 수 있음
SELECT * FROM USER_GRADE;

DELETE FROM USER_GRADE
WHERE GRADE_CODE = 10;
-- ON DELETE RESTRICTED(삭제 제한)로 기본 지정되어 있음
-- FOREIGN KEY로 지정된 컬럼에서 사용되고 있는 값일 경우 제공하는 컬럼의 값은 삭제하지 못함

COMMIT; 
DELETE FROM USER_GRADE
WHERE GRADE_CODE = 20;
-- GRADE_CODE 중 20은 외래키로 참조되고 있지 않아서 삭제 가능

SELECT * FROM USER_GRADE;
ROLLBACK;
SELECT * FROM USER_GRADE;

-- ON DELETE SET NULL : 부모키 삭제시 자식키를 NULL로 변경하는 옵션
CREATE TABLE USER_GRADE2(
    GRADE_CODE2 NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30) NOT NULL
);
INSERT INTO USER_GRADE2 VALUES (10, '일반회원');
INSERT INTO USER_GRADE2 VALUES (20, '우수회원');
INSERT INTO USER_GRADE2 VALUES (30, '특수회원');

SELECT * FROM USER_GRADE2;

CREATE TABLE USER_FOREIGNKEY2(
    USER_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(20) UNIQUE,
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30),
    GENDER VARCHAR2(10),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50),
    GRADE_CODE NUMBER,
    CONSTRAINT FK_GRADE_CODE2 FOREIGN KEY (GRADE_CODE) REFERENCES USER_GRADE2(GRADE_CODE2) ON DELETE SET NULL
);

INSERT INTO USER_FOREIGNKEY2
VALUES (1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr', 10);

INSERT INTO USER_FOREIGNKEY2
VALUES (2, 'user02', 'pass02', '이순신', '남', '010-5678-9012', 'lee123@kh.or.kr', 10);

INSERT INTO USER_FOREIGNKEY2
VALUES (3, 'user03', 'pass03', '유관순', '여', '010-4412-5915', 'YOO123@kh.or.kr', 30);

INSERT INTO USER_FOREIGNKEY2
VALUES (4, 'user04', 'pass04', '안중금', '남', '010-5555-5555', 'ahn123@kh.or.kr', null);

COMMIT;

SELECT * FROM USER_GRADE2;
SELECT * FROM USER_FOREIGNKEY2;

DELETE FROM USER_GRADE2
WHERE GRADE_CODE = 10;

SELECT * FROM USER_GRADE2;
SELECT * FROM USER_FOREIGNKEY2;

ROLLBACK;

-- ON DELETE CASCADE
-- 부모키 삭제시 값을 사용하는 자식 테이블의 컬럼에 해당하는 행이 삭제됨
CREATE TABLE USER_GRADE3(
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30) NOT NULL
);
INSERT INTO USER_GRADE3 VALUES (10, '일반회원');
INSERT INTO USER_GRADE3 VALUES (20, '우수회원');
INSERT INTO USER_GRADE3 VALUES (30, '특수회원');

SELECT * FROM USER_GRADE3;

CREATE TABLE USER_FOREIGNKEY3(
    USER_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(20) UNIQUE,
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30),
    GENDER VARCHAR2(10),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50),
    GRADE_CODE NUMBER,
    CONSTRAINT FK_GRADE_CODE3 FOREIGN KEY (GRADE_CODE) REFERENCES USER_GRADE3(GRADE_CODE) ON DELETE CASCADE
);
INSERT INTO USER_FOREIGNKEY3
VALUES (1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr', 10);

INSERT INTO USER_FOREIGNKEY3
VALUES (2, 'user02', 'pass02', '이순신', '남', '010-5678-9012', 'lee123@kh.or.kr', 10);

INSERT INTO USER_FOREIGNKEY3
VALUES (3, 'user03', 'pass03', '유관순', '여', '010-4412-5915', 'YOO123@kh.or.kr', 30);

INSERT INTO USER_FOREIGNKEY3
VALUES (4, 'user04', 'pass04', '안중금', '남', '010-5555-5555', 'ahn123@kh.or.kr', null);

COMMIT;

SELECT * FROM USER_GRADE3;
SELECT * FROM USER_FOREIGNKEY3;

DELETE FROM USER_GRADE3
WHERE GRADE_CODE = 10;

ROLLBACK;

---------------------------------------------------------------------------------------------------------------------
-- 7. CHECK 제약조건 : 컬럼에 기록되는 값에 조건 설정을 할 수 있음
-- CHECK (컬럼명 비교연산자 비교값)
-- 주의 : 비교값은 리터럴만 사용할 수 있음, 변하는 값이나 함수 사용 못함
CREATE TABLE USER_CHECK(
    USER_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(20) UNIQUE,
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30),
    GENDER VARCHAR2(10) CHECK (GENDER IN ('남', '여')),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50)
);

INSERT INTO USER_CHECK
VALUES (1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr');

INSERT INTO USER_CHECK
VALUES (2, 'user02', 'pass02', '홍길동', '남자', '010-1234-5678', 'hong123@kh.or.kr');
--> GENDER 컬럼에는 CHECK 제약조건으로 남, 여 만 기록 가능
-- violate : 위반하다

CREATE TABLE TEST_CHECK(
    TEST_NUMBER NUMBER,
    CONSTRAINT CK_TEST_NUMBER CHECK(TEST_NUMBER > 0)
);

INSERT INTO TEST_CHECK
VALUES (10);

INSERT INTO TEST_CHECK
VALUES (-10);

CREATE TABLE TBLCHECK (
    C_NAME VARCHAR2(15),
    C_PRICE NUMBER,
    C_LEVEL CHAR(1),
    C_DATE DATE,
    CONSTRAINT TBCH_NAME_PK PRIMARY KEY(C_NAME),
    CONSTRAINT TBCH_PRICE CHECK(C_PRICE >= 1 AND C_PRICE <= 99999),
    CONSTRAINT TBCH_LEVEL CHECK(C_LEVEL = 'A' OR C_LEVEL = 'B' OR C_LEVEL = 'C'),
    CONSTRAINT TBCH_DATE CHECK(C_DATE >= TO_DATE('2016/01/01', 'YYYY/MM/DD'))
);
-- TBCH_PRICE
INSERT INTO TBLCHECK
VALUES ('홍길동', 0, 'A', '2017/01/01');

-- TBCH_LEVEL
INSERT INTO TBLCHECK
VALUES ('홍길동', 1, 'D', '2017/01/01');

-- TBCH_DATE
INSERT INTO TBLCHECK
VALUES ('홍길동', 1, 'A', '2015/01/01');

-- [실습 문제]
--회원가입용 테이블 생성(USER_TEST)
--컬럼명 : USER_NO(회원번호) - 기본키(PK_USER_NO2),
--        USER_ID(회원아이디) - 중복 금지(UK_USER_ID),
--        USER_PWD(회원비밀번호) - NULL값 허용 안함(NN_USER_PWD),
--        PNO(주민등록번호) - 중복금지(UK_PNO), NULL 사용 안함(NN_PNO),
--        GENDER(성별) - '남' 혹은 '여' 입력(CK_GENDER),
--        PHONE(연락처),
--        ADDRESS(주소),
--        STATUS(탈퇴여부) - NOT NULL(NN_STATUS), 'Y' 혹은 'N'으로 입력(CK_STATUS)
--        탈퇴 여부는 입력 값이 없으면 'N' 으로 입력
--각 컬럼의 제약조건에 이름 부여할 것
--각 컬럼에 코멘트 추가할 것
--5명 이상 INSERT 할 것
--테이블 전체 조회, 코멘트 조회, 제약조건 조회 할 것

CREATE TABLE USER_TEST(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20),
    USER_PWD VARCHAR2(30) CONSTRAINT NN_USER_PWD NOT NULL,
    PNO VARCHAR2(20),
    GENDER VARCHAR2(5) CONSTRAINT CK_GENDER CHECK (GENDER IN ('남', '여')), CONSTRAINT CK_STATUS CHECK (STATUS IN ('Y', 'N')),
    PHONE VARCHAR2(20),
    ADDRESS VARCHAR2(30),
    STATUS VARCHAR2(5) DEFAULT 'N' CONSTRAINT NN_STATUS NOT NULL, -- 탈퇴 여부
    CONSTRAINT PK_USER_NO2 PRIMARY KEY(USER_NO),
    CONSTRAINT UK_USER_ID UNIQUE(USER_ID),
    CONSTRAINT UK_PNO UNIQUE(USER_PWD)
);

COMMENT ON COLUMN USER_TEST.USER_NO IS '회원번호';
COMMENT ON COLUMN USER_TEST.USER_ID  IS '회원아이디';
COMMENT ON COLUMN USER_TEST.USER_PWD IS '회원비밀번호';
COMMENT ON COLUMN USER_TEST.PNO IS '주민등록번호';
COMMENT ON COLUMN USER_TEST.GENDER IS '성별';
COMMENT ON COLUMN USER_TEST.PHONE IS '연락처';
COMMENT ON COLUMN USER_TEST.ADDRESS IS '주소';
COMMENT ON COLUMN USER_TEST.STATUS IS '탈퇴여부';

INSERT INTO USER_TEST
VALUES (1, 'user01', 'pass01', '590101-1075121', '남', '010-8123-2075', '서울 강남구 신사동', 'N');

INSERT INTO USER_TEST
VALUES (2, 'user02', 'pass02', '770405-1022121', '남', '010-4763-5912', '서울 강남구 논현동', 'N');

INSERT INTO USER_TEST
VALUES (3, 'user03', 'pass03', '881211-2052212', '여', '010-2020-1414', '서울 강남구 청담동', 'Y');

INSERT INTO USER_TEST
VALUES (4, 'user04', 'pass04', '950506-2525251', '여', '010-7741-2995', '인천 서구 석남동', 'N');

INSERT INTO USER_TEST
VALUES (5, 'user05', 'pass05', '001231-3015521', '남', '010-4412-5585', '인천 동구 월미로', 'Y');

SELECT * FROM USER_TEST;

SELECT * FROM USER_COL_COMMENTS
WHERE TABLE_NAME = 'USER_TEST';

SELECT *
FROM USER_CONSTRAINTS C1
JOIN USER_CONS_COLUMNS C2 USING(CONSTRAINT_NAME)
WHERE C1.TABLE_NAME = 'USER_TEST';
SELECT * FROM USER_CONS_COLUMNS;

------------------------------------------------------------------------------------------------------------------------
-- 8. SUBQUERY를 이용한 테이블 생성
-- 컬럼명, 데이터 타입, 값이 복사되고, *제약조건은 NOT NULL만 복사됨*
CREATE TABLE EMPLOYEE_COPY
AS SELECT * FROM EMPLOYEE;

SELECT * FROM EMPLOYEE_COPY;

CREATE TABLE EMPLOYEE_COPY2
AS SELECT EMP_ID, EMP_NAME, SALARY, DEPT_TITLE, JOB_NAME
   FROM EMPLOYEE
   LEFT JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
   LEFT JOIN JOB USING(JOB_CODE);
   
SELECT * FROM EMPLOYEE_COPY2;

---------------------------------------------------------------------------------------------------------------------------
-- 9. 제약조건 추가
-- ALTER TABLE 테이블명 ADD PRIMARY KEY(컬럼명)
-- ALTER TABLE 테이블명 ADD FOREIGN KEY(컬럼명) REFERENCES 테이블명
-- ALTER TABLE 테이블명 ADD UNIQUE(컬럼명)
-- ALTER TABLE 테이블명 ADD CHECK(컬럼명 비교연산자 비교값)
-- ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL
SELECT *
FROM USER_CONSTRAINTS C1
JOIN USER_CONS_COLUMNS C2 USING(CONSTRAINT_NAME)
WHERE C1.TABLE_NAME = 'EMPLOYEE_COPY';

-- NOT NULL 제약조건만 복사된 EMPLOYEE_COPY 테이블에 EMP_ID 컬럼을 PRIMARY KEY로 되도록 제약조건을 추가한다
ALTER TABLE EMPLOYEE_COPY ADD PRIMARY KEY (EMP_ID);

--EMPLOYEE_COPY 테이블의 DEPT_CODE에 외래키 제약조건 추가
-- 참조 테이블은 DEPARTMENT, 참조 컬럼은 DEPARTMENT의 기본키
ALTER TABLE EMPLOYEE_COPY ADD FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT; -- 컬럼 키 따로 지정 안하면 알아서 거기의 기본키가 잡힘 아니면 테이블명(컬럼)

ALTER TABLE EMPLOYEE_COPY ADD UNIQUE(EMP_NO);

-- EMPLOYEE_COPY 테이블의 ENT_YN 컬럼에 'Y' 또는 'N'만 입력할 수 있도록 제약조건 추가
ALTER TABLE EMPLOYEE_COPY ADD CHECK (ENT_YN IN ('Y', 'N'));

-- EMPLOYEE_COPY 테이블의 EMAIL 컬럼에 NOT NULL 제약조건 추가
ALTER TABLE EMPLOYEE_COPY MODIFY EMAIL NOT NULL;





