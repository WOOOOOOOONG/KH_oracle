-- DML(INSERT, UPDATE, DELETE)

-- DDL : ������ ���Ǿ�, �����ͺ��̽��� ����(��Ű��)�� ����, ����, ����
-- CREATE, ALTER, DROP
--> �ϳ��� DDL ������ �ϳ��� Ʈ����� (AUTO COMMIT)

-- DML : ������ ���۾�, �����ͺ��̽��� �����͸� ��ȸ, ����, ����, ����
-- SELECT(DQL), INSERT, UPDATE, DELETE
--> ���� DML ������ �ϳ��� Ʈ�����

-- TCL, DCL : ������ �����, ������ �ְų� ȸ���� �� ������ Ʈ����� ������ ��
-- GRANT, REVOKE, COMMIT, ROLLBACK
--> �ϳ��� DCL ������ �ϳ��� Ʈ�����(AUTO COMMIT)

-- TRANSACTION�� ������ ù DML ���� ���� ��
-- COMMIT �Ǵ� ROLLBACK ���� �� �ݿ�
-- DDL �Ǵ� DCL ���� ���� ��, ���� ���� ��(AUTO COMMIT)
-- �ý��� ��� ��(AUTO ROLLBACK)

------------------------------------------------------------------------------------------------
-- 1. INSERT

-- ���ο� ���� �߰��ϴ� ����
-- ���̺��� �� ������ ����

-- [ǥ����]
-- INSERT INTO ���̺��(�÷���, �÷���, �÷���, ... )
-- VALUES (������1, ������2, ������3, ... );
-- ���̺� ���� ������ �÷��� ���� ���� INSERT �� �� ���
-- ���� �� �� �÷��� NULL ���� ��
INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL,
                      SALARY, BONUS, MANAGER_ID, HIRE_DATE, ENT_DATE, ENT_YN)
VALUES (900, '��ä��', '901123-1080503', 'jang_ch@kh.or.kr', '01055569512', 'D1', 'J7', 'S3',
        4300000, 0.2, '200', SYSDATE, NULL, DEFAULT);

SELECT * FROM EMPLOYEE
WHERE EMP_NAME = '��ä��';

-- INSERT INTO ���̺�� VALUES(������, ������, ...)
-- ���̺� ��� �÷��� ���� ���� INSERT �� �� ���
-- INSERT �ϰ��� �ϴ� �÷��� ��� �÷��� ��� �÷��� ���� ����
-- ��, �÷��� ������ ���Ѽ� VALUES ���� �����ؾ� ��
ROLLBACK;

INSERT INTO EMPLOYEE
VALUES (900, '��ä��', '901123-1080503', 'jang_ch@kh.or.kr', '01055569512', 'D1', 'J7', 'S3',
        4300000, 0.2, '200', SYSDATE, NULL, DEFAULT);
        
COMMIT;

SELECT * FROM EMPLOYEE
WHERE EMP_NAME = '��ä��';

-- INSERT�� VALUES ��� �������� ��� ����
CREATE TABLE EMP_01(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(30),
    DEPT_TITLE VARCHAR2(20)
);

INSERT INTO EMP_01 (
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE
    FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
);

SELECT *
FROM EMP_01;

-------------------------------------------------------------------------------------------

-- 2. INSERT ALL

-- INSERT�� ���������� ����ϴ� ���̺��� ���� ���, �� �� �̻��� ���̺� INSERT ALL�� �̿��Ͽ� �ѹ���
-- ���� ����. ��, �� ���������� �������� ���ƾ� ��

-- INSERT ALL ����1
CREATE TABLE EMP_DEPT_D1
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
   FROM EMPLOYEE
   WHERE 1 = 0;
-- WHERE���� 1 = 0�� ��� ��� �࿡ ���� FALSE�� ���� �ƹ� ���ǵ� �������� �����Ƿ�
-- ���� ���Ե��� �ʰ� ���̺� �÷��� �����ȴ�.
SELECT *
FROM EMP_DEPT_D1;

CREATE TABLE EMP_MANAGER
AS SELECT EMP_ID, EMP_NAME, MANAGER_ID
   FROM EMPLOYEE
   WHERE 1 = 0;

SELECT *
FROM EMP_MANAGER;

