-- DDL(CREATE)

-- DDL(DATA DEFINITION LANGUAGE) : ������ ���� ���
-- �����ͺ��̽� ��Ű�� ��ü�� �����ϰų� �����ϴ� ��ɾ�� �����ͺ��̽� ��ü���� ����, ����, ����
-- CREATE, ALTER, DROP, TRUNCATE��
-- ** ��Ű�� : DB�� ������ ���� ���ǿ� ���� �������� ���� ����� �� **

-- ��ü�� �����(CREATE), �����ϰ�(ALTER), ����(DROP)�ϴ� �� �������� ��ü ������ �����ϴ� ����, �ַ� DB������, �����ڰ� �����

-- ����Ŭ������ ��ü : ���̺�(TABLE), ��(VIEW), ������(SEQUENCE), �ε���(INDEX), ��Ű��(PACKAGE), Ʈ����(TRIGGER), ���ν���(PROCEDURE),
--                    �Լ�(FUNCTION), ���Ǿ�(SYNONYM), �����(USER)
----------------------------------------------------------------------------------------------------------------------------
/*
    <������ ��ųʸ�>
    - �����ͺ��̽��� �������� ������ ����
    - �����ͺ��̽��� ������ �������� Ȯ�� ����
    - DDL ����� ����� ������ ������ ������ �����Ͽ� ������ �ݿ���
    - �б� ���� VIEW�� �����Ǿ� ����
*/

-----------------------------------------------------------------------------------------------------------------------------
-- CREATE
-- ���̺��̳� �ε���, �� �� �پ��� �����ͺ��̽� ��ü�� �����ϴ� ����
-- ���̺�� ������ ��ü�� DROP������ ���� ������ �� ����.

-- 1. ���̺� �����
-- ���̺��̶� ?
-- ��� ���� �����Ǵ� ���� �⺻���� DB ��ü
-- �����ͺ��̽� ������ ��� �����ʹ� ���̺� ���� ����ȴ�.

-- [ǥ����]
-- CREATE TABLE ���̺�� (�÷��� �ڷ���(ũ��), �÷��� �ڷ���(ũ��), ...);
CREATE TABLE MEMBER(
    MEMBER_ID VARCHAR2(20),
    MEMBER_PWD VARCHAR2(20),
    MEMBER_NAME VARCHAR2(20),
    MEMBER_DATE DATE DEFAULT SYSDATE -- �ԷµǴ� ���� ���ų�, DEFAULT�� ��쿡 Ŀ���� ����
);
-- ���� ���̺� Ȯ��
SELECT * FROM MEMBER;

-- �÷��� �ּ� �ޱ�
-- [ǥ����]
-- COMMENT ON COLUMN ���̺��.�÷��� IS '�ּ�����';
COMMENT ON COLUMN MEMBER.MEMBER_ID IS 'ȸ�����̵�';
COMMENT ON COLUMN MEMBER.MEMBER_PWD IS '��й�ȣ';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS  'ȸ���̸�';
COMMENT ON COLUMN MEMBER.MEMBER_DATE IS 'ȸ��������';

-- ���̺� �ּ� Ȯ��
SELECT * FROM USER_COL_COMMENTS
WHERE TABLE_NAME = 'MEMBER';

SELECT * FROM USER_TABLES;
-- USER_TABLES = ����ڰ� �ۼ��� ���̺��� Ȯ���ϴ� ��
-- ������ ��ųʸ��� ���ǵǾ� ����.

 SELECT * FROM USER_TAB_COLUMNS
 WHERE TABLE_NAME = 'MEMBER';
 -- UYSER_TAB_COLUMNS : ���̺�, ��, Ŭ������ �÷��� ���õ� ���� ��ȸ
 -- ������ ��ųʸ��� ���ǵǾ� ����
 
  INSERT INTO MEMBER VALUES('MEM1', '123ABC', '�캰��', '2019-09-20');
  SELECT * FROM MEMBER;
  
  INSERT INTO MEMBER VALUES('MEM2', 'QWER1234', '�迵��', SYSDATE);
  INSERT INTO MEMBER VALUES('MEM3', 'ZZ9786', '�ڿ���', DEFAULT);
  INSERT INTO MEMBER(MEMBER_ID, MEMBER_PWD, MEMBER_NAME)
  VALUES ('MEM', 'ASDQWE', '�ѿ���');
  
  SELECT * FROM MEMBER;
  
