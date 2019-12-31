/*
    < PROCEDURE > 
    
    PL/SQL���� �����ϴ� ��ü
    �ʿ��� ������ ������ ������ �ٽ� �Է��� �ʿ� ���� �����ϰ� ȣ���ؼ� ������ ����� ���� �� ����.
    Ư�� ������ ó���ϱ⸸ �ϰ� ��� ���� ��ȯ������ ����.
    �ڹ��� �޼ҵ�� ������ ����
*/

---------------------------------------------------------------------------------------------------
-- ���ν��� ���� ���

/*
    [ǥ����]
    CREATE OR REPLACE PROCEDURE ���ν�����
        (�Ű�������1 [IN|OUT|IN OUT] ������Ÿ��[:= DEFAULT��],
         �Ű�������2 [IN|OUT|IN OUT] ������Ÿ��[:= DEFAULT��],
         ... )
    IS [AS]
        �����
    BEGIN
        �����
    [EXCEPTION
        ����ó����]
    END [���ν�����];
    /
    
    2. ���ν��� ���� ���
    [ǥ����]
    EXECUTE(OR EXEC) ���ν�����;
*/

-- �׽�Ʈ�� ���̺� ����
CREATE TABLE EMP_DUP
AS SELECT * FROM EMPLOYEE;

-- ���ν��� ����
-- : ȣ�� �� EMP_DUP ���̺��� ��� �����ϴ� ���ν���
SELECT * FROM EMP_DUP;

CREATE OR REPLACE PROCEDURE DEL_ALL_EMP
IS
BEGIN
    DELETE FROM EMP_DUP;
    COMMIT;
END;
/

-- DEL_ALL_EMP ���ν��� ȣ��
SELECT * FROM EMP_DUP;

EXECUTE DEL_ALL_EMP;

SELECT * FROM EMP_DUP;

-- ���ν����� �����ϴ� ������ ��ųʸ�
-- USER_SOURCE
--> ���ν��� �ۼ� ������ ���κ��� ���еǾ� ����Ǿ� ����.
SELECT * FROM USER_SOURCE;

---------------------------------------------------------------------------------------------------
-- 1) �Ű����� �ִ� ���ν���
--    ���ν��� ���� �� �Ű������� ���ڰ� ������ ��� ��

-- �Ű����� �ִ� ���ν��� ����
CREATE OR REPLACE PROCEDURE DEL_EMP_ID
    (P_EMP_ID EMPLOYEE.EMP_ID%TYPE)
IS
BEGIN
    DELETE FROM EMPLOYEE
    WHERE EMP_ID = P_EMP_ID;
END;
/

-- ���ν��� ����(��, �Ű������� ���ڰ� �����������)
-- EXECUTE DEL_EMP_ID; --> ���� �߻�
EXEC DEL_EMP_ID('201');

SELECT * FROM EMPLOYEE;

-- ����ڰ� �Է��� ���� ���� ����
EXEC DEL_EMP_ID('&�����ȣ');

ROLLBACK;

---------------------------------------------------------------------------------------------------
-- 2) IN/OUT �Ű����� �ִ� ���ν���
-- IN �Ű����� : ���ν��� ���ο��� ���� ����
-- OUT �Ű����� : ���ν��� ȣ���(�ܺ�)���� ���� ����

-- IN/OUT �Ű����� �ִ� ���ν��� ����
CREATE OR REPLACE PROCEDURE SELECT_EMP_ID
    (P_EMP_ID IN EMPLOYEE.EMP_ID%TYPE,
     P_EMP_NAME OUT EMPLOYEE.EMP_NAME%TYPE,
     P_SALARY OUT EMPLOYEE.SALARY%TYPE,
     P_BONUS OUT EMPLOYEE.BONUS%TYPE)
IS
BEGIN
    SELECT EMP_NAME, SALARY, NVL(BONUS, 0)
    INTO P_EMP_NAME, P_SALARY, P_BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = P_EMP_ID;
END;
/

-- * ���ε� ����(VARIABLE OR VAR)
-- SQL ������ ������ �� SQL�� ��� ���� ������ �� �ִ� ��� ������ �ϴ� ����
-- �� ���ν��� ���� �� ��ȸ ����� ����� ���ε� ������ �����ؾ� �ȴ�.
VAR VAR_EMP_NAME VARCHAR2(30);
VAR VAR_SALARY NUMBER;
VAR VAR_BONUS NUMBER;

