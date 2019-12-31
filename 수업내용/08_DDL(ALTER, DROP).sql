-- DDL(ALTER, DROP)

-- [����]
-- ������ ��ųʸ�
-- USER_CONSTRAINTS : ���� ���� �����ϴ� ������ ��ųʸ�
SELECT * FROM USER_CONSTRAINTS;

-- UESR_CONS_COLUMNS : ���� ������ �÷����� �����ϴ� ������ ��ųʸ�
SELECT * FROM USER_CONS_COLUMNS;

-- USER_TABLES : ���̺��� �����ϴ� ������ ��ųʸ�
SELECT * FROM USER_TABLES;

-- USER_TAB_COLS : ���̺��� �÷��� �����ϴ� ������ ��ųʸ�
SELECT * FROM USER_TAB_COLS;

-- ���� KH ������ �ִ� ���̺� �÷� �� ��ȸ
SELECT TABLE_NAME, COUNT(*)
FROM USER_TAB_COLS
GROUP BY TABLE_NAME;

----------------------------------------------------------------------------------
-- ALTER
-- ��ü�� �����ϴ� ����

-- [ǥ����]
-- ALTER TABLE[��ü] ���̺�� ��������;

-- ������ ����
-- �÷� �߰�/����, �������� �߰�/����
-- �÷� �ڷ��� ����, DEFAULT�� ����
-- ���̺�� ����, �÷���, �������� �̸� ����

-- 1. �÷� �߰�, ���� ,����
SELECT * FROM DEPT_COPY;

-- �÷� �߰�(ADD)
ALTER TABLE DEPT_COPY
ADD CNAME VARCHAR2(20);

SELECT * FROM DEPT_COPY;

-- �÷� �߰� �� DEFAULT�� ����
ALTER TABLE DEPT_COPY
ADD LNAME VARCHAR2(40) DEFAULT '�ѱ�';

-- �÷� ����(MODIFY)

-- �÷� ���� ��
SELECT COLUMN_NAME, DATA_TYPE, NULLABLE, DATA_DEFAULT, COLUMN_ID, COMMENTS
FROM USER_TAB_COLUMNS
JOIN USER_COL_COMMENTS USING(TABLE_NAME, COLUMN_NAME)
WHERE TABLE_NAME = 'DEPT_COPY';

ALTER TABLE DEPT_COPY
MODIFY DEPT_ID CHAR(3)
MODIFY DEPT_TITLE VARCHAR(30)
MODIFY LOCATION_ID VARCHAR2(2)
MODIFY CNAME CHAR(20)
MODIFY LNAME DEFAULT '�̱�';

-- �÷��� ũ�⸦ ���� ��쿡�� ��ϵ� ���� �����Ϸ��� ũ�⸦ �ʰ��ϴ� ���� ���� ���� ���� ����
SELECT * FROM DEPT_COPY;

ALTER TABLE DEPT_COPY
MODIFY DEPT_TITLE VARCHAR2(10);

-- DEFAULT�� ����
ALTER TABLE DEPT_COPY
MODIFY DEPT_TITLE DEFAULT '�ѱ�';

INSERT INTO DEPT_COPY
VALUES('D11', '�����', 'L2', NULL, DEFAULT);

SELECT * FROM DEPT_COPY;

-- �÷� ����(DROP COLUMN || DROP (������ �÷���))
-- �����Ͱ� ��ϵǾ� �־ ������
-- ������ �÷��� ���� �ȵ�
-- ���̺��� �ּ� �� ���� �÷��� �����ؾ� �Ѵ� : ��� �÷� ���� �Ұ�
CREATE TABLE DEPT_COPY2
AS SELECT * FROM DEPT_COPY;

SELECT COLUMN_NAME, DATA_TYPE, NULLABLE, DATA_DEFAULT, COLUMN_ID, COMMENTS
FROM USER_TAB_COLUMNS
NATURAL JOIN USER_COL_COMMENTS
WHERE TABLE_NAME = 'DEPT_COPY2';

ALTER TABLE DEPT_COPY2
DROP COLUMN DEPT_ID;

ALTER TABLE DEPT_COPY2
DROP COLUMN DEPT_TITLE;

ALTER TABLE DEPT_COPY2
DROP COLUMN LOCATION_ID;

ALTER TABLE DEPT_COPY2
DROP COLUMN CNAME;

ALTER TABLE DEPT_COPY2
DROP COLUMN LNAME;
-- ���̺� �����ִ� �÷��� �ϳ����̹Ƿ� �� �̻� ���� �Ұ�. 

SELECT * FROM DEPT_COPY2;

ROLLBACK;  -- �ѹ��� �ƹ��� ���ĵ� �������� �ʴ´�.

-- ���������� �����Ǿ� �ִ� �÷� ����
CREATE TABLE TB1(
    PK NUMBER PRIMARY KEY,
    FK NUMBER REFERENCES TB1,
    COL1 NUMBER,
    CHECK (PK > 0 AND COL1 > 0)
);

-- ���̺� �������� Ȯ��
SELECT *
FROM USER_CONSTRAINTS C1
JOIN USER_CONS_COLUMNS C2 USING(CONSTRAINT_NAME)
WHERE C1.TABLE_NAME = 'TB1';