-- EMP_DEPT_D1 ���̺� EMPLOYEE ���̺� �ִ� �μ��ڵ尡 D1�� ������ ��ȸ�ؼ�
-- ���, �̸�, �ҼӺμ�, �Ի����� �����ϰ�,
-- EMP_MANAGER ���̺� EMPLOYEE ���̺� �ִ� �μ��ڵ尡 D1�� ������ ��ȸ�ؼ�
-- ���, �̸�, ������ ����� ��ȸ�ؼ� ����

-- ���� INSERT�� ���
INSERT INTO EMP_DEPT_D1(
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
    FROM EMPLOYEE
    WHERE DEPT_CODE = 'D1'
);

SELECT *
FROM EMP_DEPT_D1;

INSERT INTO EMP_MANAGER(
    SELECT EMP_ID, EMP_NAME, MANAGER_ID
    FROM EMPLOYEE
    WHERE DEPT_CODE = 'D1'
);

SELECT *
FROM EMP_MANAGER;

-- ���������� �������� DEPT_CODE = 'D1'���� ����
ROLLBACK;

INSERT ALL
INTO EMP_DEPT_D1 VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
INTO EMP_MANAGER VALUES(EMP_ID, EMP_NAME, MANAGER_ID)
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
    FROM EMPLOYEE
    WHERE DEPT_CODE = 'D1';

SELECT * FROM EMP_DEPT_D1;
SELECT * FROM EMP_MANAGER;

-- INSERT ALL ����2
-- EMPLOYEE ���̺��� ������ �����Ͽ� ���, �̸�, �Ի���, �޿��� ����� �� �ִ�
-- ���̺� EMP_OLD�� EMP_NEW ����
CREATE TABLE EMP_OLD
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
   FROM EMPLOYEE
   WHERE 1 = 0;
   
CREATE TABLE EMP_NEW
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
   FROM EMPLOYEE
   WHERE 1 = 0;
   
-- EMPLOYEE ���̺��� �Ի��� �������� 2000�� 1�� 1�� ������ �Ի��� ����� ���, �̸�, �Ի���, �޿���
-- ��ȸ�ؼ� EMP_OLD ���̺� �����ϰ� �� �Ŀ� �Ի��� ����� ������ EMP_NEW ���̺� ����
INSERT ALL
WHEN HIRE_DATE < '2000/01/01' THEN
     INTO EMP_OLD VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
WHEN HIRE_DATE >= '2000/01/01' THEN
     INTO EMP_NEW VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
FROM EMPLOYEE;

SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

-----------------------------------------------------------------------------------------------
-- 3. UPDATE
-- ���̺� ��� �� �÷��� ���� �����ϴ� ����
-- ���̺� ��ü �� �������� ��ȭ�� ����

-- [ǥ����]
-- UPDATE ���̺�� SET �÷��� = �ٲܰ� [WHERE �÷��� �񱳿����� �񱳰�];

CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY;

-- DEPT_COPY ���̺��� DEPT_ID�� 'D9'�� ���� DEPT_TITLE�� '������ȹ��'���� ����
UPDATE DEPT_COPY
SET DEPT_TITLE = '������ȹ��'
WHERE DEPT_ID = 'D9';

SELECT * FROM DEPT_COPY;

COMMIT;

-- �������� �������� �ʰ� UPDATE ���� ���� �� ��� ���� �÷� �� ����
UPDATE DEPT_COPY
SET DEPT_TITLE = '������ȹ��';

SELECT * FROM DEPT_COPY;

ROLLBACK;

-- UPDATE �ÿ��� ���������� ��� ����
-- [ǥ����]
-- UPDATE ���̺��
-- SET �÷��� = (��������)

-- ��� �� ����� ����� �η����ϴ� ���� ����� �޿��� ���ʽ����� ����� ����� �����ϰ� 
-- �������ֱ�� �ߴ�. �̸� �ݿ��ϴ� UPDATE ���� �ۼ��Ͻÿ�.
CREATE TABLE EMP_SALARY
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS
   FROM EMPLOYEE;

SELECT * FROM EMP_SALARY
WHERE EMP_NAME IN('�����', '����');

UPDATE EMP_SALARY
SET SALARY = (SELECT SALARY
              FROM EMPLOYEE
              WHERE EMP_NAME = '�����'),
    BONUS = (SELECT BONUS
             FROM EMPLOYEE
             WHERE EMP_NAME = '�����')
