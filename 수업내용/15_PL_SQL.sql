/*
    <PL /SQL>
    PROCEDURAL LANGUAGE EXTENSION TO SQL
    : SQL�� ���� ������ ��� Ȯ��
    
    ����Ŭ ��ü�� ���ڵǾ� �ִ� ������ ���
    SQL ���� ������ ������ ����, ���� ó��(IF), �ݺ� ó��(LOOP, FOR, WHILE)
    ���� �����ؼ� SQL�� ���� ����
    
    * PL/SQL ����
    - �����(DECLARE SECTION) : DECLARE�� ����, ������ ����� �����ϴ� �κ�
    - �����(EXCUTABLE SECTION) : BEGIN���� ����, ���, �ݺ���, �Լ� ���� ������ ���
    - ����ó����(EXCEPTION SECTION) : EXCEPTION���� ����, ���ܻ�Ȳ �߻� �� �ذ��ϱ� ���� ���� ���
    -> �����κ�, �Լ��κ�, ���ܺκ� 3���� ���� ��
    
    * PL/SQL�� ����
    - PL/SQL���� BLOCK ������ �ټ��� SQL���� �ѹ��� ORACLE DB�� ���� ó���ϹǷ� ���� �ӵ� ���
    - PL/SQL�� ��� ��Ҵ� �ϳ� �Ǵ� �� �� �̻��� ������� �����Ͽ� ���ȭ ����
    - �ܼ�, ������ ������ ������ ���� �� ���̺��� ������ ������ �÷��� ���Ͽ� �������� ���� ���� ����
*/

-- * �����ϰ� ȭ�鿡 HELLO WORLD ���

BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO WORLD');
END;
/
-- DBMS_OUTPUT ��Ű���� ���ԵǾ� �ִ� PUT_LINE�̶�� ���ν����� �̿��Ͽ� ����ϴ� ���
-- END; ���� '/' ��ȣ�� PL/SQL ����� �����Ų�ٴ� �ǹ�

-- ��� �ȵǴ� ���� ?
-- ���ν��� ��� �� ����ϴ� ������ ȭ�鿡 �����ֵ��� �ϴ� ȯ�溯���� OFF���� ���������� �Ϸ��߽��ϴٸ� ��
-- (�⺻�� OFF)
SET SERVEROUTPUT ON;

---------------------------------------------------------------------------------------------------
-- 1. DECLARE �����

-- 1) Ÿ�� ���� ����
--    ������ ���� �� �ʱ�ȭ, ���� �� �����
--    [ǥ����] ������ �ڷ���[(ũ��)];
DECLARE --> ����� ������ �˸��� ����
    EMP_ID NUMBER;
    EMP_NAME VARCHAR2(30);
    PI CONSTANT NUMBER := 3.14;
BEGIN --> ����� ����
    EMP_ID := 888;
    EMP_NAME := '���峲';
    
    -- ���� ���(���ڿ� ���� ������ ||)
    DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('PI : ' || PI);
END;
/

---------------------------------------------------------------------------------------------------
-- 2) ���۷��� ������ ����� �ʱ�ȭ, ������ ���
-- [ǥ����] ������ ���̺��.�÷���%TYPE

DECLARE
    EMP_ID EMPLOYEE.EMP_ID%TYPE;
    --> ���� EMP_ID�� Ÿ���� EMPLOYEE ���̺��� EMP_ID �÷� Ÿ������ ����
    EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME
    INTO EMP_ID, EMP_NAME --> EMPLOYEE ���̺��� EMP_ID, EMP_NAME�� �� EMP_ID, EMP_NAME�� ����ְڴ�
    FROM EMPLOYEE
    WHERE EMP_ID = '&ID'; --> '&'��ȣ�� �ִ� ���ڿ��� ��ü ������ �Է�(���� �Է�) �϶�� �ǹ�
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || EMP_NAME);
END;
/
------------------------------------------------------------------------------------
-- 3) �� �࿡ ���� ROWTYPE ���� ����� �ʱ�ȭ
-- [ǥ����] ������ ���̺��%ROWTYPE;
DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = '&������̵�';
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || E.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('EMP_NO : ' || E.EMP_NO);
    DBMS_OUTPUT.PUT_LINE('SALARY : ' || E.SALARY);