-- �÷� ���� �� �����ϰ� �ִ� �÷��� �ִٸ� ���� �Ұ���
ALTER TABLE TB1
DROP COLUMN PK;

-- �������ǰ� �Բ� ����(CASCADE CONSTRAINTS)
ALTER TABLE TB1
DROP COLUMN PK CASCADE CONSTRAINTS;

SELECT * FROM TB1;

SELECT * FROM USER_CONSTRAINTS C1
JOIN USER_CONS_COLUMNS C2 USING(CONSTRAINT_NAME)
WHERE C1.TABLE_NAME = 'TB1';

-------------------------------------�ѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤѤ�
-- 2. �������� �߰�, ����
-- �������� �߰�(ADD CONSTRAINT �������Ǹ� ��������(�÷���))
-- ��, NOT NULL �������� �߰��� ADD�� �ƴ� MODIFY�� �߰�
-- MODIFY �÷��� CONSTRAINT �������Ǹ� NOT NULL

SELECT *
FROM USER_CONSTRAINTS C1
JOIN USER_CONS_COLUMNS C2 USING(CONSTRAINT_NAME)
WHERE C1.TABLE_NAME = 'DEPT_COPY';
--> DEPARTMENT�� NOT NULL ���Ǹ� ����Ǿ� ����

-- PRIMARY KEY �߰�
ALTER TABLE DEPT_COPY
ADD CONSTRAINT DCOPY_DID_PH PRIMARY KEY(DEPT_ID);

-- UNIQUE �߰�
ALTER TABLE DEPT_COPY
ADD CONSTRAINT DCOPY_DTITLE_UNQ UNIQUE(DEPT_TITLE);

-- NOT NULL
ALTER TABLE DEPT_COPY
MODIFY LNAME CONSTRAINT DCOPY_LNAME_NN NOT NULL;

-- �߰��� ���� ���� Ȯ��
SELECT *
FROM USER_CONSTRAINTS C1
JOIN USER_CONS_COLUMNS C2 USING(CONSTRAINT_NAME)
WHERE C1.TABLE_NAME  = 'DEPT_COPY';

-- �������� ����(DROP CONSTRAINT �������Ǹ�)
ALTER TABLE DEPT_COPY
DROP CONSTRAINT DCOPY_DID_PH;

-- �������� ������ ����
ALTER TABLE DEPT_COPY
DROP CONSTRAINT DCOPY_DTITLE_UNQ
DROP CONSTRAINT SYS_C007145;

-- NOT NULL ���������� �߰��� ���� MODIFY�� ���� ����
ALTER TABLE DEPT_COPY
MODIFY LOCATION_ID NULL;

-- �������� ���� Ȯ��
SELECT *
FROM USER_CONSTRAINTS C1
JOIN USER_CONS_COLUMNS C2 USING(CONSTRAINT_NAME)
WHERE C1.TABLE_NAME  = 'DEPT_COPY';

--------------------------------------------------------------------------------------------------------------------
-- 3. �÷�, ��������, ���̺� �̸� ����
-- �÷��̸� ����(RENAME COLUMN �÷��� TO �����)
ALTER TABLE DEPT_COPY
RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

SELECT * FROM DEPT_COPY;

-- �������� �̸� ����(RENAME CONSTRAINT �������Ǹ� TO �����)

-- ���� �� USER_ForeignKEY ���̺� ���� ����
SELECT UC.CONSTRAINT_NAME �̸�, UC.CONSTRAINT_TYPE ����, UCC.COLUMN_NAME �÷���,
       UC.R_CONSTRAINT_NAME ����, UC.DELETE_RULE ������Ģ
FROM USER_CONSTRAINTS UC
JOIN USER_CONS_COLUMNS UCC ON(UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME)
WHERE UC.TABLE_NAME = 'USER_FOREIGNKEY';

-- �������Ǹ��� ���� NOT NULL ���� ���Ǹ� ����
ALTER TABLE USER_FOREIGNKEY
RENAME CONSTRAINT SYS_C007087 TO UF_USERPWD_NN;

-- ���� FOREIGN KE �������Ǹ� ����
ALTER TABLE USER_FOREIGNKEY
RENAME CONSTRAINT FK_GRADE_CODE TO UF_GRADECODE_FK;

-- ���̺�� ����(RNAME [���̺��] TO �����)
ALTER TABLE DEPT_COPY
RENAME TO DEPT_TEST;

SELECT * FROM DEPT_COPY;
-- ���̺���� ����Ǿ� ��ȸ �Ұ���

SELECT * FROM DEPT_TEST;
----------------------------------------------------------------------------------------------------------------
-- 4. ���̺� ����
DROP TABLE DEPT_TEST
CASCADE CONSTRAINTS; -- ���� ���ǵ� �Բ� ����
-- ALTER ~ DROP, DROP~ �� ��

-- DELETE : DML, ROLLBACK ����
-- TRUNCATE : DDL, ROLLBACK �Ұ���
-- DROP TABLE : DDL, ROLLBACK �Ұ���