WHERE EMP_NAME = '����';

SELECT * FROM EMP_SALARY
WHERE EMP_NAME IN('�����', '����');

-- ���� ����� �޿� �λ� �ҽ��� ���ص��� �ٸ� ������� ��ü�� �ľ��� �����ߴ�
-- ���ö, ������, ������, �ϵ��� ����� �޿��� ���ʽ��� ����� ����� �޿��� ���ʽ��� ����
-- �����ϴ� UPDATE���� �ۼ��Ͻÿ�(������ ���߿� ���������� �̿�) : EMP_SALARY�� ����
SELECT * FROM EMP_SALARY
WHERE EMP_NAME IN ('���ö', '������', '������', '�ϵ���');

UPDATE EMP_SALARY
SET (SALARY, BONUS) = (SELECT SALARY, BONUS
                       FROM EMP_SALARY
                       WHERE EMP_NAME = '�����')
WHERE EMP_NAME IN ('���ö', '������', '������', '�ϵ���');

SELECT * FROM EMP_SALARY
WHERE EMP_NAME IN ('�����', '���ö', '������', '������', '�ϵ���');

-- �ƽþ� ���� �ٹ� ���� ���ʽ� 0.3���� ���� : EMP_SALARY�� ����
SELECT EMP_ID, EMP_NAME, SALARY, BONUS, LOCAL_NAME 
FROM EMP_SALARY
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE LOCAL_NAME LIKE 'ASIA%';
-- DEPARTMENT�� ���� JOIN���� ������ LOCATION JOIN �Ұ���

-- �ƽþ� ���� �ٹ� ���� ���ʽ� 0.3���� ����
UPDATE EMP_SALARY
SET BONUS = 0.3
WHERE EMP_ID IN (SELECT EMP_ID
                 FROM EMPLOYEE
                 JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
                 JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
                 WHERE LOCAL_NAME LIKE 'ASIA%');

SELECT EMP_ID, EMP_NAME, SALARY, BONUS, LOCAL_NAME 
FROM EMP_SALARY
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE LOCAL_NAME LIKE 'ASIA%';

-- UPDATE�� ������ ���� �ش� �÷��� ���� �������ǿ� ������� �ʾƾ� ��

-- EMPLOYEE�� �������� ����
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT(DEPT_ID);
ALTER TABLE EMPLOYEE ADD UNIQUE(EMP_NO);

UPDATE EMPLOYEE
SET DEPT_CODE = '65'
WHERE DEPT_CODE = 'D6'; -- FOREIGN KEY ���� ���� �����

UPDATE EMPLOYEE
SET EMP_NAME = NULL
WHERE EMP_ID = 200; -- NOT NULL �������� �����

UPDATE EMPLOYEE
SET EMP_NO = '621231-1985634'
WHERE EMP_ID = 201; -- UNIQUE �������� �����

COMMIT;

UPDATE EMPLOYEE
SET ENT_YN = DEFAULT
WHERE EMP_ID = 222;

SELECT * FROM EMPLOYEE;

ROLLBACK;
-------------------------------------------------------------------------------------------------

-- 4. MERGE(����)
-- ������ ���� �� ���� ���̺��� �ϳ��� ��ġ�� ���
-- ���̺� �����ϴ� ������ ���� �����ϸ� UPDATE
-- ������ ���� ������ INSERT ��.
CREATE TABLE EMP_M01
AS SELECT * FROM EMPLOYEE;

CREATE TABLE EMP_M02
AS SELECT * FROM EMPLOYEE
   WHERE JOB_CODE = 'J4';
   
INSERT INTO EMP_M02
VALUES (999, '���ο�', '561016-1234567', 'kwack_dw@kh.or.kr', '01011112222', 
        'D9', 'J4', 'S1', 90000000, 0.5, NULL, SYSDATE, NULL, DEFAULT);

UPDATE EMP_M02
SET SALARY = 0;

SELECT * FROM EMP_M01;
SELECT * FROM EMP_M02;

