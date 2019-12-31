SELECT * FROM EMPLOYEE;

-- ����Ŭ�� SQL Plus�� SQL Developer
-- SQL Plus�� CLI(Command Line Interface) ����� ��, ����Ŭ ��ġ �� �⺻���� ����
-- SQL Developer�� GUI(Graphic User Interface) ����� ��, ����� ���Ǽ��� ũ�� �߰������� ��ġ
-- �� �� ��� ����Ŭ �����ͺ��̽��� SQL �� PL/SQL������ ������ �� �ִ� ȯ���� ����

-- DML : ������ ���۾�, �����ͺ��̽��� �����͸� ��ȸ(SELECT), ����(INSERT), ����(UPDATE), ����(DELETE)�� �� �ִ�.
-- DDL : ������ ���Ǿ�, �����ͺ��̽��� ����(��Ű��)�� ����(CREATE), ����(ALTER), ����(DROP)�� �� �ִ�.
-- TCL : ������ �����, ������ �ְų�(GRANT) ȸ��(REVOKE)�� �� ������ Ʈ����� ����(COMMIT, ROLLBACK)�� �Ѵ�.

-- *** SELECT ***
-- Result Set : SELECT �������� �����͸� ��ȸ�� �����, ��ȯ�� ����� ������ �ǹ�

-- EMPLOYEE ���̺��� ��� ��ȣ, ������, �޿� ��ȸ
-- ��ȸ�ϰ��� �ϴ� �÷����� �Է�
SELECT EMP_ID, EMP_NAME, EMP_SALARY FROM EMPLOYEE;

-- ��ҹ��� �������� ����
-- SQL Developer���� ALT + '�� ���� �ٲ� �� ����
SELECT * FROM EMPLOYEE;

SELECT * FROM JOB;
SELECT JOB_NAME FROM JOB;

-- -------------------------------------
-- *** �÷��� ������� ***
-- SELECT�� �÷��� �Է� �κп� ��꿡 �ʿ��� �÷���, ����, �����ڸ� �̿��Ͽ� ����� ��ȸ�� �� �ִ�
-- EMPLOYEE ���̺��� ������ ����, ���� ��ȸ(������ �޿� * 12)
SELECT EMP_NAME, SALARY * 12 FROM EMPLOYEE;

-- EMPLOYEE ���̺��� ������ ������, ����, ���ʽ��� �߰��� ���� ��ȸ
SELECT EMP_NAME, SALARY * 12, (SALARY + (SALARY * BONUS) * 12) FROM EMPLOYEE;

---------------- �ǽ� ���� ----------------
SELECT EMP_NAME, SALARY, (SALARY + (SALARY * BONUS)) * 12, (SALARY + (SALARY * BONUS)) * 12 - (SALARY * 12 * 0.03) FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, SYSDATE - HIRE_DATE FROM EMPLOYEE;

-- **�÷� ��Ī** --
-- ���� : �÷��� AS ��Ī / �÷��� ��Ī / �÷Ÿ� AS "��Ī" / �÷��� "��Ī"
-- �÷���, ���̺�� ���� ������ �̿��� �ܼ�ȭ�ϰ�, ��Ȯ�ϰ� �� �� �ִ�
-- FROM���� ���̺�� Alias ���� �� �ش� Alias�� ���̺� �̸� ��� ��� ����
-- ��Ī�� ����, ��ȣ�� ���Ե� ���� �ݵ�� ""�� ��� ǥ���ؾ� �Ѵ�.

-- EMPLOYEE ���̺��� ������ ������(��Ī:�̸�), ����(��Ī:����(��)), ���ʽ��� �߰��� ����(��Ī:�Ѽҵ�(��)) ��ȸ
SELECT EMP_NAME �̸�, SALARY*12 "����(��)", SALARY*(1+BONUS)*12 AS "�Ѽҵ�(��)"
FROM EMPLOYEE;