END;
/
    
------------------------------------�ǽ� ���� --------------------------------------
-- 1. ���۷��� ������ EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY�� �����ϰ� �� �ڷ����� EMPLOYEE ���̺��� �� �÷� Ÿ������ ����
-- EMPLOYEE ���̺��� ���, �̸�, �����ڵ�, �μ��ڵ� �޿��� ��ȸ�ϰ� ������ 
-- ���۷��� ������ ��� ���� ���. ��, �Է¹��� �̸��� ��ġ�ϴ� ������ ������ ��ȸ
DECLARE
    EMP_ID EMPLOYEE.EMP_ID%TYPE;
    EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
    DEPT_CODE EMPLOYEE.DEPT_CODE%TYPE;
    JOB_CODE EMPLOYEE.JOB_CODE%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
    INTO EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
    FROM EMPLOYEE
    WHERE EMP_ID = '&������̵�';
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('DEPT_CODE : ' || DEPT_CODE);
    DBMS_OUTPUT.PUT_LINE('JOB_CODE : ' || JOB_CODE);
    DBMS_OUTPUT.PUT_LINE('SALARY : ' || SALARY);
END;
/

-- 2. ROWTYPE ������ DEPARTMENT ���̺��� Ÿ���� ������ �����ϰ� �Է¹��� �μ� �ڵ�� 
-- ��ġ�ϴ� ������ ���� ������ ROWTYPE ������ ��� �μ��ڵ�, �μ���, �����ڵ� ���
DECLARE
    D DEPARTMENT%ROWTYPE;
BEGIN
    SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID
    INTO D
    FROM DEPARTMENT
    WHERE DEPT_ID = '&�μ��ڵ�';
    
    DBMS_OUTPUT.PUT_LINE('DEPT_CODE : ' || D.DEPT_ID);
    DBMS_OUTPUT.PUT_LINE('DEPT_TITLE : ' || D.DEPT_TITLE);
    DBMS_OUTPUT.PUT_LINE('LOCATION_ID : ' || D.LOCATION_ID);
END;
/
    
-----------------------------------------------------------------------------------------
-- 2. BEGIN

-- **���ǹ�**
-- 1) IF~THEN~END IF(���� IF��)
-- EMP_ID�� �Է¹޾� �ش� ����� ���, �̸�, �޿�, ���ʽ����� ���
-- ��, ���ʽ��� ���� �ʴ� ����� ���ʽ��� ��� �� '���ʽ��� ���޹��� �ʴ� ����Դϴ�' ���
DECLARE
    EMP_ID EMPLOYEE.EMP_ID%TYPE;
    EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS, 0)
    INTO EMP_ID, EMP_NAME, SALARY, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('SALARY : ' || SALARY);
    
    IF(BONUS = 0) 
        THEN DBMS_OUTPUT.PUT_LINE('���ʽ��� ���޹��� �ʴ� ����Դϴ�');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('���ʽ��� : ' || BONUS * 100 || '%');
END;
/
    
-- 2) IF~THEN~ELSE~END IF(IF~ELSE��)
-- EMP_ID�� �Է¹޾� �ش� ����� ���, �̸�, �μ���, �Ҽ�(NATIONAL_CODE)�� ���
-- TEAM ������ ����� �Ҽ� 'ko'�� ����� '������' �ƴϸ� '�ؿ���'���� ���
DECLARE
    EMP_ID EMPLOYEE.EMP_ID%TYPE;
    EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
    DEPT_TITLE DEPARTMENT.DEPT_TITLE%TYPE;
    NATIONAL_CODE LOCATION.NATIONAL_CODE%TYPE;
    
    TEAM VARCHAR2(20);
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
    INTO EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
    FROM EMPLOYEE E, DEPARTMENT D, LOCATION L
    WHERE E.DEPT_CODE = D.DEPT_ID
    AND D.LOCATION_ID = L.LOCAL_CODE
    AND EMP_ID = '&EMP_ID';
    
    IF(NATIONAL_CODE = 'KO')
        THEN TEAM := '������';
    ELSE TEAM:= '�ؿ���';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('DEPT_TITLE : ' || DEPT_TITLE);
    DBMS_OUTPUT.PUT_LINE('NATIONAL_CODE : ' || NATIONAL_CODE);
    DBMS_OUTPUT.PUT_LINE('���� : ' || TEAM);