MERGE INTO EMP_M01 M1 USING EMP_M02 M2 ON(M1.EMP_ID = M2.EMP_ID)
WHEN MATCHED THEN
UPDATE SET
M1.EMP_NAME = M2.EMP_NAME,
M1.EMP_NO = M2.EMP_NO,
M1.EMAIL = M2.EMAIL,
M1.PHONE = M2.PHONE,
M1.DEPT_CODE = M2.DEPT_CODE,
M1.JOB_CODE = M2.JOB_CODE,
M1.SAL_LEVEL = M2.SAL_LEVEL,
M1.SALARY = M2.SALARY,
M1.BONUS = M2.BONUS,
M1.MANAGER_ID = M2.MANAGER_ID,
M1.HIRE_DATE = M2.HIRE_DATE,
M1.ENT_DATE = M2.ENT_DATE,
M1.ENT_YN = M2.ENT_YN
WHEN NOT MATCHED THEN
INSERT VALUES(M2.EMP_ID, M2.EMP_NAME, M2.EMP_NO, M2.EMAIL, M2.PHONE, M2.DEPT_CODE, 
                M2.JOB_CODE, M2.SAL_LEVEL, M2.SALARY, M2.BONUS, M2.MANAGER_ID, M2.HIRE_DATE, M2.ENT_DATE, M2.ENT_YN);

SELECT * FROM EMP_M01;

-----------------------------------------------------------------------------------------------------------------------

-- 5. DELETE

-- ���̺��� ���� �����ϴ� ����
-- ���̺��� ���� ������ �پ��

-- [ǥ����] 
-- DELETE FROM ���̺�� WHERE ���Ǽ���
-- ���� WHERE ������ �������� ������ ��� ���� �� ������

DELETE FROM EMPLOYEE
WHERE EMP_NAME = '��ä��';

SELECT * FROM EMPLOYEE;

ROLLBACK;

DELETE FROM EMPLOYEE;

SELECT * FROM EMPLOYEE;

ROLLBACK;

DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D1'; -- FOREIGN KEY ���������� �����Ǿ� �ִ� ��� �����ǰ� �ִ� ���� ���ؼ��� ���� �Ұ�

DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D3'; -- FOREIGN KEY ���������� �����Ǿ� �־ �����ǰ� ���� ���� ���� ���� ���� 
--> ������ Ű ��ü�� ��������� �ٸ� Ű�� �����ǰ� ������ ������� �� �����Ƿ� �����Ǵ� ���� ���� �ȵ�.

ROLLBACK;

-- ���� �� FOREIGN KEY ������������ �÷� ������ �Ұ����� ��� ���������� ��Ȱ��ȭ �� �� �ִ�.
ALTER TABLE EMPLOYEE_COPY
DISABLE CONSTRAINT SYS_C007141 CASCADE;
--> EMPLOYEE_COPY�� FOREIGN KEY ��Ȱ��ȭ

ALTER TABLE EMPLOYEE
DISABLE CONSTRAINT SYS_C007178 CASCADE;
--> EMPLOYEE�� FOREIGN KEY ��Ȱ��ȭ
--> ���� ������ �� �� �ɾ EMPLOYEE_COPY�� ������ �Ŀ� �� �ߴ� ������ �������� ��Ȱ��ȭ ���Ѿ� �Ѵ�.

DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D1';

SELECT * FROM DEPARTMENT;
SELECT * FROM EMPLOYEE;

ROLLBACK;

-- ��Ȱ��ȭ�� ���� ������ �ٽ� Ȱ��ȭ
ALTER TABLE EMPLOYEE
ENABLE CONSTRAINT SYS_C007178;

-- EMPLOYEE_COPY�� FOREIGN KEY Ȱ��ȭ
ALTER TABLE EMPLOYEE_COPY
ENABLE CONSTRAINT SYS_C007141;

-- TRUNCATE : ���̺��� ��ü ���� ������ �� ���
--            DELETE���� ���� �ӵ��� �� ����
--            ROLLBACK�� ���� ������ �� ����(DML�� �ƴ� DDL ������)
SELECT * FROM EMP_SALARY;
COMMIT;

-- DELETE �׽�Ʈ
DELETE FROM EMP_SALARY;

SELECT * FROM EMP_SALARY;

ROLLBACK;

SELECT * FROM EMP_SALARY;

-- TRUNCATE �׽�Ʈ
TRUNCATE TABLE EMP_SALARY;

SELECT * FROM EMP_SALARY;

ROLLBACK;

SELECT * FROM EMP_SALARY; -- �̹� ������ ����ų �� ����.��
