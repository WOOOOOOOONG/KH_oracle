/*
    < TRIGGER >
    ���̺��̳� �䰡 INSERT, UPDATE, DELETE ���� DML���� ���� ����� ���
    (���̺� �̺�Ʈ �߻� ��)
    �ڵ�����(����������) ����� ������ �����Ͽ� �����ϴ� ��ü
    ��, DML ������ ������ ���� �ڵ�ȭ�� ����
    
    1. Ʈ���� ����
    - �ڷ��� ���Ἲ ����
    - ����� �ڷ� �� ������ ������ ����ؼ� ���̺��� �������� ����
    - ������ �̺�Ʈ(DML)�� �߻��� ������ �ڵ����� ����Ǵ� PL/SQL ��
     --> �ڵ� ȣ��(ȣ�⹮ ���� �ʿ����)
     
     2. Ʈ���� ����
     - SQL���� ���� �ñ⿡ ���� �з�
       > BEFORE TRIGGER : SQL�� ���� �� Ʈ���� ����
       > AFTER TRIGGER : SQL�� ���� �� Ʈ���� ����
    
     - SQL���� ���� ������ �޴� �� ROW�� ���� �з�
       > ROW TRIGGER : SQL�� �� ROW�� ���� �ѹ��� ����
                       Ʈ���� ���� �� FOR EACH ROW �ɼ� �ۼ�
                       > : OLD : ���� �� ���� ��
                        (INSERT : �Է� �� �ڷ�, UPDATE : ���� �� �ڷ�, DELETE : ������ �ڷ�)
                       > : NEW : ���� �� ���� ��
                        (INSERT : �Է� �� �ڷ�, UPDATE : ���� �� �ڷ�)
       > STATEMENT TRIGGER : SQL���� ���� �ѹ��� ����(DEFAULT TRIGGER)
       
       3. Ʈ���� ���� ���
       [ǥ����]
       CREATE [OR REPLACE] TRIGGER Ʈ���Ÿ�
       BEFORE | AFTER
       INSERT | UPDATE | DELETE
       ON ���̺��
       [FOR EACH ROW] -- ROW TRIGGER �ɼ�
       [WHEN ����]
       DECLARE
            �����
       BEGIN
            �����
       [EXCEPTION]
       END;
       /
*/

-- EMPLOYEE ���̺� ���ο� ���� INSERT �� �� �ڵ����� �޽��� ����ϴ� Ʈ���� ����
CREATE OR REPLACE TRIGGER TRG_01
AFTER INSERT
ON EMPLOYEE
BEGIN 
    DBMS_OUTPUT.PUT_LINE('���Ի���� �Ի��߽��ϴ�.');
END;
/

INSERT INTO EMPLOYEE
VALUES(905, '�漺��', '670512-1151432', 'gil_sj@kh.or.kr', '01035464444', 
        'D5', 'J3', 'S5', 3000000, 0.1, 200, SYSDATE, NULL, DEFAULT);

ROLLBACK;

-- ��ǰ �԰� ��� ���� ����

-- ��ǰ ���� ���̺�
CREATE TABLE PRODUCT(
    PCODE NUMBER PRIMARY KEY, -- ��ǰ �ڵ�
    PNAME VARCHAR2(30), -- ��ǰ��
    BRAND VARCHAR2(30), -- �귣���
    PRICE NUMBER, -- ����
    STOCK NUMBER DEFAULT 0 -- ���
);

-- ��ǰ ����� �� �̷� ���̺�
CREATE TABLE PRO_DETAIL(
    DCODE NUMBER PRIMARY KEY, -- �� �ڵ�
    PCODE NUMBER, -- ��ǰ �ڵ�(�ܷ�Ű)
    PDATE DATE, -- ��ǰ ��/�����
    AMOUNT NUMBER, -- ��/��� ����
    STATUS VARCHAR2(10), -- ��ǰ ����(�԰�/���)
    CHECK(STATUS IN ('�԰�', '���')),
    FOREIGN KEY(PCODE) REFERENCES PRODUCT
);

CREATE SEQUENCE SEQ_PCODE; --> ��ǰ�ڵ� �ߺ� �ȵǰ� ���ο� ��ȣ �߻�
CREATE SEQUENCE SEQ_DCODE; --> ���ڵ� �ߺ� �ȵǰ� ���ο� ��ȣ �߻�

INSERT INTO PRODUCT
VALUES(SEQ_PCODE.NEXTVAL, '��������Ʈ10', '���', 1000000, DEFAULT);

INSERT INTO PRODUCT
VALUES(SEQ_PCODE.NEXTVAL, '���̻�X', '���', 1200000, DEFAULT);

INSERT INTO PRODUCT
VALUES(SEQ_PCODE.NEXTVAL, '�����', '�����', 600000, DEFAULT);

SELECT * FROM PRODUCT;
SELECT * FROM PRO_DETAIL;

-- PRO_DETAIL ���̺� ������ ����(INSERT) ��
-- STATUS �÷� ���� �ٸ� PRODUCT ���̺� STOCK �÷� �� ���� Ʈ���� ����
CREATE OR REPLACE TRIGGER TRG_02
AFTER INSERT ON PRO_DETAIL
FOR EACH ROW -- ��ȭ�� �ִ� �࿡ ���Ͽ�
BEGIN
    -- ��ǰ�� �԰�� ���
    IF :NEW.STATUS = '�԰�' --> NEW.STATUS : SQL �ݿ� �� STATUS �÷��� ��
    THEN
        UPDATE PRODUCT
        SET STOCK = STOCK + :NEW.AMOUNT
        WHERE PCODE = :NEW.PCODE; --> PRODUCT ���̺��� ��ǰ�ڵ尡 ���� ��ǰ�� ��� ����
    END IF;
    
    -- ��ǰ�� ���� ���
    IF :NEW.STATUS = '���'
    THEN
        UPDATE PRODUCT
        SET STOCK = STOCK - :NEW.AMOUNT
        WHERE PCODE = :NEW.PCODE;
    END IF;
END;
/

-- PCODE�� 1�� ��ǰ 5�� �԰�
INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 1, SYSDATE, 5, '�԰�');

SELECT * FROM PRO_DETAIL;
SELECT * FROM PRODUCT;

INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 2, SYSDATE, 10, '�԰�');
INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 3, SYSDATE, 20, '�԰�');


INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 2, SYSDATE, 5, '���');
INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 3, SYSDATE, 10, '���');

-- 