-----------------------------------------------------------------------------------------------------------
-- ���� ����(CONSTRAINTS)
-- ����ڰ� ���ϴ� ������ �����͸� �����ϱ� ���ؼ� Ư�� �÷��� �����ϴ� ����
-- ���̺� �ۼ� �� �� Į���� ���� �� ��Ͽ� ���� ���� ���� ���� ����
-- ���̺� ���Ἲ ������ ����
-- �Է� �����Ϳ� ������ ������ �ڵ����� �˻��ϴ� ����
-- �������� ����/����/���� ���� �˻� ���� �������� ��
-- PRIMARY KEY, NOT NULL, UNIQUE, CHECK, FOREIGN KEY

-- ���� ���� Ȯ��
DESC USER_CONSTRAINTS;

SELECT * FROM USER_CONSTRAINTS;
-- USER_CONSTRAINTS : ����ڰ� �ۼ��� ���������� Ȯ���ϴ� ��

DESC USER_CONS_COLUMNS;
SELECT * FROM USER_CONS_COLUMNS;
-- USER_CONS_COLUMNS : ���������� �ɷ� �ִ� �÷��� Ȯ���ϴ� ��

-- 3. NOT NULL 
-- �ش� �÷��� �ݵ�� ���� ��ϵǾ�� �ϴ� ��� ���
-- ����/���� �� NULL���� ������� �ʵ��� �÷� �������� ����

-- NOT NULL �������� ������ ���� ���� ���
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
VALUES (1, 'user01', 'pass01', 'ȫ�浿', '��', '010-1234-5678', 'hong123@kh.or.kr');



INSERT INTO USER_NOCONS
VALUES (2, null, null, null, null, '010-1234-5678', 'hong123@kh.or.kr');
-- �÷��� NULL���� �־ ���� ����
SELECT * FROM USER_NOCONS;

-- NOT NULL ���� ���� ���� O�� ���
CREATE TABLE USER_NOTNULL(
    USER_NO NUMBER NOT NULL, -- �÷� ���� �������� ����
    USER_ID VARCHAR2(20) NOT NULL,
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30) NOT NULL,
    GENDER VARCHAR2(10),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50)
);

INSERT INTO USER_NOTNULL
VALUES (1, 'user01', 'pass01', 'ȫ�浿', '��', '010-1234-5678', 'hong123@kh.or.kr');



INSERT INTO USER_NOTNULL
VALUES (2, 'user02', 'pass01', null, null, '010-1234-5678', 'hong123@kh.or.kr');
-- NOT NULL �������ǿ� ����Ǿ� ���� �߻�

SELECT * FROM USER_NOTNULL;

-- �ۼ��� ���� ���� Ȯ��
SELECT *
FROM USER_CONSTRAINTS C1
JOIN USER_CONS_COLUMNS C2 USING(CONSTRAINT_NAME)
WHERE C1.TABLE_NAME = 'USER_NOTNULL';

-----------------------------------------------------------------------------------------------------------
-- 4. UNIQUE ��������
-- �÷��� �Է� ���� ���ؼ� �ߺ��� �����Ѵٴ� ����
-- �÷� ������ ���̺� �������� ���� ����

SELECT * FROM USER_NOCONS;

-- �ߺ� ������ ����
INSERT INTO USER_NOCONS
VALUES (1, 'user01', 'pass01', 'ȫ�浿', '��', '010-1234-5678', 'hong123@kh.or.kr');

SELECT * FROM USER_NOCONS;

-- UNIQUE ���� ���� ���̺� ����
CREATE TABLE USER_UNIQUE(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20) UNIQUE, -- �÷� �������� ��������
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30),
    GENDER VARCHAR2(10),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50)
);

-- �ߺ� ������ ����
INSERT INTO USER_UNIQUE
VALUES (1, 'user01', 'pass01', 'ȫ�浿', '��', '010-1234-5678', 'hong123@kh.or.kr');

INSERT INTO USER_UNIQUE
VALUES (1, 'user01', 'pass01', 'ȫ�浿', '��', '010-1234-5678', 'hong123@kh.or.kr');
--> ���� ���̵��� �����Ͱ� �̹� ���̺� �����Ƿ� UNIQUE ���� ���ǿ� ����Ǿ� ���� �߻�

-- ���� ���� ��Ÿ���� SYS_C007050 ���� ���� ���Ǹ�����
-- �ش� ���� ������ ������ ���̺��, �÷�, ���� ���� Ÿ�� ��ȸ
SELECT UCC.TABLE_NAME, UCC.COLUMN_NAME, UC.CONSTRAINT_TYPE
FROM USER_CONSTRAINTS UC, USER_CONS_COLUMNS UCC
WHERE UCC.CONSTRAINT_NAME = UC.CONSTRAINT_NAME
AND UCC.CONSTRAINT_NAME = 'SYS_C007050';

-- ���̺� �������� �������� ����
/*
    CREATE TABLE ���̺��(
        �÷��� �ڷ���,
        ...
        [CONSTRAINT �������Ǹ�] ��������Ÿ�� (�÷���)
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
    UNIQUE(USER_ID) -- ���̺� �������� �������� ����
);

INSERT INTO USER_UNIQUE2
VALUES (1, 'user01', 'pass01', 'ȫ�浿', '��', '010-1234-5678', 'hong123@kh.or.kr');

INSERT INTO USER_UNIQUE2
VALUES (1, 'user01', 'pass01', 'ȫ�浿', '��', '010-1234-5678', 'hong123@kh.or.kr');
--> ���� ���̵��� �����Ͱ� �̹� ���̺� �����Ƿ� UNIQUE ���� ���ǿ� ����Ǿ� ���� �߻�

-- �� ���� �÷��� ��� �ϳ��� UNIQUE ���� ������ ������
CREATE TABLE USER_UNIQUE3(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20),
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30),
    GENDER VARCHAR2(10),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50),
    UNIQUE(USER_NO, USER_ID) -- ���̺� �������� �������� ���� (NOT NULL�� �ȵ�)
);

INSERT INTO USER_UNIQUE3
VALUES (1, 'user01', 'pass01', 'ȫ�浿', '��', '010-1234-5678', 'hong123@kh.or.kh');

INSERT INTO USER_UNIQUE3
VALUES (2, 'user01', 'pass01', 'ȫ�浿', '��', '010-1234-5678', 'hong123@kh.or.kh');

INSERT INTO USER_UNIQUE3
VALUES (2, 'user02', 'pass01', 'ȫ�浿', '��', '010-1234-5678', 'hong123@kh.or.kh');
-- > ���� Į���� ���� UNIQUE ���� ������ �����Ǿ� ������ <�� �÷� ��� �ߺ�>�Ǵ� ���� ��쿡�� ������ �߻��ϰ� �ȴ�.

SELECT UC.TABLE_NAME, UCC.COLUMN_NAME, UCC.CONSTRAINT_NAME, UC.CONSTRAINT_TYPE
FROM USER_CONSTRAINTS UC
JOIN USER_CONS_COLUMNS UCC ON(UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME)
WHERE UCC.CONSTRAINT_NAME = 'SYS_007054';
--> �ΰ��� UNIQUE ���� ������ �ϳ��� ���� ���Ǹ����� �Ǿ��ִ� �� Ȯ��(�� �ȳ�����)

-- ���� ���ǿ� �̸� ����
-- ���� ���� �̸� ������ ���� : ������ �Ͼ �����͸� ã�� ���ϴ�
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
-- 5. PRIMARY KEY(�⺻Ű) ��������

-- ���̺��� �� ���� ������ ã�� ���� ����� Į���� �ǹ���
-- ���̺� ���� �ĺ���(IDENTIFIER) ������ ��
-- NOT NULL + UNIQUE ���� ������ �ǹ�
-- �� ���̺� �� �� ���� ������ �� �� ����
-- �÷� ����, ���̺� ���� �� �� ���� ����
-- �� �� �÷��� ������ ���� �ְ�, ���� ���� �÷��� ���� ������ ���� ����

/*                      <�⺻Ű�� ����>
    1. ���ϼ� : �ֽĺ��ڿ� ���� ��ƼƼ �� ��� �ν��Ͻ����� �����ϰ� ������ (UNIQUE)
    2. ���缺 : �ֽĺ��ڰ� �����Ǹ� �ݵ�� ������ ���� �����ؾ� �� (NOT NULL)
    3. �ּҼ� : �ּ����� �Ӽ����� �ĺ��� ����
    4. �Һ��� : �ĺ��ڰ� �� �� Ư�� ��ƼƼ���� �����Ǹ� �� �ĺ��ڴ� ������ �ʾƾ� ��
*/

