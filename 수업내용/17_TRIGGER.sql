/*
    < TRIGGER >
    테이블이나 뷰가 INSERT, UPDATE, DELETE 등의 DML문에 의해 변경될 경우
    (테이블 이벤트 발생 시)
    자동으로(묵시적으로) 실행될 내용을 정의하여 저장하는 객체
    즉, DML 데이터 상태의 관리 자동화가 가능
    
    1. 트리거 장점
    - 자료의 무결성 유지
    - 변경된 자료 및 변경한 유저를 기록해서 테이블의 변경정보 감시
    - 지정한 이벤트(DML)가 발생할 때마다 자동으로 실행되는 PL/SQL 블럭
     --> 자동 호출(호출문 따로 필요없음)
     
     2. 트리거 종류
     - SQL문의 실행 시기에 따른 분류
       > BEFORE TRIGGER : SQL문 실행 전 트리거 실행
       > AFTER TRIGGER : SQL문 실행 후 트리거 실행
    
     - SQL문에 의해 영향을 받는 각 ROW에 따른 분류
       > ROW TRIGGER : SQL문 각 ROW에 대해 한번씩 실행
                       트리거 생성 시 FOR EACH ROW 옵션 작성
                       > : OLD : 참조 전 열의 값
                        (INSERT : 입력 전 자료, UPDATE : 수정 전 자료, DELETE : 삭제할 자료)
                       > : NEW : 참조 후 열의 값
                        (INSERT : 입력 할 자료, UPDATE : 수정 할 자료)
       > STATEMENT TRIGGER : SQL문에 대해 한번만 시행(DEFAULT TRIGGER)
       
       3. 트리거 생성 방법
       [표현식]
       CREATE [OR REPLACE] TRIGGER 트리거명
       BEFORE | AFTER
       INSERT | UPDATE | DELETE
       ON 테이블명
       [FOR EACH ROW] -- ROW TRIGGER 옵션
       [WHEN 조건]
       DECLARE
            선언부
       BEGIN
            실행부
       [EXCEPTION]
       END;
       /
*/

-- EMPLOYEE 테이블에 새로운 행이 INSERT 될 때 자동으로 메시지 출력하는 트리거 생성
CREATE OR REPLACE TRIGGER TRG_01
AFTER INSERT
ON EMPLOYEE
BEGIN 
    DBMS_OUTPUT.PUT_LINE('신입사원이 입사했습니다.');
END;
/

INSERT INTO EMPLOYEE
VALUES(905, '길성춘', '670512-1151432', 'gil_sj@kh.or.kr', '01035464444', 
        'D5', 'J3', 'S5', 3000000, 0.1, 200, SYSDATE, NULL, DEFAULT);

ROLLBACK;

-- 상품 입고 출고 관련 예시

-- 상품 정보 테이블
CREATE TABLE PRODUCT(
    PCODE NUMBER PRIMARY KEY, -- 상품 코드
    PNAME VARCHAR2(30), -- 상품명
    BRAND VARCHAR2(30), -- 브랜드명
    PRICE NUMBER, -- 가격
    STOCK NUMBER DEFAULT 0 -- 재고
);

-- 상품 입출고 상세 이력 테이블
CREATE TABLE PRO_DETAIL(
    DCODE NUMBER PRIMARY KEY, -- 상세 코드
    PCODE NUMBER, -- 상품 코드(외래키)
    PDATE DATE, -- 상품 입/출고일
    AMOUNT NUMBER, -- 입/출고 개수
    STATUS VARCHAR2(10), -- 상품 상태(입고/출고)
    CHECK(STATUS IN ('입고', '출고')),
    FOREIGN KEY(PCODE) REFERENCES PRODUCT
);

CREATE SEQUENCE SEQ_PCODE; --> 상품코드 중복 안되게 새로운 번호 발생
CREATE SEQUENCE SEQ_DCODE; --> 상세코드 중복 안되게 새로운 번호 발생

INSERT INTO PRODUCT
VALUES(SEQ_PCODE.NEXTVAL, '갤럭스노트10', '삼송', 1000000, DEFAULT);

INSERT INTO PRODUCT
VALUES(SEQ_PCODE.NEXTVAL, '아이뽀X', '사과', 1200000, DEFAULT);

INSERT INTO PRODUCT
VALUES(SEQ_PCODE.NEXTVAL, '대륙폰', '샤우미', 600000, DEFAULT);

SELECT * FROM PRODUCT;
SELECT * FROM PRO_DETAIL;

-- PRO_DETAIL 테이블에 데이터 삽입(INSERT) 시
-- STATUS 컬럼 값에 다른 PRODUCT 테이블 STOCK 컬럼 값 변경 트리거 생성
CREATE OR REPLACE TRIGGER TRG_02
AFTER INSERT ON PRO_DETAIL
FOR EACH ROW -- 변화가 있는 행에 한하여
BEGIN
    -- 상품이 입고된 경우
    IF :NEW.STATUS = '입고' --> NEW.STATUS : SQL 반영 후 STATUS 컬럼의 값
    THEN
        UPDATE PRODUCT
        SET STOCK = STOCK + :NEW.AMOUNT
        WHERE PCODE = :NEW.PCODE; --> PRODUCT 테이블에서 상품코드가 같은 상품의 재고량 증가
    END IF;
    
    -- 상품이 출고된 경우
    IF :NEW.STATUS = '출고'
    THEN
        UPDATE PRODUCT
        SET STOCK = STOCK - :NEW.AMOUNT
        WHERE PCODE = :NEW.PCODE;
    END IF;
END;
/

-- PCODE가 1인 상품 5개 입고
INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 1, SYSDATE, 5, '입고');

SELECT * FROM PRO_DETAIL;
SELECT * FROM PRODUCT;

INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 2, SYSDATE, 10, '입고');
INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 3, SYSDATE, 20, '입고');


INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 2, SYSDATE, 5, '출고');
INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 3, SYSDATE, 10, '출고');

-- 