-------------------- ���ͷ� ---------------
-- ���Ƿ� ������ ���ڿ��� SELECT���� ����ϸ�, ���̺� �����ϴ� ������ó�� ��� ����
-- ���ڳ� ��¥ ���ͷ��� ''��ȣ ���
-- ���ͷ��� Result Set�� ��� �࿡ �ݺ�ǥ�� ��.

-- EMPLOYEE ���̺��� ������ ������ȣ, �����, �޿�, ����(������ �� : ��) ��ȸ
SELECT EMP_ID, EMP_NAME, SALARY, '��' AS ���� FROM EMPLOYEE;

--------------DISTINCT--------------
-- �÷��� ���Ե� �ߺ����� �� ������ ǥ���ϰ��� �� �� ���
-- EMPLOYEE ���̺��� ������ ���� �ڵ� ��ȸ
SELECT DISTINCT JOB_CODE
FROM EMPLOYEE;
-- DISTINCT�� SELECT���� �� ���� �� �� �ִ�.
SELECT DISTINCT DEPT_CODE, JOB_CODE
FROM EMPLOYEE;

-------------WHRER��-----------
-- ��ȸ�� ���̺��� ���ǿ� �´� ���� ���� ���� ��� SOA
/*
SELECT �÷���
FROM ���̺��
WHRER ����
*/

-- *** �� ������ ***
-- = ����, > ũ��, < �۴�, >= ũ�ų� ����, <= �۰ų� ����
-- !=, ^=, <> ���� �ʴ�

-- EMPLOYEE ���̺��� �μ��ڵ尡 'D9'�� ������ �̸�, �μ��ڵ� ��ȸ
SELECT EMP_NAME, DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE = 'D9';

-- EMPLOYEE ���̺��� �޿��� 4000000 �̻��� ������ �̸�, �޿� ��ȸ
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY >= 4000000;

-- EMPLOYEE ���̺��� �μ��ڵ尡 D9�� �ƴ� ����� ���, �̸�, �μ��ڵ� ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE <> 'D9'; /* <> != ^= */

-- EMPLOYEE ���̺��� ��� ���ΰ� N�� ������ ��ȸ�ϰ�
-- �ٹ� ���θ� ���������� ǥ���� ���, �̸�, �����, �ٹ����� ��ȸ
SELECT EMP_ID, EMP_NAME, HIRE_DATE, '������' �ٹ�����
FROM EMPLOYEE
WHERE ENT_YN = 'N';

-- �ǽ� ���� --
-- 1. EMPLOYEE ���̺��� ������ 3000000 �̻��� ����� �̸�, ����, ����� ��ȸ
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY >= 3000000;

-- 2. EMPLOYEE ���̺��� SA_LEVEL�� S1�� ����� �̸�, ����, �����, ����ó ��ȸ
SELECT EMP_NAME, SALARY, HIRE_DATE, PHONE
FROM EMPLOYEE
WHERE SAL_LEVEL = 'S1';

-- 3. EMPLOYEE ���̺��� �Ǽ��ɾ�(�Ѽ��ɾ� - (���� * ����3%))�� 5õ���� �̻��� ����� �̸�, ����, �Ǽ��ɾ�, ����� ��ȸ
SELECT EMP_NAME, SALARY, SALARY*(1+BONUS)*12 - (SALARY*12*0.03) AS �Ǽ��ɾ�, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY*(1+BONUS)*12 - (SALARY*12*0.03) >= 50000000;

---------�� ������(AND/OR)-------
-- ������ ���� �ۼ� �� ���
-- �μ� �ڵ尡 'D6'�̰� �޿��� 2�鸸���� ���� �޴� ������ �̸�, �μ��ڵ�, �޿� ��ȸ
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6'
AND SALARY > 2000000;

-- �μ� �ڵ尡 'D6'�̰ų� �޿��� 2�鸸���� ���� �޴� ������ �̸�, �μ��ڵ�, �޿� ��ȸ
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6'
OR SALARY > 2000000;

