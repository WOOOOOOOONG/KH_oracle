/*
    DCL(DATA CONTROL LANGUAGE) : �����͸� �����ϴ� ���
    : �����ͺ��̽�, �����ͺ��̽� ��ü�� ���� ���� ������ ����(�ο�, ȸ��)
      �ϴ� ���.
    GRANT(�ο�), REVOKE(ȸ��)
    
    �ý��� ���� : ����ڿ��� �ý��� ������ �ο��ϴ� ����
                (��ü ���� ���� ��)    
    ��ü ���� : Ư�� ��ü�� ������ �� �ִ� ����
*/

/*
    �ý��� ���� ����
    
    - CREATE SESSION : �����ͺ��̽� ���� ����
    - CREATE TABLE : ���̺� ���� ����
    - CREATE VIEW : �� ���� ����
    - CREATE SEQUENCE : ������ ���� ����
    - CREATE PROCEDURE : ���ν��� ���� ����
    - CREATE USER : ���� ���� ����
    - DROP USER : ���� ���� ����
    - DROP ANY TABLE : ���� ���̺� ���� ����
    ���...
    [ǥ���]
    GRANT ����1, ����2, ... TO ������̸�;
*/

-- 1. SAMPLE ���� ����
CREATE USER SAMPLE IDENTIFIED BY SAMPLE;

-- 2. �ش� ������ �����ϱ� ���ؼ� CREATE SESSION ���� �ο�
GRANT CREATE SESSION TO SAMPLE;

-- 3_1. �ش� �������� ���̺��� ������ �� �ִ� CREATE TABLE ���� �ο�
GRANT CREATE TABLE TO SAMPLE;

-- 3_2. ���̺� �����̽� �Ҵ緮 �ο�
--      ���̺� �����̽� : ���̺�, ��, �ε��� ��� DB ��ü���� ����Ǵ� ����
ALTER USER SAMPLE QUOTA 2M ON SYSTEM;
----------------------------------------------------------
/*
    ��ü ����
    Ư�� ��ü���� ������ �� �ִ� ����
    
    ���� ����        ���� ��ü
    SELECT          TABLE, VIEW, SEQUENCE
    INSERT          TABLE, VIEW
    UPDATE          TABLE, VIEW
    DELETE          TABLE, VIEW
    ALTER           TABLE, SEQUENCE
    REFERENCES      TABLE
    ���
    
    [ǥ���]
    GRANT ��������[(�÷���)] | ALL
    ON ��ü��|ROLE�̸�|PUBLIC
    TO ������̸�

*/
SELECT *
FROM DBA_SYS_PRIVS
--WHERE GRANTEE = 'CONNECT';
WHERE GRANTEE = 'RESOURCE';

-- 4. SELECT ���� �ο�
GRANT SELECT
ON kh.EMPLOYEE
TO SAMPLE;

-- 5. INSERT ���� �ο�
GRANT INSERT
ON kh.DEPARTMENT
TO SAMPLE;

-- 6. ���� ȸ��
REVOKE SELECT
ON kh.EMPLOYEE
FROM SAMPLE;