-- * ���ε� ������ ':������' ���·� ���� ����
EXEC SELECT_EMP_ID('&���', :VAR_EMP_NAME, :VAR_SALARY, :VAR_BONUS);
--> ������ �� �Ǿ����� ��ȸ�� ����� ����� ������ ������ �� �� ����.


SELECT VAR_EMP_NAME, VAR_SALARY, VAR_BONUS FROM DUAL; --> �̷������� ����

-- * PRINT
-- �ش� ������ ������ ������ִ� ��ɾ�
PRINT VAR_EMP_NAME;
PRINT VAR_SALARY;
PRINT VAR_BONUS;

-- * SET AUTOPRINT ON --> �⺻�� OFF ����
-- �������� PL/SQL ������ ���Ǵ� ���ε� ������ ���� �ڵ����� ���
-- ������ DBMS_OUTPUT.PUT_LINE() �ʿ���� ���ν��� ȣ�⹮ ���� �� �ٷ� RPINT
SET AUTOPRINT ON;

EXEC SELECT_EMP_ID('&���', :VAR_EMP_NAME, :VAR_SALARY, :VAR_BONUS);

-- [�ǽ�����]
-- ����� IN �Ű������� �ϰ� �����, �μ���, ���޸��� OUT �Ű������� �ϴ� SELECT_EMP��� �̸��� ���ν���
-- �� ����� ���ε庯�� ����� ���� �� ���Ȯ��
CREATE OR REPLACE PROCEDURE SELECT_EMP
    (P_EMP_ID IN EMPLOYEE.EMP_ID%TYPE,
     P_EMP_NAME OUT EMPLOYEE.EMP_NAME%TYPE,
     P_DEPT_TITLE OUT DEPARTMENT.DEPT_TITLE%TYPE,
     P_JOB_NAME OUT JOB.JOB_NAME%TYPE)
IS
BEGIN
    SELECT EMP_NAME, DEPT_TITLE, JOB_NAME
    INTO P_EMP_NAME, P_DEPT_TITLE, P_JOB_NAME
    FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
    LEFT JOIN JOB USING(JOB_CODE)
    WHERE EMP_ID = P_EMP_ID; 
END;
/

VAR V_EMP_NAME VARCHAR2(30);
VAR V_DEPT_TITLE VARCHAR2(30);
VAR V_JOB_NAME VARCHAR2(30);

EXEC SELECT_EMP('&�����ȣ', :V_EMP_NAME, :V_DEPT_TITLE, :V_JOB_NAME);

---------------------------------------------------------------------------------------------------
/*
    < FUNCTION >
    ���ν����� ��� �뵵�� ���� ��������� ���ν����� �ٸ��� OUT �Ű������� ������� �ʾƵ� ���� ����� �ǵ���
    ���� �� �ִ�. (RETURN)
    
    [ǥ����]
    CREATE OR REPLACE FUNCTION �Լ���
        (�Ű�����1 Ÿ��,
         �Ű�����2 Ÿ��,
         ... )
    RETURN ������ Ÿ��
    IS[AS]
        �����
    BEGIN
        �����
        RETURN ��ȯ��; --> ���ν����� �ٸ��� RETURN ������ �߰���
    [EXCEPTION
        ����ó����]
    END [�Լ���];
*/

-- �Լ� ����
-- : ����� �Է¹޾� �ش� ����� ������ ����ؼ� ����
CREATE OR REPLACE FUNCTION BONUS_CALC
    (V_EMP_ID EMPLOYEE.EMP_ID%TYPE)
RETURN NUMBER
IS
    V_SAL EMPLOYEE.SALARY%TYPE;
    V_BONUS EMPLOYEE.BONUS%TYPE;
    CALC_SAL NUMBER;
BEGIN
    SELECT SALARY, NVL(BONUS, 0)
    INTO V_SAL, V_BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = V_EMP_ID;
    
    CALC_SAL := (V_SAL + (V_SAL * V_BONUS)) * 12;
    
    RETURN CALC_SAL;
END;
/

-- �Լ� ����� ��ȯ�޾� ������ ���ε� ���� ����
VARIABLE VAR_CALC NUMBER;

EXEC :VAR_CALC := BONUS_CALC('&���'); --> ��ȯ���� �ֱ� ������ �޾���� �Ѵ�.

-- * �Լ��� RETURN ���� �ֱ� ������ SELECT �������� ��� ����(EXEC ���� ����)
SELECT EMP_ID, EMP_NAME, BONUS_CALC(EMP_ID)
FROM EMPLOYEE
WHERE BONUS_CALC(EMP_ID) > 30000000;