-- EMPLOYEE ���̺��� �޿��� 350���� �̻� 600���� ���ϸ� �޴� ������ ���, �̸�, �޿�, �μ��ڵ�, �����ڵ带 ��ȸ
SELECT EMP_ID, EMP_NAME, SALARY, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE SALARY >= 3500000 AND SALARY <= 6000000;

------------- �ǽ� ���� -------------------
-- 1. EMPLOYEE ���̺��� ������ 4�� �̻��̰� JOB_CODE�� J2�� ����� ��ü ���� ��ȸ
SELECT *
FROM EMPLOYEE
WHERE SALARY >= 4000000 AND JOB_CODE = 'J2';

-- 2. EMPLOYEE ���̺��� DEPT_CODE�� D9 �̰ų� D5�� ��� �� ������� 00�� 1�� 1�Ϻ��� ���� ����� �̸�, �μ��ڵ�, ����� ��ȸ
--    ��¥ ǥ�� '00/01/01/
SELECT EMP_NAME, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE = 'D9' OR DEPT_CODE = 'D5')
AND HIRE_DATE < '00/01/01';
-- OR�� AND �����ڰ� ���� �� AND�� �켱�̴�

------- BETWEEN AND -------
-- �񱳴���÷��� BETWEEN ���Ѱ� AND ���Ѱ�
-- ���Ѱ� �̻� ���Ѱ� ����

--�޿��� 350���� �̻� 600���� ������ ��� �̸�, �޿� ��ȸ
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 6000000;

-- �ݴ�� �޿��� 350���� �̸�, �Ǵ� 600 �ʰ��ϴ� ������ ���, �̸�, �μ��ڵ�, �޿� ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE /*���⿡ NOT�� ����*/SALARY NOT BETWEEN 3500000 AND 6000000; /* ��Ʈ�� ���� ���ǿ� �ش����� �ʴ� �͵� ��ȸ */

------------�ǽ�����------------
-- 1. EMPLOYEE ���̺� ������� 90/01/01 ~ 01/01/01�� ����� ��ü ���� ��ȸ
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01';

-----------LIKE-------------
-- ���Ϸ��� �ϴ� ���� ������ Ư�� ������ ������Ű���� ��ȸ�� �� �񱳴�� LIKE '��������'
-- '%'�� '_'�� ���ϵ� ī��� ����� �� ����
-- ���� ���� : '����%' (���ڷ� �����ϴ� ��)
--           '%����%' (���ڰ� ���Ե� ��)
--           '%����'% (���ڷ� ������ ��)
-- ���� �� : '_' (�ѱ���)
--          '__' (�α���)

-- EMPLOYEE ���̺��� ���� ������ ���, �̸�, ����� ��ȸ
SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '��%';

-- EMPLOYEE ���̺��� '��'�� ���Ե� ������ �̸�, �ֹι�ȣ, �μ��ڵ� ��ȸ
SELECT EMP_NAME, EMP_NO, DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%��%';

-- EMPLOYEE ���̺��� ��ȭ��ȣ 4��° �ڸ��� 9�� �����ϴ� ����� ���, �̸�, ��ȭ��ȣ ��ȸ
SELECT EMP_ID, EMP_NAME, PHONE
FROM EMPLOYEE
WHERE PHONE LIKE '___9%';

-- �̸��� �� _�ձ��ڰ� 3�ڸ��� �̸��� �ּҸ� ���� ����� ���, �̸�, �̸��� �ּ� ��ȸ
SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '___\_%' ESCAPE '\'; /* ESCAPE ���ڴ� ���� ���Ƿ� ����ص� �ȴ�. */
--> ���ϵ� ī�� ���ڿ� ������ Ư�����ڰ� ������ ��쿡�� ó���� ��ȣ �տ� ���Ƿ� Ư�����ڸ� ����ϰ� �̽������� �ɼ� ��� 