END;
/

----------------------------------------
--  3) IF~THEN~ELSIF~ELSE~END IF(IF~ELSE IF~ELSE��)

-- ������ �Է¹޾� SCORE ������ �����ϰ� 90�� �̻��� 'A', 80�� �̻��� 'B'
-- 70�� �̻��� 'C', 60�� �̻��� 'D', 60�� �̸��� 'F'�� ���� ó���Ͽ� GRADE ������ �����ϰ�
-- '����� ������ 90���̰�, ������ A�����Դϴ�.' ���·� ����Ͻÿ�
DECLARE
    SCORE INT;
    --> INT : ANSI Ÿ���� �ڷ���, ����Ŭ NUMBER(38)�� ���� Ÿ��
    GRADE VARCHAR2(2);
BEGIN
    SCORE := '&����';
    
    IF(SCORE >= 90) 
        THEN GRADE := 'A';
    ELSIF(SCORE >= 80)
        THEN GRADE := 'B';
    ELSIF(SCORE >= 70)
        THEN GRADE := 'C';
    ELSIF(SCORE >= 60)
        THEN GRADE := 'D';
    ELSE
        GRADE := 'F';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('����� ������ ' || SCORE || '���̰� ������' || GRADE || '�����Դϴ�.');
END;
/

---------------------------------------------------------------------------------------------------
-- 4) CASE~WHEN~THEN~END (SWITCH��)
-- ��� ��ȣ�� �Է��Ͽ� �ش� ����� ���, �̸�, �μ��� ���
DECLARE
    EMP EMPLOYEE%ROWTYPE;
    DNAME VARCHAR2(20);
BEGIN
    SELECT *
    INTO EMP
    FROM EMPLOYEE
    WHERE EMP_ID = '&���';
    
    DNAME := CASE EMP.DEPT_CODE
                WHEN 'D1' THEN '�λ������'
                WHEN 'D2' THEN 'ȸ�������'
                WHEN 'D3' THEN '�����ú�'
                WHEN 'D4' THEN '����������'
                WHEN 'D5' THEN '�ؿܿ���1��'
                WHEN 'D6' THEN '�ؿܿ���2��'
                WHEN 'D7' THEN '�ؿܿ���3��'
                WHEN 'D8' THEN '���������'
                WHEN 'D9' THEN '�ѹ���'
             END;
    DBMS_OUTPUT.PUT_LINE('��� �̸�   �μ���');
    DBMS_OUTPUT.PUT_LINE(EMP.EMP_ID || ' ' || EMP.EMP_NAME || ' ' || DNAME);
END;
/

---------------------------------------------- �ǽ� ����------------------------------------------------
-- 1. ���� �Է¹޾� ������ �����ϰ� 1~3���� '1�б�', 4~6���� '2�б�', 7~9���� '3�б�', 10~12���� '4�б�',
-- �� �ܿ� ���ڴ� '�߸��� ���� �Է�'���� ���� ó���Ͽ� ������ �����ϰ� '9���� 3�б��Դϴ�.' ���·� ���
DECLARE
    MONTH INT;
    QUARTER VARCHAR2(30);
BEGIN
    MONTH := '&��';
    
    IF(MONTH >= 1 AND MONTH <= 3)
        THEN QUARTER := '1�б�';
    ELSIF(MONTH >= 4 AND MONTH <= 6)
        THEN QUARTER := '2�б�';
    ELSIF(MONTH >= 7 AND MONTH <= 9)
        THEN QUARTER := '3�б�';
    ELSIF(MONTH >= 10 AND MONTH <= 12)
        THEN QUARTER := '4�б�';
    ELSE QUARTER := '�߸��� ���� �Է�';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(MONTH || '���� ' || QUARTER || '�Դϴ�.');
END;
/
    
