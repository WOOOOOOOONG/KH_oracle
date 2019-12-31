/*
    < �ε��� INDEX >
    �ε����� � ������ �˻� ������ ����ȭ�ϱ� ���� �����ͺ��̽���
    �ο���� ������ �����ϴ� ������ ����
    �ε����� �̿��ϸ� ��ü �����͸� �˻����� �ʰ� �����ͺ��̽�����
    ���ϴ� ������ ������ �˻��� �� ����
    SQL ��ɹ��� ó�� �ӵ��� ����Ű�� ���ؼ� �÷��� ���� �����ϴ�
    ����Ŭ ��ü�� ���� ������ B*Ʈ�� �������� ������
    
    - ����
      Ʈ�� �������� �����Ǿ� �ڵ� ���� �� �˻� �ӵ��� ������
      �ý��ۿ� �ɸ��� ���ϸ� �ٿ� �ý��� ��ü ���� ���
      
    - ����
      �ε����� �߰��ϱ� ���� ������ ��������� �ʿ�
      �ε����� �����ϴµ� �ð��� �ɸ�
      ������ ���� �۾�(DML)�� ����� ��쿡�� ������ ���� ����
    
*/

/*
    1. �ε��� ���� ���
    [ǥ����]
    CREATE [UNIQUE] INDEX �ε�����
    ON ���̺��(�÷���, �÷���, ... | �Լ���, �Լ�����);

*/

-- �ε����� �����ϴ� DATA DICTIONARY
SELECT *
FROM USER_IND_COLUMNS;

---------------------------------------------------------------
-- 2. �ε��� ����

/*
    ROWID : DB�� ������ ���� �ּ�, ROWID�� �̿��� ������ ���� ����
    
    1~6 ��° : ������ ������Ʈ ��ȣ
    7~9 ��° : ���� ��ȣ
    10~15��° : BLOCK ��ȣ
    16~18��° : ROW ��ȣ
*/
SELECT ROWID, EMP_ID, EMP_NAME
FROM EMPLOYEE;
------------------------------------------------------------
-- 3. �ε��� ����
--    �ε��� ���� �� ������ �÷��� KEY, ROWID�� VALUE�� �Ǿ� 
--    MAPó�� ���� ��

-- SELECT�� WHERE���� �ε����� �����Ǿ� �ִ� �÷��� �߰��ϸ�
-- ������ ��ȸ �� ���̺��� ��� �����Ϳ� ����(Ǯ��ĳ��)�ϴ� ���� �ƴ϶�
-- �ش� �÷�(KEY)�� ��Ī�Ǵ� ROWID(VALUE)�� ����Ű�� ROW�ּ� ����
-- ��ȸ�� �־� �ӵ��� ��� ��

-- �ε��� Ȱ��
-- �ε��� Ȱ�� X SELECT��
SELECT EMP_ID, EMP_NAME
FROM EMPLOYEE
WHERE EMP_NAME = '������';

-- �ε��� Ȱ�� O SELECT��
SELECT EMP_ID, EMP_NAME
FROM EMPLOYEE
WHERE EMP_ID = '210';

/*
    WHERE����
    INDEX�� �ο����� ���� �÷����� ��ȸ ��
    --> �����ذ� ��� ���� �ִ��� �𸣱� ������ EMPLOYEE ���̺� 
        ������ ���θ� DB BUFFER ĳ�÷� ������ �� FULL SCAN���� ã��
    INDEX�� �ο��� �÷����� ��ȸ
    --> INDEX�� ���� ���� 210 ������ � ROWID�� ������ �ִ���
        Ȯ���� �� �ش� ROWID�� �ִ� ���� ã�ư��� DB BUFFER ĳ�ÿ� ����
*/

---------------------------------------------------------------
/*
    4. �ε��� ����
    
    1) ���� �ε���(UNIQUE INDEX)
    2) ����� �ε���(NONUNIQUE INDEX)
    3) ���� �ε���(SINGLE INDEX)
    4) ���� �ε���(COMPOSITE INDEX)
    5) �Լ� ��� �ε���(FUNCTION BASED INDEX)
*/

/*
    1) ���� �ε��� (UNIQUE INDEX)
    - UNIQUE INDEX�� ���� �� �÷����� �ߺ� �� ���� �Ұ�
    - ����Ŭ PRIMARY KEY, UNIQUE KEY �������� ���� �� �ش� �÷�
      �� ���� INDEX�� �������� ������ �ڵ����� �ش� �÷��� UNIQUE INDEX ����
    - PRIMARY KEY�� �̿��Ͽ� ACCESS �ϴ� ��� ���� ��� ȿ���� ����
*/