CREATE TABLE USER_PRIMARYKEY(
    USER_NO NUMBER CONSTRAINT PK_USER_NO PRIMARY KEY, -- �÷� ���� ����
    USER_ID VARCHAR2(20) UNIQUE,
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30),
    GENDER VARCHAR2(10),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50)
    -- CONSTRAINT PK_USER_NO PRIMARY KEY(USER_NO) -- ���̺� ���� ����
);

INSERT INTO USER_PRIMARYKEY
VALUES (1, 'user01', 'pass01', 'ȫ�浿', '��', '010-1234-5678', 'hong123@kh.or.kr');

INSERT INTO USER_PRIMARYKEY
VALUES (1, 'user01', 'pass01', 'ȫ�浿', '��', '010-1234-5678', 'hong123@kh.or.kr');
--> �⺻Ű �ߺ� ����

INSERT INTO USER_PRIMARYKEY
VALUES (NULL, 'user01', 'pass01', 'ȫ�浿', '��', '010-1234-5678', 'hong123@kh.or.kr');
--> �⺻Ű null�̹Ƿ�  ����

-- �⺻Ű�� ����Ű�� �����ϱ� (���̺� ���������� ���� ����)
CREATE TABLE USER_PRIMARYKEY2(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20) UNIQUE,
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30),
    GENDER VARCHAR2(10),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50),
    CONSTRAINT PK_USERNO_USERID PRIMARY KEY(USER_NO, USER_ID) -- ����Ű
);

INSERT INTO USER_PRIMARYKEY2
VALUES (1, 'user01', 'pass01', 'ȫ�浿', '��', '010-1234-5678', 'hong123@kh.or.kr');

INSERT INTO USER_PRIMARYKEY2
VALUES (1, 'user02', 'pass02', '�̼���', '��', '010-1234-5679', 'LEE123@kh.or.kr');

INSERT INTO USER_PRIMARYKEY2
VALUES (2, 'user01', 'pass01', '������', '��', '010-1234-5670', 'YOO123@kh.or.kr');
-- USER_ID �Ӽ��� ����ũ�� ���� �ɷ��־ �ȵ�

-- ����Ű�� �� �� �ϳ��� �ٲ�� �� ��.

-- 6. FOREIGN KEY(�ܺ�Ű / �ܷ�Ű) ���� ����

-- ������ �ٸ� ���̺��� �����ϴ� ���� ����� �� �ִ�
-- FOREIGN KEY �������ǿ� ���ؼ� ���̺��� ���谡 ������
-- �����ϴ� �� �ܿ��� NULL�� ����� �� ����

-- �÷� ������ ���
-- �÷��� �ڷ���(ũ��) [CONSTRAINT �̸�] PREFERENCES ���������̺�� [(�������÷�)] [������]

-- ���̺� ������ ���
-- [CONSTRAINT �̸�] FOREIGN KEY (������ �÷���) PREFERENCES ���������̺�� [(�������÷�)] [������]

-- *������ �� �ִ� �÷��� RPIMARY KEY �÷��� UNIQUE�� ������ �÷��� �ܷ�Ű�� ����� �� ����*
-- *������ ���̺��� ������ �÷����� ������ �Ǹ�, PRIMARY KEY�� ������ �÷��� �ڵ����� ������ �÷��� ��*
CREATE TABLE USER_GRADE(
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30) NOT NULL
);

INSERT INTO USER_GRADE VALUES (10, '�Ϲ�ȸ��');
INSERT INTO USER_GRADE VALUES (20, '���ȸ��');
INSERT INTO USER_GRADE VALUES (30, 'Ư��ȸ��');

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
VALUES (1, 'user01', 'pass01', 'ȫ�浿', '��', '010-1234-5678', 'hong123@kh.or.kr', 10);

INSERT INTO USER_FOREIGNKEY
VALUES (2, 'user02', 'pass02', '�̼���', '��', '010-5678-9012', 'lee123@kh.or.kr', 10);

INSERT INTO USER_FOREIGNKEY
VALUES (3, 'user03', 'pass03', '������', '��', '010-4412-5915', 'YOO123@kh.or.kr', 30);