-- 2. ��� ��ȣ�� �Է��Ͽ� �ش� ����� ���, �̸�, ���޸��� ����Ͻÿ�
-- EMPLOYEE ROWTYPE������ CASE~WHEN~THEN~END ���� �̿�
DECLARE
    EMP EMPLOYEE%ROWTYPE;
    JOBNAME VARCHAR2(30);
BEGIN
    SELECT *
    INTO EMP
    FROM EMPLOYEE
    WHERE EMP_ID = '&�����ȣ';
    
    JOBNAME := CASE EMP.JOB_CODE
                WHEN 'J1' THEN '��ǥ'
                WHEN 'J2' THEN '�λ���'
                WHEN 'J3' THEN '����'
                WHEN 'J4' THEN '����'
                WHEN 'J5' THEN '����'
                WHEN 'J6' THEN '�븮'
                WHEN 'J7' THEN '���'
               END;
    DBMS_OUTPUT.PUT_LINE('��� : ' || EMP.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('�̸� : ' || EMP.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('���޸� : ' || JOBNAME);
END;
/
    
    

-- 3.�Է¹��� EMP_ID�� �ش��ϴ� ����� ������ ���ؼ� ����, �����, ���� ���
-- ��, ���ʽ��� �ִ� ����� ���ʽ��� �����ؼ� ���
DECLARE
    E EMPLOYEE%ROWTYPE;
    INCOME INT;
BEGIN
    SELECT *
    INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = '&�����ȣ';
    
    INCOME := (E.SALARY + (E.SALARY * NVL(E.BONUS, 0))) * 12;
    
    DBMS_OUTPUT.PUT_LINE('����� : ' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('���� : ' || E.SALARY);
    DBMS_OUTPUT.PUT_LINE('���� : ' || INCOME);
END;
/

---------------------------------------------------------------------------------------------------------
-- ** �ݺ��� **

/*
    1) BASIC LOOP
       ���ο� ó������ �ۼ��ϰ� �������� LOOP�� ��� ������ ���
       
    [ǥ����]
    LOOP
        ó����
        ���ǹ�
    END LOOP
    
    -> ���ǹ� (2���� ǥ��)
    1. IF ���ǽ� THEN EXIT; END IF;
    2. EXIT WHEN ���ǽ�;
*/

DECLARE
    N NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
    
        N := N + 1;
    
--        IF N > 5 THEN EXIT; 
--        END IF;   -> ���ǽ� 1
        EXIT WHEN N > 5; --> ���ǽ�2
    END LOOP;
END;
/

--------------------------------------------------------------------------------------------
/*
    2) FOR LOOP
    
    [ǥ����]
    FOR �ε��� IN [REVERSE] �ʱⰪ..������
    LOOP
        ó����
    END LOOP
*/
-- 1~5���� ������� ���
BEGIN
    FOR N IN 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
    END LOOP;
END;
/

BEGIN
    FOR N IN REVERSE 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
    END LOOP;
END;
/

-- �ݺ����� �̿��� ������ ����
-- ���̺� ���� ��  ������� ������ ����
CREATE TABLE TEST1(
    NUM NUMBER(30),
    TODAY DATE
);

BEGIN
    FOR I IN 1..10
    LOOP
        INSERT INTO TEST1 VALUES(I, SYSDATE);
    END LOOP;
END;
/

SELECT * FROM TEST1;

-- ��ø LOOP
DECLARE
    RESULT INT;
BEGIN
    FOR I IN 2..9
    LOOP
        FOR J IN 1..9
        LOOP
            RESULT := I * J;
            DBMS_OUTPUT.PUT_LINE(I ||  ' * ' || J || ' = ' || I*J);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END LOOP;
END;
/

/*
    3) WHILE LOOP
    [ǥ����]
    WHILE ����
    LOOP
        ó����
    END LOOP;
*/

-- 1~5 ������� ���
DECLARE
    N NUMBER := 1;
BEGIN
    WHILE N <= 5
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N + 1;
    END LOOP;
END;
/

-- WHILE�� ����
DECLARE
    RESULT NUMBER;
    DAN NUMBER := 2;
    SU NUMBER;
BEGIN
    WHILE DAN <= 9
    LOOP
        SU := 1;
        WHILE SU <= 9
        LOOP
            RESULT := DAN * SU;
            DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || SU || ' = ' || RESULT);
            SU := SU + 1;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
        DAN := DAN + 1;
    END LOOP;
END;
/

--------------------------�ǽ�����--------------------
-- 1. FOR LOOP�� ������ ¦���ܸ� ���
BEGIN
    FOR I IN 2..9
    LOOP
        IF(MOD(I, 2) = 0)
            THEN FOR J IN 1..9
                 LOOP
                    DBMS_OUTPUT.PUT_LINE(I || ' * ' || J || ' = ' || I*J);
                 END LOOP;
                 DBMS_OUTPUT.PUT_LINE(' ');
        END IF;
    END LOOP;
END;
/

-- 2. WHILE LOOP�� ������ Ȧ�� �ܸ� ���
DECLARE
    I NUMBER := 2;
    J NUMBER;
BEGIN
    WHILE I <= 9
    LOOP
        J := 1;
        WHILE J <= 9
        LOOP
            IF (MOD(J,2) = 1) 
                THEN DBMS_OUTPUT.PUT_LINE(I || ' * ' || J || ' = ' || I*J);
            END IF;
            J := J + 1;
        END LOOP;
        
        I := I + 1;
        
    END LOOP;
END;
/

-----------------------------------------------------------------------------------------------------------
-- Ÿ�� ���� ����

-- ���̺� Ÿ�� ���� ���� �� �� ���� ���
/*
    - Ű�� �� ������ �̷���� �÷���(����Ŭ SQL�� ���̺��� �ƴ�)
    - �ϳ��� ���̺��� ������ �ִ� �� �÷��� �����͸� ����
    - ���̺� Ÿ�� ������ ũ�� ������ ������ �����Ͱ� ���ȿ� ���� �ڵ����� ������
    - BINARY_INDEX Ÿ��(��ȣ�� �ִ� ����)�� �ε��� ��ȣ�� ���ڰ� ������

    [ǥ����]
    TYPE ���̺�� IS TABLE OF ������Ÿ��
    INDEX BY BINARY INTEGER;
*/

-- EMPLOYEE ���̺�
DECLARE
    -- ���̺� Ÿ�� ����
    -- EMPLOYEE.EMP_ID�� Ÿ���� �����͸� ������ �� �ִ� ���̺� Ÿ�� ����
    -- EMP_ID_TABLE_TYPE ����
    TYPE EMP_ID_TABLE_TYPE IS TABLE OF EMPLOYEE.EMP_ID%TYPE
    INDEX BY BINARY_INTEGER; --> ��ġ Map<BINARY_INTEGER, VARCHAR2(3)> �� ����
                             --> Ȥ�� ������ ������ �迭
    -- EMPLOYEE,EMP_NAME�� Ÿ���� �����͸� ������ �� �ִ� ���̺� Ÿ�� ����
    TYPE EMP_NAME_TABLE_TYPE IS TABLE OF EMPLOYEE.EMP_NAME%TYPE
    INDEX BY BINARY_INTEGER;
    
    -- ���̺� Ÿ��(EMP_ID_TABLE_TYPE) ���� EMP_ID_TABLE ����
    EMP_ID_TABLE EMP_ID_TABLE_TYPE;
    
    -- ���̺� Ÿ��(EMP_NAME_TABLE_TYPE) ���� EMP_NAME_TABLE ����
    EMP_NAME_TABLE EMP_NAME_TABLE_TYPE;
    
    -- BINARY_INTEGER Ÿ�� ���� I ����, 0 �ʱ�ȭ
    I BINARY_INTEGER := 0;
BEGIN
    FOR K IN (SELECT EMP_ID, EMP_NAME FROM EMPLOYEE)
    -- K�� �ڵ����� ����Ǵ� BINARY_INTEGER�� ������ 1���� 1�� ������
    LOOP
        I := I + 1;
        
        -- K�� ���� : SELECT���� ����� �� K��° �ε��� ���� ����
        -- EMP_ID_TABLE, EMP_NAME_TABLE�� I��° �ε����� SELECT�� ��ȸ ����� K��° �ε����� EMP_ID, EMP_NAME ����
        EMP_ID_TABLE(I) := K.EMP_ID;
        EMP_NAME_TABLE(I) := K.EMP_NAME;
    END LOOP;
    
    -- EMP_ID_TABLE, EMP_NAME_TABLE�� ����� ��� �� ���
    FOR J IN 1..I
    LOOP
        DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP_ID_TABLE(J) || ', EMP_NAME : ' ||
                                EMP_NAME_TABLE(J));
    END LOOP;
END;
/

-- ���ڵ� Ÿ���� ���� ���� �� �� ���� ���
/*
    - �⺻ ������ Ÿ�԰� �ٸ� ������ ������ ���� PL/SQL�� �����ϴ� ������ Ÿ��
    - ���� �ٸ� ������ �����͸� �� �ٷ� ������ ������ �����Ͱ� �� ��(ROW)�ۿ� ���� ���̺��̶�� �����ϸ� ����.
    
    [ǥ����]
    TYPE ���ڵ�� IS RECORED(
        �ʵ�� �ʵ�Ÿ�� [[NOT NULL] := DEFAULT��],
        �ʵ�� �ʵ�Ÿ�� [[NOT NULL] := DEFAULT��],
        ...
    );
    ���ڵ庯���� ���ڵ��;
*/
DECLARE
    TYPE EMP_RECORD_TYPE IS RECORD(
        EMP_ID EMPLOYEE.EMP_ID%TYPE,
        EMP_NAME EMPLOYEE.EMP_NAME%TYPE,
        DEPT_TITLE DEPARTMENT.DEPT_TITLE%TYPE,
        JOB_NAME JOB.JOB_NAME%TYPE
    );
    
    EMP_RECORD EMP_RECORD_TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
    INTO EMP_RECORD
    FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
    LEFT JOIN JOB USING(JOB_CODE)
    WHERE EMP_NAME = '&EMP_NAME';
    
    DBMS_OUTPUT.PUT_LINE('��� : ' || EMP_RECORD.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('�̸� : ' || EMP_RECORD.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('�μ� : ' || EMP_RECORD.DEPT_TITLE);
    DBMS_OUTPUT.PUT_LINE('���� : ' || EMP_RECORD.JOB_NAME);
END;
/

---------------------------------------------------------------------------------------------------
-- 3. ����ó����
/*
    ����(EXCEPTION) : ��Ÿ�� �� ���� ó���� �߻��ϴ� ����
    
    [ǥ����]
    EXCEPTION
        WHEN ���ܸ�1 THEN ����ó������1
        WHEN ���ܸ�2 THEN ����ó������2
        ...
        WHEN OTHERS THEN ����ó������N;
*/

/*
    1) �ý��� ����(�̸� ���ǵǾ� �ִ� ����)
       ����Ŭ ���ο� �̸� ���ǵǾ� �ִ� ����(PREDEFINED ORACLE SERVER, �� 20��)
       ���� ������ �ʿ� ���� �߻� �� �������� �ڵ� Ʈ����
       
       ��ǥ���� �ý��� ����
       - NO_DATA_FOUND : SELECT���� �ƹ��� ������ ���� ��ȯ���� ���� ��
       - TOO_MANY ROWS : �ϳ��� �����ؾ� �ϴ� SELECT���� �ϳ� �̻��� ���� ��ȯ�� ��
       - INVALID_CURSOR : �߸��� Ŀ�� ����
       - ZERO_DIVIDE : 0���� ������
       - DUP_VAL_ON_INDEX : UNIQUE ������ ���� �÷��� �ߺ��Ǵ� �����Ͱ� INSERT�� ��
       
       OTHERS : ��� ����ó��
*/

-- ���ڸ� 0���� ���� ��� ����ó��
DECLARE
    NUM NUMBER := 0;
BEGIN
    NUM := 10 / 0;
    DBMS_OUTPUT.PUT_LINE('SUCCESS!');

EXCEPTION
    --WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('ZERO_DIVIDE EXCEPTION �߻�');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('EXCEPTION �߻�'); --> ��� ����ó��
END;
/

-- UNIQUE ���� ���� ���� ��
BEGIN
    UPDATE EMPLOYEE
    SET EMP_ID = '&���'
    WHERE EMP_ID = 201;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('�̹� �����ϴ� ����Դϴ�.');
END;
/

/*
    2) ����� ���� ����ó��(�������� �ʴ� ����ó��)
       �̸� ���ǵ� ���ܸ� ������ ��� ����
       ����ο� ���� �ؾ��ϰ�, ���� �߻� �� �ڵ� Ʈ����
       
       * ����� ���� ����ó�� ����
       - STEP 1 : ���� �̸��� ����(DECLARE��)
       - STEP 2 : PRAGMA EXCEPTION_INIT �������� ������ �̸��� ����Ŭ ������ȣ ����(DECLARE������)
                  PRAGMA : �����Ϸ��� ����Ǳ� �� ��ó���� ������ �ϴ� Ű����
                  ������ȣ : ���۸�...
       - STEP 3 : ���ܰ� �߻��� ��� �ش� ���ܸ� ����(EXCEPTION��)
*/
-- ���� EMAIL�� NOT NULL ���� ������ ��� NULL���� ����
-- �̸����� ������ �� ���� �Է� ���ϰ� �Ǹ� ���� �߻��ϰ� �����
DECLARE
    NEWEMAIL EMPLOYEE.EMAIL%TYPE;
    DUP_EMAIL EXCEPTION; --> STEP 1
    PRAGMA EXCEPTION_INIT(DUP_EMAIL, -00001); --> STEP 2
BEGIN
    NEWEMAIL := '&�̸���';
    
    IF NEWEMAIL IS NULL
        THEN RAISE DUP_EMAIL;
    ELSE
        UPDATE EMPLOYEE
        SET EMAIL = NEWEMAIL
        WHERE EMP_ID = 201;
    END IF;
EXCEPTION
    WHEN DUP_EMAIL THEN DBMS_OUTPUT.PUT_LINE('�ݵ�� ���� �Է����ּ���');
    --> STEP 3
END;
/

-------------------------�ǽ� ����-------------------------------------------
-- 1. EMPLOYEE ���̺��� �̸����� �˻��Ͽ� �̸��� �μ���� �������� RECORD TYPE
-- ���� �ϳ��� ��� ���. ��, �̸��� �ش��ϴ� ����� ������ ����ó���ο��� 
-- '�Է��Ͻ� �̸��� �ش��ϴ� ����� �����ϴ�' ��� ���
DECLARE
    TYPE EMP_RECORD IS RECORD (
        EMP_NAME EMPLOYEE.EMP_NAME%TYPE,
        DEPT_TITLE DEPARTMENT.DEPT_TITLE%TYPE,
        LOCAL_NAME LOCATION.LOCAL_NAME%TYPE
    );
    EMP EMP_RECORD;
BEGIN
    SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME
    INTO EMP
    FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
    LEFT JOIN LOCATION ON(LOCAL_CODE = LOCATION_ID)
    WHERE EMP_NAME = '&�����';
    
    DBMS_OUTPUT.PUT_LINE('����� : ' || EMP.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('�μ��� : ' || EMP.DEPT_TITLE);
    DBMS_OUTPUT.PUT_LINE('������ : ' || EMP.LOCAL_NAME);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('�Է��Ͻ� �̸��� �ش��ϴ� ����� �����ϴ�.');
END;
/

-- 2. ���̸� �Է¹ް� �Է¹��� ���̰� 20�� �̻��̸� ���� �����մϴٸ� ����ϰ�
-- 20 �̸��̸� UNDER_TWENTY��� ���ܸ� �߻����� 20�� �̸��� ���� �Ұ��մϴٸ� ���
DECLARE
    AGE NUMBER;
    UNDER_TWENTY EXCEPTION;
    PRAGMA EXCEPTION_INIT(UNDER_TWENTY, -0000001);
BEGIN
    AGE := '&����';
    
    IF AGE >= 20
        THEN DBMS_OUTPUT.PUT_LINE('���� �����մϴ�');
    ELSE 
        RAISE UNDER_TWENTY;
    END IF;
EXCEPTION
    WHEN UNDER_TWENTY THEN DBMS_OUTPUT.PUT_LINE('20�� �̸��� ���� �Ұ��մϴ�');
END;
/

set serveroutput on;