-- ������(SEQUENCE)
-- �ڵ� ��ȣ �߻��� ������ �ϴ� ��ü
-- ���������� ���� ���� �ڵ����� ��������
--> UNIQUE�� ���� �÷��� �Է��� �� ����. �Ϲ������� PRIMARY KEY ���� �����ϱ� ���� ���.
-- ���̺�� ���������� ����ǰ� �����ǹǷ� �ϳ��� �������� ���� ���̺��� ��� ����

---------------------------------------------------------------------------------
-- 1. SEQUENCE ����

-- [ǥ����]
/*
    CREATE SQUENCE �������̸�
    [START WITH ����] -- ó�� �߻���ų ���۰� ����, �����ϸ� �ڵ� 1�� �⺻
    [INCREMENT BY ����] -- ���� ���� ���� ����ġ, �����ϸ� �ڵ� 1�� �⺻
    [MAXVALUE ���� | NOMAXVALUE] -- �߻���ų �ִ밪 ����
    [MINVALUE ���� | NOMINVALUE] -- �߻���ų �ּҰ� ����
    [CYCLE | NOCYCLE] -- �� ��ȯ ���� ����
    [CACHE ����Ʈũ�� | NOCACHE] -- ĳ�� �޸� �⺻ ���� 20����Ʈ, �ּҰ��� 2����Ʈ
    --> �Ҵ� �� ũ�⸸ŭ �̸� ���� ������ ������ �����ص�
*/

CREATE SEQUENCE SEQ_EMPID
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;

-- ����ڰ� ������ ������ Ȯ���ϱ�
SELECT * FROM USER_SEQUENCES;

--------------------------------------------------------------------------------

-- 2. SEQUENCE ���
/*
    ��������.CURRVAL : ���� ������ �������� ��
    ��������.NEXTVAL : �������� ������Ŵ. ���� ������ ������ ����ġ��ŭ ������ ��.
    -> ��������.NEXTVAL = ��������.CURRVAL + INCREMENT BY�� ������ ��                   
*/

-- NEXTVAL�� �������� �ʰ� ��� ���� �� �������� CURRVAL ȣ�� ��
SELECT SEQ_EMPID.CURRVAL FROM DUAL; -- ���� �߻�!!!
-- ��������.CURRVAL�� ���������� ȣ�� �� ��������.NEXTVAL�� ���� �����Ͽ� �����ִ� �ӽð�

SELECT SEQ_EMPID.NEXTVAL FROM DUAL; -- 300
SELECT SEQ_EMPID.CURRVAL FROM DUAL; -- 300
SELECT SEQ_EMPID.NEXTVAL FROM DUAL; -- 305
SELECT SEQ_EMPID.CURRVAL FROM DUAL; -- 305

SELECT SEQ_EMPID.NEXTVAL FROM DUAL; -- 310
SELECT SEQ_EMPID.NEXTVAL FROM DUAL; -- ������ MAXVALUE���� �ʰ��Ͽ��� ������ ����

SELECT * FROM USER_SEQUENCES;
-- MAX_VALUE : 310, LAST_NUMBER : 315

SELECT SEQ_EMPID.CURRVAL FROM DUAL;
-- CURRVAL�� ���������� ȣ��� ������ NEXTVAL�� ���� �����ϰ� ���

/*
    CURRVAL / NEXTVAL ��� ���� ����
    
    1) ��� ����
    - ���������� �ƴ� SELECT��
    - INSERT���� SELECT��
    - INSERT���� VALUES��
    - UPDATE���� SET��
    
    2) ��� �Ұ�
    - VIEW�� SELECT��
    - DISTINCT Ű���尡 �ִ� SELECT��
    - GROUP BY, HAVING, ORDER BY���� SELECT��
    - SELECT, DELETE, UPDATE���� ��������
    - CREATE TABLE, ALTER TABLE ����� DEFAULT��

*/

CREATE SEQUENCE SEQ_EID
START WITH 300
INCREMENT BY 1
MAXVALUE 10000
NOCYCLE
NOCACHE;

COMMIT;

-- ��� ���� ����(INSERT���� VALUES��)
INSERT INTO EMPLOYEE
VALUES(SEQ_EID.NEXTVAL, '�迵��', '610410-2111111', 'young_123@kh.or.kr', '01012344444',
       'D1', 'J1', 'S1', 500000, 0.2, 200, SYSDATE, NULL, DEFAULT);

SELECT * FROM EMPLOYEE;

INSERT INTO EMPLOYEE
VALUES(SEQ_EID.NEXTVAL, '��ö��', '810410-1222222', 'young_123@kh.or.kr', '01012344444',
       'D1', 'J1', 'S1', 500000, 0.2, 200, SYSDATE, NULL, DEFAULT);

SELECT * FROM EMPLOYEE;     

-- ��� �Ұ� ����(CREATE TABLE, ALTER TABLE ����� DEFAULT ��)
CREATE TABLE TMP_EMPLOYEE(
    E_ID NUBMER DEFAULT SEQ_EID.CURRVAL,
    E_NAME VARCHAR2(30)
);

ROLLBACK;
------------------------------------------------------------------------------
-- 3. SEQUENCE ����
-- [ǥ����]
/*
    ALTER SEQUENCE �������̸�
    [INCREMENT BY ����]
    [MAXVALUE ���� | NOMAXVALUE]
    [MINVALUE ���� | NOMINVALUE]
    [CYCLE | NOCYCLE]
    [CACHE ����Ʈũ�� | NOCACHE];
*/
-- START WITH�� ���� �Ұ�
-- �缳�� �ʿ� �� ���� ������ DROP �� �����

ALTER SEQUENCE SEQ_EMPID
INCREMENT BY 10
MAXVALUE 400
NOCYCLE
NOCACHE;

-- ������ ���� Ȯ��
SELECT * FROM USER_SEQUENCES;

SELECT SEQ_EMPID.NEXTVAL FROM DUAL;
SELECT SEQ_EMPID.CURRVAL FROM DUAL;
-----------------------------------------------------------------------------
-- 4. SEQUENCE ����
DROP SEQUENCE SEQ_EMPID;

SELECT * FROM USER_SEQUENCES;