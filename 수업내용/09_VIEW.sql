-- VIEW(��)
-- SELECT ������ ���� ����� ȭ�鿡 ������ ���� *����* ���̺�

-- SELECT ���� ������ ��� ȭ���� ������ ��ü
-- ������ ���� ���̺�
-- ���������� �����͸� �������� �ʴ´�
-- ���̺��� ����ϴ� �Ͱ� �����ϰ� ��� ����

-- ��� ���� ?
-- Ư�� �����ͳ� �÷��� ������ ���������� ������ �� ����(�ΰ��� ���� ��ȣ)
-- ��� �󵵰� ���� ������ ������ �ִٸ� �̸� VIEW�� ����� ����ϸ� ���ϴ�.

-- [ǥ����]
-- CREATE [OR REPLACE] VIEW ���̸� AS ��������
-- [OR REPLACE] : �� ������ ������ ���� �̸��� �䰡 �ִٸ� �ش� ��� ����
--> OR REPLACE �������� ���� �̸��� �� ������ �̹� �ٸ� ��ü�� ������̶�� ���� �߻�.

-- [����]
-- �信 ���� ������ Ȯ���ϴ� ������ ��ųʸ�
SELECT *
FROM USER_VIEWS;

--------------------------------------
-- 1. VIEW ��� ����
-- ���, �̸�, �μ���, �ٹ������� ��ȸ�ϰ� �� ����� V_EMPLOYEE��� �並 �����ؼ� ����
CREATE TABLE V_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
LEFT JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
LEFT JOIN NATIONAL USING(NATIONAL_CODE);

--> * ORA-01031 : INSUFFICIENT PRILIEGE(���� �߻�)

-- 1) SYSTEM ���� �α���
-- 2) KH������ �� ���� ���� �ο�
SELECT * FROM V_EMPLOYEE;

-- �� ��ȸ
SELECT * FROM V_EMPLOYEE;

-- *** ���̽� ���̺��� ������ ������ �Ǹ� VIEW�� ����� ***
COMMIT;

-- ��� 205���� ������ �̸��� '���߾�'���� ����
UPDATE EMPLOYEE
SET EMP_NAME = '���߾�'
WHERE EMP_ID = 205;

-- ���̽� ���̺� Ȯ��
SELECT * FROM EMPLOYEE WHERE EMP_ID = 205;

SELECT * FROM V_EMPLOYEE
WHERE EMP_ID = 205;

ROLLBACK;

-- ���� �� �� �÷��� ��Ī �ο�
-- ���������� SELECT���� �Լ��� ���� ��� �ݵ�� ��Ī ����
-- �� �������� �ȿ� ������ ����� ���Ե� �� �ִ�.
CREATE OR REPLACE VIEW V_EMP_JOB(���, �̸�, ����, ����, �ٹ����) -- ��Ī ������ ����
AS SELECT EMP_ID, EMP_NAME, JOB_NAME, DECODE(SUBSTR(EMP_NO, 8), 1, '��', 2, '��'),
          EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
   FROM EMPLOYEE
   JOIN JOB USING(JOB_CODE);
   
SELECT * FROM V_EMP_JOB;
   
DROP VIEW V_EMP_JOB;

-- ������ �並 �̿��� DML(INSERT, UPDATE, DELETE) ��� ����
-- �信�� ��û�� DML ������ ���̽� ���̺� ������.
CREATE OR REPLACE VIEW V_JOB
AS SELECT JOB_CODE, JOB_NAME
   FROM JOB;
   
SELECT * FROM V_JOB;

-- �信 INSERT ���
INSERT INTO V_JOB VALUES('J8', '����');

-- ���̽� ���̺� ����Ǿ����� Ȯ��
SELECT * FROM V_JOB;
--> JOB���� ����

-- �信 UPDATE ���
UPDATE V_JOB
SET JOB_NAME = '�˹�'
WHERE JOB_CODE = 'J8';

SELECT * FROM V_JOB;
SELECT * FROM JOB;

DELETE FROM V_JOB
WHERE JOB_CODE = 'J8';

SELECT * FROM V_JOB;
SELECT * FROM JOB;

----------------------------------------------------------------
-- 2. DML ��ɾ�� ������ �Ұ����� ���
-- 1) �� ���ǿ� ���Ե��� ���� �÷��� �����ϴ� ���
CREATE OR REPLACE VIEW V_JOB2
AS SELECT JOB_CODE
   FROM JOB;
   
