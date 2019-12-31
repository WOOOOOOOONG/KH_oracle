-- JOIN 
-- �ϳ� �̻��� ���̺��� �����͸� ��ȸ�ϱ� ���� ���
-- ���� ����� �ϳ��� Result Set���� ����

/*
    ������ �����ͺ��̽����� SQL�� �̿��� ���̺� '����'�� �δ� ���
    
    ������ �����ͺ��̽��� �ּ����� �����͸� ���̺� ��� �־�
    ���ϴ� ������ ���̺��� ��ȸ�Ϸ��� �� �� �̻��� ���̺��� �����͸� �о�;� �Ǵ� ��찡 ����
    �� ��, ������ �����͸� �������� ���� �ƴ� ���̺� ������� ���谡 �ξ��� �����͸� �����ؾ� ��
    --> JOIN�� ���� �̸� ����
*/
---------------------------------------------------------------------------------------
-- ������ȣ, ������, �μ��ڵ�, �μ����� ��ȸ�ϰ��� �� ��
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;
-- ������ȣ, ������, �μ��ڵ�� EMPLOYEE ���̺��� ��ȸ ����

-- �μ����� DEPARTMENT ���̺��� ��ȸ ����
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;

-- 1. ���� ����(INNER JOIN) (== � ����(EQUAL JOIN))
--> ����Ǵ� �÷��� ���� ��ġ�ϴ� ��鸸 ���ε�(��ġ�ϴ� ���� ���� ���� ���ο��� ����)

-- �ۼ� ����� ũ�� ����Ŭ ������ ANSI �������� ������, ANSI���� ON�� ���� ����� USING�� ���� ������� ����

-- ����Ŭ ���� ����
-- FROM���� ','�� �����Ͽ� ��ġ�� �� ���̺���� ����ϰ�
-- WHERE���� ��ġ�⿡ ����� �÷����� ����Ѵ�.

-- 1) ���ῡ ����� �� �÷����� �ٸ� ���
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;

-- 2) ���ῡ ����� �� �÷����� ���� ���
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- 3) ��Ī ���
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;

-------------------------------------------------------------------------------------------
-- ANSI ǥ�� ����
-- ANSI�� �̱� ���� ǥ�� ��ȸ�� ����. �̱��� ���ǥ���� �����ϴ� �ΰ���ü�� ����ǥ��ȭ�ⱸ ISO�� ���ԵǾ� ����.
-- ANSI���� ������ ǥ���� ANSI��� �ϰ� ���⼭ ������ ǥ�� �� ���� ������ ���� �ƽ�Ű�ڵ���.

-- 1) ���ῡ ����� �÷����� ���� ��� : USING(�÷���)
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);

-- 2) ���ῡ ����� �÷����� �ٸ� ��� : ON(�÷���=�÷���)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- �μ� ���̺��� �μ��� �������� ��ȸ�ϼ���
-- ����Ŭ ����
SELECT DEPT_TITLE, LOCAL_NAME
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE;
-- ANSI ����
SELECT DEPT_TITLE, LOCAL_NAME
FROM DEPARTMENT
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE);
---------------------------------------------------------------------------------------------

-- 2. �ܺ� ����(OUTER JOIN)
-- �� ���̺��� �����ϴ� �÷� ���� ��ġ���� �ʴ� �൵ ���ο� ������ ��Ŵ
--> *** �ݵ�� OUTER JOIN���� ����ؾ� �� ***

-- OUTER JOIN�� ���� INNER JOIN ������
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 1) LEFT [OUTER] JOIN : ��ġ�⿡ ����� �� ���̺� �� ���� ����� ���̺��� �÷� ���� �������� JOIN
-- ANSI ǥ��
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
--LEFT OUTER JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID); -- OUTER ���� ����

-- ����Ŭ ����
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);

-- 2) RIGHT [OUTER] JOIN : ��ġ�⿡ ����� �� ���̺� �� ������ ��� �� ���̺��� �÷� ���� �������� JOIN
-- ANSI ǥ��
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
RIGHT OUTER JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- ����Ŭ ����
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE(+) = D.DEPT_ID;

-- 3) FULL [OUTER] JOIN : ��ġ�⿡ ����� �� ���̺��� ���� ��� ���� ����� ����
-- ANSI ǥ��
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
FULL OUTER JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- ����Ŭ ������ FULL OUTER JOIN�� ��� ����!!
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE(+) = D.DEPT_ID(+);

------------------------------------------------------------------------------------------