---------------------------------------------------------------------------------------------------
/*
    < CURSOR >
    SELECT�� ó�� ���(ó�� ����� ���� ��)�� ��� �ִ� �޸� ������ ���� ������(����)
    Ŀ�� ���� ���� ROW�� ��Ÿ�� ó�� ����� ���������� ���� ����
    --> SELECT ����� �������� ��� INTO���� �̿��� ������ ���� ����������, 
               ����� �������� ��� CURSOR�� �̿��ϸ� ��(ROW)������ ó�� ����
    
    * Ŀ�� ��� ��� (�� 4�ܰ�)
    1) CURSOR --> Ŀ�� ����
    2) OPEN --> Ŀ�� ����
    3) FETCH --> Ŀ������ ������ ����
    4) CLOSE --> Ŀ�� �ݱ�
    
    * Ŀ�� ����
    ������/����� Ŀ��
    
    1. ������ Ŀ��(IMPLICIT CURSOR)
    ����Ŭ���� �ڵ����� �����Ǿ� ����ϴ� Ŀ��
    PL/SQL ��Ͽ��� �����ϴ� SQL�� ����ø��� �ڵ����� ������� ����
    ����ڴ� ���� ������ �� �� ������, Ŀ�� �Ӽ��� Ȱ���Ͽ� Ŀ���� ������ ��� �� �� �ִ�.
    
    * Ŀ�� �Ӽ�
    (������ Ŀ�� �Ӽ� ���� ������ Ŀ���� = SQL)
    - Ŀ����%ROWCOUNT : SQL ó�� ����� ���� ROW ��
    -> 0 ����, FETCH�ø��� 1�� ����
    - Ŀ����%FOUND : Ŀ�� ������ ROW ���� �� �� �̻��� ��� TRUE, �ƴ� FALSE
    - Ŀ����%NOTFOUNT : Ŀ�� ������ ROW ���� ������ TRUE, �ƴ� FALSE
    - Ŀ����%ISOPEN : Ŀ���� OPEN ������ ��� TRUE, �ƴ� FALSE(������ Ŀ���� �׻� FALSE)    
*/

SET SERVEROUTPUT ON;

-- ������ Ŀ�� Ȯ��
-- BONUS�� NULL�� ����� BONUS�� 0���� ����
COMMIT;

BEGIN
    UPDATE EMPLOYEE
    SET BONUS = 0
    WHERE BONUS IS NULL;
    
    -- (������ Ŀ�� �Ӽ� ���� ������ Ŀ���� = SQL)
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || '�� ������');
END;
/
ROLLBACK;

---------------------------------------------------------------------------------------------------
/*
    2. ����� Ŀ��(EXPLICIT CURSOR)
    ����ڰ� ���� �����ؼ� ����� �� �ִ� �̸� �ִ� Ŀ��
    
    [ǥ����]
    CURSOR Ŀ���� IS [SELECT��]
    OPEN Ŀ����;
    FETCH Ŀ���� INTO ����;
    CLOSE Ŀ����;
    -- Ŀ�� ���� -> ���� -> ���� -> �ݱ�. ����
*/

-- �޿��� 3000000 �̻��� ����� ���, �̸�, �޿� ���
DECLARE
    V_EMP_ID EMPLOYEE.EMP_ID%TYPE;
    V_EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
    V_SALARY EMPLOYEE.SALARY%TYPE;
    
    CURSOR C1 IS --> Ŀ�� ���� : ���������� ����� Ŀ�� ������ ��� ��
        SELECT EMP_ID, EMP_NAME, SALARY
        FROM EMPLOYEE
        WHERE SALARY >= 3000000;
BEGIN
    OPEN C1; --> Ŀ�� ����
    
    LOOP
        FETCH C1 INTO V_EMP_ID, V_EMP_NAME, V_SALARY;
        --> Ŀ�� ��ġ : ���� ������ ������� �� ROW�� �����͸� ������
        EXIT WHEN C1%NOTFOUND; --> ���ѷ��� ���� ����
                 --> %NOTFOUND : Ŀ���� ������� ������ TRUE
        DBMS_OUTPUT.PUT_LINE(V_EMP_ID || ' ' || V_EMP_NAME || ' ' || V_SALARY);
    END LOOP;
    
    CLOSE C1; --> Ŀ�� ����
END;
/

-- ���ν��� ���� �� Ŀ�� ���
CREATE OR REPLACE PROCEDURE CURSOR_DEPT
IS
    V_DEPT DEPARTMENT%ROWTYPE;
    
    CURSOR C1 IS 
        SELECT * FROM DEPARTMENT;