SELECT * FROM V_JOB2;
--> INSERT INTO V_JOB2 VALUES('J8', '����'); -> �ȵ�

UPDATE V_JOB2
SET JOB_NAME = '����'
WHERE JOB_CODE = 'J7';
-- �ȵǴ� ���� 1, 1
DELETE FROM V_JOB2
WHERE JOB_NAME = '���';

-- �信 ���ǵ� �÷��� ���� ����
INSERT INTO V_JOB VALUES('J8');
SELECT * FROM JOB;

-- �����ϱ�
DELETE FROM JOB
WHERE JOB_CODE = 'J8';


-- 2) �信 ���Ե��� ���� �÷� �߿�, ���̽��� �Ǵ� ���̺� �÷��� NOT NULL ���������� ������ ���(INSERT�� ����. NOT NULL�̸� �ȵǴϱ�)
CREATE OR REPLACE VIEW V_JOB3
AS SELECT JOB_NAME
    FROM JOB;
    
SELECT * FROM V_JOB3;

INSERT INTO V_JOB3 VALUES ('����');
INSERT INTO V_JOB3 VALUES ('JB', '����');
-- ���� ��

-- UPDATE/DELETE�� ����
INSERT INTO JOB VALUES ('J8', '����'); -- ���̽� ���̺�
UPDATE V_JOB3 SET JOB_NAME = '�˹�' WHERE JOB_NAME = '����';

DELETE FROM V_JOB3 WHERE JOB_NAME = '�˹�';


-- 3) ���ǥ�������� ���ǵ� ���
CREATE OR REPLACE VIEW EMP_SAL
AS SELECT EMP_ID, EMP_NAME, SALARY,
         (SALARY + (SALARY*NVL(BONUS,0)))*12 ����
   FROM EMPLOYEE;

SELECT * FROM EMP_SAL;

-- �信 ��� ������ ���Ե� ��� INSERT/UPDATE �� ���� �߻�
INSERT INTO EMP_SAL VALUES(800, '������', 3000000, 3600000);
--�ȵ�
UPDATE EMP_SAL
SET ���� = 8000000
WHERE EMP_ID = 200;
-- �ȵ�
COMMIT;
DELETE FROM EMP_SAL
WHERE ���� = 124800000; -- ������

SELECT * FROM EMP_SAL;
SELECT * FROM EMPLOYEE;

ROLLBACK;


-- 4) �׷��Լ��� GROUP BY���� ǥ���� ���
CREATE OR REPLACE VIEW V_GROUPDEPT
AS SELECT DEPT_CODE, SUM(SALARY) �հ�, AVG(SALARY) ���
   FROM EMPLOYEE
   GROUP BY DEPT_CODE;

SELECT * FROM V_GROUPDEPT;

-- �׷��Լ� �Ǵ� GROUP BY �Լ��� ����� ��� INSERT/UPDATE/DELETE �ȵ�.
INSERT INTO V_GROUPDEPT
VALUES ('D10', 600000, 4000000); --����

UPDATE V_GROUPDEPT
SET DEPT_CODE = 'D10'
WHERE DEPT_CODE = 'D1'; -- ����

DELETE FROM V_GROUPDEPT
WHERE DEPT_CODE = 'D1';


-- 5) DISTINCT�� ������ ��� (INSERT, UPDATE, DELETE �� �ȵ�)
CREATE OR REPLACE VIEW V_DT_EMP
AS SELECT DISTINCT JOB_CODE
   FROM EMPLOYEE;
   
SELECT * FROM V_DT_EMP;

INSERT INTO V_DT_EMP VALUES('J9'); -- ERROR
UPDATE V_DT_EMP SET JOB_CODE = 'J9' WHERE JOB_CODE = 'J7'; -- ERROR
DELETE FROM V_DT_EMP WHERE JOB_CODE = 'J1'; -- ERROR


-- 6) JOIN�� �̿��� ���� ���̺��� ������ ��� (INSERT, UPDATE �Ұ��� DELETE ����)
CREATE OR REPLACE VIEW V_JOINEMP
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE
   FROM EMPLOYEE
   JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE);
   
INSERT INTO V_JOINEMP VALUES ('22521', '�ӿ�', '��Ű�'); --ERROR
UPDATE V_JOINEMP SET EMP_NAME = '��ȯ' WHERE EMP_NAME = '�ӿ�'; -- ERROR. ����� �� �� ���̺� �����ִ� �÷��� �ƴϸ� ������Ʈ ����. �׷� INSERT�� �Ȱ��������� �����ϰڳ�
DELETE FROM V_JOINEMP WHERE EMP_NAME = '�ӿ�'; -- ����

SELECT * FROM V_JOINEMP;

---------------------------------------------------------------------------------------------------------------------
-- 3. VIEW ����
-- �� ���� �� ����� ���� ������ TEXT �÷��� ����Ǿ� ������
-- �䰡 ����� ���� TEXT�� ��ϵ� SELECT�� ������ �ٽ� ����Ǹ鼭 ����� �����ִ� ����

-- ����� ���� �� Ȯ�� ������ ��ųʸ�(USER_VIEWS)
SELECT * FROM USER_VIEWS; -- ���� ������ VIEW���� ������ ���´�.

---------------------------------------------------------------------------------------------------------------------
-- 4) VIEW �ɼ�
-- VIEW ���� ǥ����
/*
    CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW ���̸� [(ALIAS[, ALIAS]...]
    AS SUBQUERY
    [WITH CHECK OPTION]
    [WITH READ ONLY];
*/

-- 1) OR REPLACE : ������ ������ �� �̸��� �����ϴ� ��� �����, �������� ������ ���� ����
-- 2) FORCE | NOFORCE
--    FORCE : ���������� ���� ���̺��� �������� �ʾƵ� �� ����
--    NOFORCE : ���������� ���� ���̺��� �����ؾ߸� �� ����(NOFORCE�� �⺻��)
-- 3) WITH CHECK OPTION : �ɼ��� ������ �÷��� ���� ���� �Ұ����ϰ� ��
-- 4) WITH READ ONLY : �信 ���� ��ȸ�� ����(DML ���� �Ұ�)
---------------------------------------------------------------------------------------------------------------------
-- 1) OR REPLACE �ɼ� : ������ ������ �� �̸��� �����ϴ� ��� �����, �������� ������ ���� ����
CREATE OR REPLACE VIEW V_EMP2
AS SELECT EMP_NO, EMP_NAME 
   FROM EMPLOYEE;

SELECT * FROM V_EMP2;

-- OR REPLACE �ɼ� ��� �� �����
CREATE OR REPLACE VIEW V_EMP2
AS SELECT EMP_NO, EMP_NAME, SALARY
   FROM EMPLOYEE;
   
SELECT * FROM V_EMP2;

-- OR REPLACE �ɼ� ���� �� ����� ���� ����
CREATE VIEW V_EMP2
AS SELECT EMP_NO, EMP_NAME, SALARY
   FROM EMPLOYEE;
   
SELECT * FROM V_EMP2;

-------------------------------------------
-- 2) FORCE / NOFORCE
CREATE OR REPLACE FORCE VIEW V_EMP
AS SELECT TCODE, TNAME, TCONTENT
   FROM TT;
-- ��� �޽����� �߰� �� ������ ������

SELECT * FROM V_EMP;
SELECT * FROM USER_VIEWS;

-- �� ���� �Ұ���. 
CREATE OR REPLACE NOFORCE VIEW V_EMP
AS SELECT TCODE, TNAME, TCONTENT
   FROM TT;
   
-----------------------------------------
-- 3) WITH CHECK OPTION : �ɼ��� ������ �÷��� ���� ���� �Ұ����ϰ� ��(������ ����). WHERE ���� �ڿ���
CREATE OR REPLACE VIEW V_EMP3
AS SELECT * FROM EMPLOYEE
WHERE DEPT_CODE = 'D1' WITH CHECK OPTION;

INSERT INTO V_EMP3
VALUES(666, '������', '6666666-6666666', 'oh_hj@kh.or.kr', '01012344321', 'D1', 'J7', 'S1', 
        8000000, 0.1, 201, SYSDATE, NULL, DEFAULT);

UPDATE V_EMP3
SET DEPT_CODE = 'D2'
WHERE DEPT_CODE = 'D1';

COMMIT;

-- ������ ����
DELETE FROM V_EMP3
WHERE DEPT_CODE = 'D1';

ROLLBACK;

----------------------
-- 4) WITH READ ONLY : �信 ���� ��ȸ�� ����(DML ���� �Ұ�)
CREATE OR REPLACE VIEW V_DEPT
AS SELECT * FROM EMPLOYEE 
WHERE DEPT_CODE = 'D1'
WITH READ ONLY;
-- �������� �޾��ֱ�

-----------
-- �ζ��� �� : ��Ī���� ����ϴ� �Ͱ� ���� �並 ���� �� ��ü�� �ٷ� �� �ִ� ����� ���ϴµ�.