-- 3. ���� ����(CROSS JOIN == īƼ���� ��(CARTESAIN PRODUCT))
-- ���� �Ǵ� ���̺��� �� ����� ��� ���� �� �����Ͱ� �˻� �Ǵ� ���(������)
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT;

------------------------------------------------------------------------------------------
-- 4. �� ���� (NON EQUAL JOIN)

-- '='(��ȣ)�� ������� �ʴ� ���ι�
-- ������ �÷� ���� ��ġ�ϴ� ��찡 �ƴ�, ���� ������ ���ԵǴ� ����� �����ϴ� ���

-- ANSI ����
SELECT EMP_NAME, SALARY, E.SAL_LEVEL, S.SAL_LEVEL
FROM EMPLOYEE E
JOIN SAL_GRADE S ON(SALARY BETWEEN MIN_SAL AND MAX_SAL);

-- ����Ŭ �������� �ۼ��ϱ�
SELECT EMP_NAME, SALARY, E.SAL_LEVEL, S.SAL_LEVEL
FROM EMPLOYEE E, SAL_GRADE S
WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;

---------------------------------------------------------------------------------------------
-- 5. ��ü ����(SELF JOIN)
-- ���� ���̺��� ����, �ڱ� �ڽŰ� ������ ����

-- ����Ŭ ����
SELECT E.EMP_ID, E.EMP_NAME ����̸�, E.DEPT_CODE, E.MANAGER_ID, M.EMP_NAME �������̸�
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MANAGER_ID = M.EMP_ID;

-- ANSI ǥ��
SELECT E.EMP_ID, E.EMP_NAME ����̸�, E.DEPT_CODE, E.MANAGER_ID, M.EMP_NAME �������̸�
FROM EMPLOYEE E
JOIN EMPLOYEE M ON(E.MANAGER_ID = M.EMP_ID);

---------------------------------------------------------------------------------------------
-- 6. ���� ����
-- N���� ���̺��� ��ȸ�� �� ���

-- ����Ŭ ����
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE, DEPARTMENT, LOCATION
WHERE DEPT_CODE = DEPT_ID
AND LOCATION_ID = LOCAL_CODE;

-- ANSI ǥ��
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE);

-- ���� ������ ��Ű�� ���� ���
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);
-- LOCATION_ID�� DEPARTMENT�� ����
-- ù��° ���ο����� DEPARTMENT�� ���� ���� ���谡 �ξ����� ���� �����̹Ƿ�
-- LOCATION_ID�� ���� LOCAL_CODE�� �����Ϸ��� �ϴ� ���� ���� �߻�!!!

---------------------------------------------------------------------------------------------
--[���� ���� ���� ����]
-- ������ �븮�̸鼭 �ƽþ� ������ �ٹ��ϴ� ���� ��ȸ
-- ���, �̸�, ���޸�, �μ���, �ٹ�������, �޿��� ��ȸ�ϼ���
-- ����Ŭ ����
SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME, SALARY
FROM EMPLOYEE, JOB, LOCATION, NATIONAL, DEPARTMENT
WHERE LOCATION.NATIONAL_CODE = NATIONAL.NATIONAL_CODE
    AND EMPLOYEE.JOB_CODE = JOB.JOB_CODE
    AND JOB_NAME = '�븮' 
    AND (NATIONAL_NAME = '�ѱ�' OR NATIONAL_NAME = '�Ϻ�' OR NATIONAL_NAME = '�߱�');

-- ANSI ǥ��
SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
JOIN LOCATION ON(LOCAL_CODE = LOCATION_ID)
JOIN NATIONAL USING(NATIONAL_CODE)
WHERE JOB_NAME = '�븮' 
    AND (NATIONAL_NAME = '�ѱ�' OR NATIONAL_NAME = '�Ϻ�' OR NATIONAL_NAME = '�߱�');

-- [�ǽ�����]
-- 1 ��� ������ �����, ���޸�, �μ���, ������ ��ȸ (INNER JOIN)
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE, JOB, DEPARTMENT, LOCATION
WHERE EMPLOYEE.JOB_CODE= JOB.JOB_CODE
    AND DEPT_ID = DEPT_CODE
    AND LOCATION_ID = LOCAL_CODE;

-- 2 �̸��� '��'�ڰ� ���� ������ ��� ��ȣ, �����, ���޸��� ��ȸ
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE
    AND INSTR(EMP_NAME, '��') != 0;