BEGIN
    OPEN C1;
    LOOP
        FETCH C1 INTO V_DEPT.DEPT_ID, V_DEPT.DEPT_TITLE, V_DEPT.LOCATION_ID;
        EXIT WHEN C1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('�μ� �ڵ� : ' || V_DEPT.DEPT_ID ||
                                ', �μ��� : ' || V_DEPT.DEPT_TITLE ||
                                ', ���� : ' || V_DEPT.LOCATION_ID);
    END LOOP;
    
    CLOSE C1;
END;
/

EXEC CURSOR_DEPT;

-- FOR IN LOOP �̿��� Ŀ�� Ȱ��
-- �ݺ��� �ڵ����� CURSOR OPEN
-- FETCH�� �ڵ����� ����
-- LOOP ���� �� �ڵ� CLOSE
CREATE OR REPLACE PROCEDURE CURSOR_DEPT
IS
    V_DEPT DEPARTMENT%ROWTYPE;
    
    CURSOR C1
    IS SELECT * FROM DEPARTMENT;
BEGIN
    FOR V_DEPT IN C1 LOOP
        DBMS_OUTPUT.PUT_LINE('�μ��ڵ� : ' || V_DEPT.DEPT_ID || ', �μ��� : ' || V_DEPT.DEPT_TITLE || 
                                ', ���� : ' || V_DEPT.LOCATION_ID);
    END LOOP;
END;
/

EXEC CURSOR_DEPT;

-- CURSOR�� ������ �������� �ʰ� �ٷ� SELECT���� �ۼ��ص� ����
CREATE OR REPLACE PROCEDURE CURSOR_DEPT
IS
    V_DEPT DEPARTMENT%ROWTYPE;
BEGIN
    FOR V_DEPT IN (SELECT * FROM DEPARTMENT) LOOP
        DBMS_OUTPUT.PUT_LINE('�μ��ڵ� : ' || V_DEPT.DEPT_ID || ', �μ��� : ' || V_DEPT.DEPT_TITLE || 
                                ', ���� : ' || V_DEPT.LOCATION_ID);
    END LOOP;
END;
/

EXEC CURSOR_DEPT;

---------------------------------------------------------------------------------------------------
/* 
    < PACKAGE >
    ���ν����� �Լ��� ȿ�������� �����ϱ� ���� ���� ����
    ��Ű���� �����, ����(BODY)�� ������
    
    * PACKAGE ����� 
    - ����, ���, ����, TYPE����, Ŀ��, ���ν���, �Լ� ��� ����
    - ��Ű�� ����θ� �־ ������ �� ��� ����
    - ��, ���ν���, �Լ�, Ŀ�� ��� �� ��Ű�� BODY�� �� �ۼ��ؾ� �Ѵ�.
*/

-- 1) ��Ű�� ����ο� ����, ��� ���� �� ��� ���
CREATE OR REPLACE PACKAGE TEST_PACK
IS
     TEST1 VARCHAR2(20); --> ����
     TEST2 CONSTANT VARCHAR2(20) := '���!!'; --> ���
END TEST_PACK;
/

-- ��Ű���� ����� ����, ��� ���
BEGIN
    TEST_PACK.TEST1 := '����!!';
    
    DBMS_OUTPUT.PUT_LINE('���� : ' || TEST_PACK.TEST1);
    DBMS_OUTPUT.PUT_LINE('��� : ' || TEST_PACK.TEST2);
END;
/

-- 2) ��Ű�� ����ο� ���ν���, �Լ�, Ŀ�� ���� �� ��� ���
CREATE OR REPLACE PACKAGE KH_PACK
IS 
    PROCEDURE SHOW_EMP;
END;
/

EXEC KH_PACK.SHOW_EMP; --> ���� �߻�. ��Ű�� BODY �κ��� �����ؾ� �Ѵ�.

-- ��Ű�� ����(BODY ����)
CREATE OR REPLACE PACKAGE BODY KH_PACK
IS
    PROCEDURE SHOW_EMP
    IS
        V_EMP EMPLOYEE%ROWTYPE;
        CURSOR C1
        IS SELECT EMP_ID, EMP_NAME, EMP_NO
            FROM EMPLOYEE;
    BEGIN
        FOR V_EMP IN C1 LOOP
            DBMS_OUTPUT.PUT_LINE('��� : ' || V_EMP.EMP_ID || 
                                    ', �̸� : ' || V_EMP.EMP_NAME || 
                                    ', �ֹι�ȣ : ' || V_EMP.EMP_NO);
        END LOOP;                                    
    END;
END;
/

EXEC KH_PACK.SHOW_EMP;