INSERT INTO USER_FOREIGNKEY
VALUES (4, 'user04', 'pass04', '���߱�', '��', '010-5555-5555', 'ahn123@kh.or.kr', null);
--> ������ �����ϴ� �� + null�� �־ �����ϴ�

SELECT * FROM USER_FOREIGNKEY;

INSERT INTO USER_FOREIGNKEY

VALUES (5, 'user05', 'pass05', '������', '��', '010-6666-1234', 'yoon123@kh.or.kr', 50);
--> 50�̶�� ���� USER_GRADE ���̺� GRADE_CODE �÷����� �����ϴ� ���� �ƴϾ �ܷ�Ű ���� ���ǿ� ����Ǿ� ���� �߻�

-- [����] �ڿ� ����
-- USER_FOREIGNKEY ���̺���
-- ȸ�� ���̵�, �̸�, ����, ����ó, ȸ����޸� ��ȸ
SELECT USER_ID, USER_NAME, GENDER, PHONE, GRADE_NAME
FROM USER_FOREIGNKEY
--LEFT JOIN USER_GRADE USING(GRADE_CODE);
NATURAL LEFT JOIN USER_GRADE;
--> ������ Ÿ��, �̸��� ���� �÷��� �ִٸ� �ڵ����� �������ִ� ���

-- *FOREIGN KEY �����ɼ�
-- �θ� ���̺��� ������ ���� �� �ڽ� ���̺��� �����͸� ������� ó�������� ���� ������ ������ �� ����
SELECT * FROM USER_GRADE;

DELETE FROM USER_GRADE
WHERE GRADE_CODE = 10;
-- ON DELETE RESTRICTED(���� ����)�� �⺻ �����Ǿ� ����
-- FOREIGN KEY�� ������ �÷����� ���ǰ� �ִ� ���� ��� �����ϴ� �÷��� ���� �������� ����

COMMIT; 
DELETE FROM USER_GRADE
WHERE GRADE_CODE = 20;
-- GRADE_CODE �� 20�� �ܷ�Ű�� �����ǰ� ���� �ʾƼ� ���� ����

SELECT * FROM USER_GRADE;
ROLLBACK;
SELECT * FROM USER_GRADE;

-- ON DELETE SET NULL : �θ�Ű ������ �ڽ�Ű�� NULL�� �����ϴ� �ɼ�
CREATE TABLE USER_GRADE2(
    GRADE_CODE2 NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30) NOT NULL
);
INSERT INTO USER_GRADE2 VALUES (10, '�Ϲ�ȸ��');
INSERT INTO USER_GRADE2 VALUES (20, '���ȸ��');
INSERT INTO USER_GRADE2 VALUES (30, 'Ư��ȸ��');

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
VALUES (1, 'user01', 'pass01', 'ȫ�浿', '��', '010-1234-5678', 'hong123@kh.or.kr', 10);

INSERT INTO USER_FOREIGNKEY2
VALUES (2, 'user02', 'pass02', '�̼���', '��', '010-5678-9012', 'lee123@kh.or.kr', 10);

INSERT INTO USER_FOREIGNKEY2
VALUES (3, 'user03', 'pass03', '������', '��', '010-4412-5915', 'YOO123@kh.or.kr', 30);

INSERT INTO USER_FOREIGNKEY2
VALUES (4, 'user04', 'pass04', '���߱�', '��', '010-5555-5555', 'ahn123@kh.or.kr', null);

COMMIT;

SELECT * FROM USER_GRADE2;
SELECT * FROM USER_FOREIGNKEY2;

DELETE FROM USER_GRADE2
WHERE GRADE_CODE = 10;

SELECT * FROM USER_GRADE2;
SELECT * FROM USER_FOREIGNKEY2;

ROLLBACK;

-- ON DELETE CASCADE
-- �θ�Ű ������ ���� ����ϴ� �ڽ� ���̺��� �÷��� �ش��ϴ� ���� ������
CREATE TABLE USER_GRADE3(
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30) NOT NULL
);
INSERT INTO USER_GRADE3 VALUES (10, '�Ϲ�ȸ��');
INSERT INTO USER_GRADE3 VALUES (20, '���ȸ��');
INSERT INTO USER_GRADE3 VALUES (30, 'Ư��ȸ��');

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
VALUES (1, 'user01', 'pass01', 'ȫ�浿', '��', '010-1234-5678', 'hong123@kh.or.kr', 10);

INSERT INTO USER_FOREIGNKEY3
VALUES (2, 'user02', 'pass02', '�̼���', '��', '010-5678-9012', 'lee123@kh.or.kr', 10);

INSERT INTO USER_FOREIGNKEY3
VALUES (3, 'user03', 'pass03', '������', '��', '010-4412-5915', 'YOO123@kh.or.kr', 30);

INSERT INTO USER_FOREIGNKEY3
VALUES (4, 'user04', 'pass04', '���߱�', '��', '010-5555-5555', 'ahn123@kh.or.kr', null);

COMMIT;

SELECT * FROM USER_GRADE3;
SELECT * FROM USER_FOREIGNKEY3;

DELETE FROM USER_GRADE3
WHERE GRADE_CODE = 10;

ROLLBACK;

---------------------------------------------------------------------------------------------------------------------
-- 7. CHECK �������� : �÷��� ��ϵǴ� ���� ���� ������ �� �� ����
-- CHECK (�÷��� �񱳿����� �񱳰�)
-- ���� : �񱳰��� ���ͷ��� ����� �� ����, ���ϴ� ���̳� �Լ� ��� ����
CREATE TABLE USER_CHECK(
    USER_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(20) UNIQUE,
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30),
    GENDER VARCHAR2(10) CHECK (GENDER IN ('��', '��')),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50)
);

INSERT INTO USER_CHECK
VALUES (1, 'user01', 'pass01', 'ȫ�浿', '��', '010-1234-5678', 'hong123@kh.or.kr');

INSERT INTO USER_CHECK
VALUES (2, 'user02', 'pass02', 'ȫ�浿', '����', '010-1234-5678', 'hong123@kh.or.kr');
--> GENDER �÷����� CHECK ������������ ��, �� �� ��� ����
-- violate : �����ϴ�

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
VALUES ('ȫ�浿', 0, 'A', '2017/01/01');

-- TBCH_LEVEL
INSERT INTO TBLCHECK
VALUES ('ȫ�浿', 1, 'D', '2017/01/01');

-- TBCH_DATE
INSERT INTO TBLCHECK
VALUES ('ȫ�浿', 1, 'A', '2015/01/01');

-- [�ǽ� ����]
--ȸ�����Կ� ���̺� ����(USER_TEST)
--�÷��� : USER_NO(ȸ����ȣ) - �⺻Ű(PK_USER_NO2),
--        USER_ID(ȸ�����̵�) - �ߺ� ����(UK_USER_ID),
--        USER_PWD(ȸ����й�ȣ) - NULL�� ��� ����(NN_USER_PWD),
--        PNO(�ֹε�Ϲ�ȣ) - �ߺ�����(UK_PNO), NULL ��� ����(NN_PNO),
--        GENDER(����) - '��' Ȥ�� '��' �Է�(CK_GENDER),
--        PHONE(����ó),
--        ADDRESS(�ּ�),
--        STATUS(Ż�𿩺�) - NOT NULL(NN_STATUS), 'Y' Ȥ�� 'N'���� �Է�(CK_STATUS)
--        Ż�� ���δ� �Է� ���� ������ 'N' ���� �Է�
--�� �÷��� �������ǿ� �̸� �ο��� ��
--�� �÷��� �ڸ�Ʈ �߰��� ��
--5�� �̻� INSERT �� ��
--���̺� ��ü ��ȸ, �ڸ�Ʈ ��ȸ, �������� ��ȸ �� ��

CREATE TABLE USER_TEST(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20),
    USER_PWD VARCHAR2(30) CONSTRAINT NN_USER_PWD NOT NULL,
    PNO VARCHAR2(20),
    GENDER VARCHAR2(5) CONSTRAINT CK_GENDER CHECK (GENDER IN ('��', '��')), CONSTRAINT CK_STATUS CHECK (STATUS IN ('Y', 'N')),
    PHONE VARCHAR2(20),
    ADDRESS VARCHAR2(30),
    STATUS VARCHAR2(5) DEFAULT 'N' CONSTRAINT NN_STATUS NOT NULL, -- Ż�� ����
    CONSTRAINT PK_USER_NO2 PRIMARY KEY(USER_NO),
    CONSTRAINT UK_USER_ID UNIQUE(USER_ID),
    CONSTRAINT UK_PNO UNIQUE(USER_PWD)
);