-- EMPLOYEE ���̺��� EMP_NAME �÷� UNIQUE INDEX �����ϱ�
CREATE UNIQUE INDEX IDX_EMP
ON EMPLOYEE(EMP_NAME);

-- ����ڰ� ������ �ε��� ��ȸ
SELECT *
FROM USER_INDEXES
WHERE TABLE_NAME = 'EMPLOYEE';

-- �ε����� Ű�� �Ǵ� �÷� ��ȸ
SELECT *
FROM USER_IND_COLUMNS
WHERE TABLE_NAME = 'EMPLOYEE';
--> PRIMARY KEY(EMP_ID), UNIQUE(EMP_NO)�� ���� �ε����� �̹� ����
--  �Ǿ� �ְ�, ���� ������ IDX_EMP �ε����� �߰��Ǿ� ����

-- �ε����� ������ EMP_NAME �÷��� �̿��� ��ȸ
SELECT * FROM EMPLOYEE
WHERE EMP_NAME = '������';

INSERT INTO EMPLOYEE
VALUES(100, '������', '111111-2222222', 'rkd@naver.com',
       '01011112222', 'D1', 'J7', 'S3', 3000000, 0.3, 201,
       SYSDATE, NULL, DEFAULT);
-- ������ �̸��� ���� UNIQUE ������ �������� UNIQUE INDEX ��������
-- ������ UNIQUE ���� �Է��ؾ� ��

-- EMPLOYEE ���̺��� DEPT_CODE �÷� UNIQUE INDEX ����
CREATE UNIQUE INDEX IDX_DEPTCODE
ON EMPLOYEE(DEPT_CODE);
-- duplicate keys found
--> �÷� ���� �߿� �ߺ��Ǵ� ���� ���� ��� UNIQUE INDEX ���� �Ұ�
------------------------------------------------------------
/*
    2) ����� �ε���(NONUNIQUE INDEX)
    - ����ϰ� ���Ǵ� �Ϲ� �÷��� ������� ����
    - �ַ� ���� ����� �������� ����
    
    3) ���� �ε���(SINGLE INDEX)
    - �� ���� �÷����� ���� �� �ε���

*/
-- EMPLOYEE ���̺��� DEPT_CODE �÷��� �ε��� ����
CREATE INDEX IDS_DEPTCODE
ON EMPLOYEE(DEPT_CODE);
--> �����(�ߺ� �� ���� ����)�̸鼭 ����(�÷��� �Ѱ�)�ε���

-- �ε��� �̸� ����
ALTER INDEX IDS_DEPTCODE
RENAME TO IDX_DEPTCODE;

-- �ε��� ��ȸ
SELECT * FROM USER_IND_COLUMNS
WHERE TABLE_NAME = 'EMPLOYEE';

-- �ε��� ����
DROP INDEX IDX_DEPTCODE;
-----------------------------------------------------------
/*
    4) ���� �ε���(COMPOSITE INDEX)
    - �� �� �̻��� �÷����� ���� �� �ε���
*/
-- DEPARTMENT ���̺��� DEPT_ID, DEPT_TITLE ���� �ε��� ����
CREATE INDEX IDX_DEPT
ON DEPARTMENT(DEPT_ID, DEPT_TITLE);

-- �ε��� ��ȸ
SELECT * FROM USER_IND_COLUMNS
WHERE TABLE_NAME = 'DEPARTMENT';
-- IDX_DEPT��� �ϳ��� �ε��� �̸����� �� �÷��� ������

-- ���� �ε��� Ȱ�� ����
SELECT * FROM DEPARTMENT
WHERE (DEPT_ID, DEPT_TITLE) = (SELECT DEPT_ID, DEPT_TITLE
                               FROM DEPARTMENT
                               WHERE DEPT_ID = 'D1');
------------------------------------------------------------
/*
    5. �ε��� Ȱ�� ���� Ȯ��
    
    EMPLOYEE ���̺��� ������ EMP001 ���̺��� �����
    1) EMP001 ���̺��� EMP_ID �÷��� ���� UNIQUE INDEX ���� : IDX_EID
    2) EMP001 ���̺��� EMP_ID�� 200�̸��� �� ���� ���� ���� ��
        (1) �ε��� Ȱ�� X ��ü ��ȸ
        (2) �ε��� Ȱ�� O ��ü ��ȸ
         + �ε��� ����͸��� ���� �ε��� ����͸� ��� ���� Ȯ��
*/
-- EMP001 ���̺� ����
CREATE TABLE EMP001
AS SELECT * FROM EMPLOYEE;

-- 1) EMP_ID �÷��� ���� UNIQUE INDEX ����
CREATE UNIQUE INDEX IDX_EID
ON EMP001(EMP_ID);

-- �ε��� ��ȸ
SELECT * FROM USER_IND_COLUMNS
WHERE TABLE_NAME = 'EMP001';

-- 2) EMP001 ���̺� EMP_ID�� 200�̸��� ������ ����
INSERT INTO EMP001
VALUES(199, '�׽�Ʈ', '880101-1234567', 'test@kh.or.kr', 
       '01096341245', 'D9', 'J1', 'S3', 1000000, 0.5, NULL,
       SYSDATE, NULL, DEFAULT);
       
-- �ε��� ����͸� : ������� �ε����� ��ȸ �� ��� �Ǿ����� Ȯ��
-- ����͸� �� �ε��� ����
ALTER INDEX IDX_EID MONITORING USAGE;

-- �ε��� ����͸�
SELECT *
FROM V$OBJECT_USAGE;
-- V$OBJECT_USAGE : �ε��� Ȱ��� ���� �� �����͸� �����ϴ� ��
-- USED : ����͸� ���� �� �ش� �ε����� ���Ǿ����� Ȯ��

-- (1) �ε��� Ȱ�� X ��ü ��ȸ
SELECT * FROM EMP001;
--> �� ������ ������ ���̺��� ���� �������� ��ȸ ��

-- �ε��� ����͸�
SELECT *
FROM V$OBJECT_USAGE;

-- (2) �ε��� Ȱ�� O ��ü ��ȸ
SELECT * FROM EMP001
WHERE EMP_ID > '0';
--> �� ������ ������ �ڵ� ���ĵǾ� ���� ���� ��ȸ ��

-- �ε��� ����͸�
SELECT *
FROM V$OBJECT_USAGE;

-- �ε��� ����͸� ����
ALTER INDEX IDX_EID NOMONITORING USAGE;
----------------------------------------------------------
/*
    5. �Լ� ��� �ε���(FUNCTION-BASED INDEX)
    - SELECT���̳� WHERE���� ��� �����̳� �Լ����� ���� ���
    ������ �ε����� ������ ���� ����
    - �������� �˻��ϴ� ��찡 ������, �����̳� �Լ����� �ε�����
      ���� �� �ִ�.
*/
-- SALARY �÷��� �ε��� ����
CREATE INDEX IDX_SAL
ON EMPLOYEE(SALARY);

-- ����͸� ON
ALTER INDEX IDX_SAL MONITORING USAGE;

-- ��� ����, �Լ��� ����Ͽ� SELECT
SELECT EMP_ID, EMP_NAME, SALARY, ((SALARY + (SALARY * NVL(BONUS, 0)))*12)
FROM EMPLOYEE
WHERE ((SALARY + (SALARY * NVL(BONUS, 0)))*12) > 30000000;

-- �ε��� ����͸� : USED -> NO
SELECT *
FROM V$OBJECT_USAGE;

-- �Լ� ��� �ε��� ����
CREATE INDEX IDX_SALYEAR
ON EMPLOYEE(((SALARY + (SALARY * NVL(BONUS, 0))) * 12));

-- �ε��� ��ȸ
SELECT * FROM USER_IND_COLUMNS
WHERE TABLE_NAME = 'EMPLOYEE';

-- ����͸� ON
ALTER INDEX IDX_SALYEAR MONITORING USAGE;

-- �Լ� ��� �ε��� ����� SELECT
SELECT EMP_ID, EMP_NAME, SALARY, ((SALARY + (SALARY * NVL(BONUS, 0)))*12)
FROM EMPLOYEE
WHERE ((SALARY + (SALARY * NVL(BONUS, 0)))*12) > 30000000;

-- �ε��� ����͸� : USED -> YES
SELECT *
FROM V$OBJECT_USAGE;
-----------------------------------------------------------
/* 
    6. �ε��� �籸��(INDEX REBUILD)
    DML �۾� ���� ������ ���
    �ش� �ε��� ������ ��Ʈ���� �������θ� ���ŵǰ� ���� ��Ʈ����
    �׳� �����ְ� �ȴ�. �ε����� �ʿ� ���� ������ ����(������� ����)
    �ϰ� �ֱ� ������ �ε����� �� ���� �� �ʿ䰡 ����!!!
    
*/
ALTER INDEX IDX_EID REBUILD;