-- 3 ���ʽ��� ���� �ʴ� J4, J7�� �����ڵ带 ���� ������ ������, ���޸�, ���� ��ȸ
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE
    AND (JOB.JOB_CODE = 'J4' OR JOB.JOB_CODE = 'J7')
    AND BONUS IS NULL;

-- 4 ���� '��'���� 70���� ���� ������ ������, �ֹε�Ϲ�ȣ, �μ���, ���޸��� ��ȸ
SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE, DEPARTMENT, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE
    AND DEPT_ID = DEPT_CODE
    AND SUBSTR(EMP_NAME, 1, 1) = '��';

-- 5 �μ��ڵ尡 D5, D6�� ����� �����, ���޸�, �μ��ڵ�, �μ����� ��ȸ
SELECT EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE
    AND DEPT_ID = DEPT_CODE
    AND DEPT_CODE IN('D5', 'D6');


-- 6 ���ʽ��� �޴� ������ �����, ���ʽ�, �μ���, �������� ��ȸ
SELECT EMP_NAME, BONUS, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE, DEPARTMENT, LOCATION
WHERE DEPT_ID = DEPT_CODE
    AND LOCATION_ID = LOCAL_CODE
    AND BONUS IS NOT NULL;

-- 7 �ѱ��� ���̷� ���� � ����� �����ȣ, �����, ����, �μ���, ���޸�
-- ���� � ����̶�� ������ ���� ������ MIN ������ Ȱ���� ��
-- ����Ŭ
SELECT EMP_ID, EMP_NAME, 
       EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2), 'RR'))) + 1 AS ����,
       DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT, JOB J
WHERE DEPT_CODE = DEPT_ID
AND E.JOB_CODE = J.JOB_CODE
AND EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2), 'RR'))) + 1 = 
(SELECT MIN(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2), 'RR'))) + 1) FROM EMPLOYEE);

-- ANSI
SELECT EMP_ID, EMP_NAME, 
       EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2), 'RR'))) + 1 AS ����,
       DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2), 'RR'))) + 1 =
(SELECT MIN(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2), 'RR'))) + 1) FROM EMPLOYEE);


-- 8 SALARY ���̺��� MIN_SAL ������ �ʰ��� ������ �޴� ����� �����, ���޸�, ����, ����(���ʽ� ����) ��ȸ
-- ����Ŭ
SELECT EMP_NAME, JOB_NAME, SALARY, SALARY*12+SALARY*NVL(BONUS,0) 
FROM EMPLOYEE E, JOB J, SAL_GRADE S
WHERE E.JOB_CODE = J.JOB_CODE
AND E.SAL_LEVEL = S.SAL_LEVEL
AND E.SALARY > S.MIN_SAL;

-- ANSI
SELECT EMP_NAME, JOB_NAME, SALARY, SALARY*12+SALARY*NVL(BONUS,0) 
FROM EMPLOYEE E
JOIN JOB USING(JOB_CODE)
JOIN SAL_GRADE S USING(SAL_LEVEL)
WHERE E.SALARY > S.MIN_SAL;

-- 9 �ѱ��� �Ϻ����� ���ϴ� �������� ������, �μ���, ������, ������ ��ȸ
-- ����Ŭ
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE, DEPARTMENT, LOCATION L, NATIONAL N
WHERE DEPT_CODE = DEPT_ID
AND LOCATION_ID = LOCAL_CODE
AND L.NATIONAL_CODE = N.NATIONAL_CODE
AND NATIONAL_NAME IN('�ѱ�', '�Ϻ�');

-- ANSI
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING(NATIONAL_CODE)
WHERE NATIONAL_NAME IN('�ѱ�', '�Ϻ�');

-- 10 EMPLOYEE ���̺��� DEPT_CODE�� �������� ���� �����Ͽ� �����1, DEPT_CODE, �����2 ��ȸ�ϰ� �����1 �������� ����
--  ��, �����1�� �����2�� ������ ���� ����(��� �� 60��)
-- ����Ŭ
SELECT D.EMP_NAME "�����1" , E.DEPT_CODE, E.EMP_NAME "�����2"
FROM EMPLOYEE E, EMPLOYEE D
WHERE E.DEPT_CODE = D.DEPT_CODE
AND E.EMP_NAME != D.EMP_NAME
ORDER BY 1;

-- ANSI
SELECT D.EMP_NAME "�����1" , E.DEPT_CODE, E.EMP_NAME "�����2"
FROM EMPLOYEE E
JOIN EMPLOYEE D ON(E.DEPT_CODE = D.DEPT_CODE)
WHERE E.EMP_NAME != D.EMP_NAME
ORDER BY 1;