COMMENT ON COLUMN USER_TEST.USER_NO IS 'ȸ����ȣ';
COMMENT ON COLUMN USER_TEST.USER_ID  IS 'ȸ�����̵�';
COMMENT ON COLUMN USER_TEST.USER_PWD IS 'ȸ����й�ȣ';
COMMENT ON COLUMN USER_TEST.PNO IS '�ֹε�Ϲ�ȣ';
COMMENT ON COLUMN USER_TEST.GENDER IS '����';
COMMENT ON COLUMN USER_TEST.PHONE IS '����ó';
COMMENT ON COLUMN USER_TEST.ADDRESS IS '�ּ�';
COMMENT ON COLUMN USER_TEST.STATUS IS 'Ż�𿩺�';

INSERT INTO USER_TEST
VALUES (1, 'user01', 'pass01', '590101-1075121', '��', '010-8123-2075', '���� ������ �Ż絿', 'N');

INSERT INTO USER_TEST
VALUES (2, 'user02', 'pass02', '770405-1022121', '��', '010-4763-5912', '���� ������ ������', 'N');

INSERT INTO USER_TEST
VALUES (3, 'user03', 'pass03', '881211-2052212', '��', '010-2020-1414', '���� ������ û�㵿', 'Y');

INSERT INTO USER_TEST
VALUES (4, 'user04', 'pass04', '950506-2525251', '��', '010-7741-2995', '��õ ���� ������', 'N');

INSERT INTO USER_TEST
VALUES (5, 'user05', 'pass05', '001231-3015521', '��', '010-4412-5585', '��õ ���� ���̷�', 'Y');

SELECT * FROM USER_TEST;

SELECT * FROM USER_COL_COMMENTS
WHERE TABLE_NAME = 'USER_TEST';

SELECT *
FROM USER_CONSTRAINTS C1
JOIN USER_CONS_COLUMNS C2 USING(CONSTRAINT_NAME)
WHERE C1.TABLE_NAME = 'USER_TEST';
SELECT * FROM USER_CONS_COLUMNS;

------------------------------------------------------------------------------------------------------------------------
-- 8. SUBQUERY�� �̿��� ���̺� ����
-- �÷���, ������ Ÿ��, ���� ����ǰ�, *���������� NOT NULL�� �����*
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
-- 9. �������� �߰�
-- ALTER TABLE ���̺�� ADD PRIMARY KEY(�÷���)
-- ALTER TABLE ���̺�� ADD FOREIGN KEY(�÷���) REFERENCES ���̺��
-- ALTER TABLE ���̺�� ADD UNIQUE(�÷���)
-- ALTER TABLE ���̺�� ADD CHECK(�÷��� �񱳿����� �񱳰�)
-- ALTER TABLE ���̺�� MODIFY �÷��� NOT NULL
SELECT *
FROM USER_CONSTRAINTS C1
JOIN USER_CONS_COLUMNS C2 USING(CONSTRAINT_NAME)
WHERE C1.TABLE_NAME = 'EMPLOYEE_COPY';

-- NOT NULL �������Ǹ� ����� EMPLOYEE_COPY ���̺� EMP_ID �÷��� PRIMARY KEY�� �ǵ��� ���������� �߰��Ѵ�
ALTER TABLE EMPLOYEE_COPY ADD PRIMARY KEY (EMP_ID);

--EMPLOYEE_COPY ���̺��� DEPT_CODE�� �ܷ�Ű �������� �߰�
-- ���� ���̺��� DEPARTMENT, ���� �÷��� DEPARTMENT�� �⺻Ű
ALTER TABLE EMPLOYEE_COPY ADD FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT; -- �÷� Ű ���� ���� ���ϸ� �˾Ƽ� �ű��� �⺻Ű�� ���� �ƴϸ� ���̺��(�÷�)

ALTER TABLE EMPLOYEE_COPY ADD UNIQUE(EMP_NO);

-- EMPLOYEE_COPY ���̺��� ENT_YN �÷��� 'Y' �Ǵ� 'N'�� �Է��� �� �ֵ��� �������� �߰�
ALTER TABLE EMPLOYEE_COPY ADD CHECK (ENT_YN IN ('Y', 'N'));

-- EMPLOYEE_COPY ���̺��� EMAIL �÷��� NOT NULL �������� �߰�
ALTER TABLE EMPLOYEE_COPY MODIFY EMAIL NOT NULL;





