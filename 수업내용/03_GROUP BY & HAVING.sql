-- GROUP BY & HAVING

/*
    ���� ����
    5 : SELECT �÷��� AS ��Ī, ����, �Լ���
    1 : FROM ������ ���̺��
    2 : WHERE �÷��� | �Լ��� �񱳿����� �񱳰�
    3 : GROUP BY �׷��� ���� �÷���
    4 : HAVING �׷��Լ��� �񱳿����� �񱳰�
    6 : ORDER BY �÷��� | ��Ī | �÷����� ���Ĺ�� [NULLS FIRST | LAST]
*/

------------------------------------------------------
-- GROUP BY�� : ���� ������ ������ ��ϵ� �÷��� ������ ���� ������ �ϳ��� �׷����� ����
-- GROUP BY �÷��� | �Լ���, ...
-- ���� ���� ���� ��� �ϳ��� ó���� �������� �����
-- �׷����� ���� ���� ���ؼ� SELECT������ �׷� �Լ��� �����

-- �׷� �Լ��� �� �Ѱ��� ��� ���� �����ϱ� ������ �׷��� ���� ���� ��� ���� �߻�
-- �������� ������� �����ϱ� ���� �׷� �Լ��� ����� �׷��� ������ GROUP BY ���� ����Ͽ� ���
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- EMPLOYEE ���̺��� �μ��ڵ�, �׷캰 �޿��� �հ�, �׷캰 �޿��� ���(����ó��),
-- �ο����� ��ȸ�ϰ� �μ� �ڵ� ������ ����
SELECT DEPT_CODE �μ��ڵ�, SUM(SALARY) �հ�, FLOOR(AVG(SALARY)) ��, COUNT(*) �ο���
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

--EMPLOYEE ���̺��� �μ��ڵ�� �μ��� ���ʽ� �޴� ��� �� ��ȸ�ϰ� �μ��ڵ� ������ ����
SELECT DEPT_CODE, COUNT(BONUS)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

--EMPLOYEE ���̺��� �����ڵ庰, ���ʽ��� �޴� ����� ���� ��ȸ�Ͽ� �����ڵ� ������ �������� ����
-- ���ʽ� �޴� ����� ���ٸ� �����ڵ� ǥ������ ����
SELECT DEPT_CODE, COUNT(BONUS)
FROM EMPLOYEE
WHERE BONUS IS NOT NULL
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

-- EMPLOYEE ���̺��� ������ ������ �޿� ���(����ó��), �޿� �հ�, �ο� �� ��ȸ�ϰ� �ο����� ��������
SELECT DECODE(SUBSTR(EMP_NO, 8, 1), 1, '��', 2, '��') ����,
    FLOOR(AVG(SALARY)) ���, SUM(SALARY) �հ�, COUNT(*) �ο���
FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO, 8, 1), 1, '��', 2, '��');

----------------------------------------------------------------------
-- HAVING�� : �׷� �Լ��� ���� �� �׷쿡 ���� ������ ������ �� ���(= �׷쿡 �Ŵ� ������)
-- HAVING �÷��� | �Լ��� �񱳿����� �񱳰�

-- �޿� 300�� �̻��� �������� �μ� �׷캰 �޿� ��� ��ȸ(�μ��ڵ� �� ����)
SELECT DEPT_CODE, FLOOR(AVG(SALARY)) ���
FROM EMPLOYEE
WHERE SALARY >= 3000000
GROUP BY DEPT_CODE
ORDER BY 1;

-- �μ� �׷캰 �޿� ����� 300�� �̻��� �׷� ��ȸ(�μ��ڵ� �� ����)
SELECT DEPT_CODE, FLOOR(AVG(SALARY)) ���
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING FLOOR(AVG(SALARY)) >= 3000000
ORDER BY 1;

-- �μ��� �׷��� �޿� �հ� �� 9�鸸���� �ʰ��ϴ� �μ��ڵ�� �޿� �հ� ��ȸ(�μ��ڵ�� ����)
SELECT DEPT_CODE, SUM(SALARY) �޿��հ�
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) > 9000000
ORDER BY 1; -- SELECT���� ù��°�� �� DEPT_CODE ����

-- [����]
-- �޿� �հ谡 ���� ���� �μ��� �μ��ڵ�� �μ� �հ踦 ���Ͻÿ�
-- ���� ����(���� ����) ���
SELECT DEPT_CODE, MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                      FROM EMPLOYEE
                      GROUP BY DEPT_CODE);
                      
------------------------------------------------
-- ���� �Լ�(ROLLUP, CUBE)    SQLD �ܰ����� ����, �߿��� ��
-- �׷캰 ������ ��� ���� ���踦 ����ϴ� �Լ�
-- ���� + �հ�

-- EMPLOYEE ���̺��� �� ���� �ڵ庰 �޿� �հ��
-- ������ �࿡ ��ü �޿� ���� ��ȸ(�����ڵ� �� ����)
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY 1;

SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE)
ORDER BY 1;
-- ���ؼ� ���� ���

SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE)
ORDER BY 1;
-- CUBE�� ����ص� ���� ���

-- ROLLUP �Լ� : �׷캰�� �߰� ���� ó���� �ϴ� �Լ�
-- GROUP BY �������� ����ϴ� �Լ�
-- �׷캰�� ������ ���� ���� �߰� ����� �� ���踦 ���� �� ���
-- *** ���ڷ� ���޹��� �׷� �� ���� ���� ������ �׷캰 �հ�� �� �հ踦 ���ϴ� �Լ� ***

-- EMPLOYEE ���̺��� �� �μ� �ڵ帶�� ���� �ڵ庰 �޿� ��, �μ��� �޿� ��, ���� ��ȸ
-- �μ� �ڵ�� ����
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE) -- ���� �� ���� �� �ִ�. ù ��° ���ڿ� ���� �߰� �հ踦 �����ϰ�, ���� �հ赵 ù ��° ������ �հ� (�� ���ڴ� �����Ѵٰ� ���� �ǳ� ?)
ORDER BY 1;

-- CUBE �Լ� : �׷캰 ������ ����� �����ϴ� �Լ�
-- *** �׷����� ������ ��� �׷쿡 ���� ����� �� �հ踦 ���ϴ� �Լ� ***
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE) -- �� ���ڿ� ���� ROLLUPó�� �ϰ�, �� ���ڿ� ���ؼ��� �߰��հ谡 ���´�.
ORDER BY 1;

-- GROUPING �Լ� : ROLLUP�̳� CUBE�� ���� ���⹰�� ���ڷ� ���޹��� �÷��� ������ ���⹰�̸� 0�� ��ȯ�ϰ�, �ƴϸ� 1�� ��ȯ�ϴ� �Լ�
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY),
    GROUPING(DEPT_CODE) "�μ����׷칭�λ���",
    GROUPING(JOB_CODE) "���޺��׷칭�λ���"
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE;

SELECT DEPT_CODE, JOB_CODE, SUM(SALARY),
    CASE WHEN GROUPING(DEPT_CODE) = 0 AND GROUPING(JOB_CODE) = 1 THEN '�μ����հ�'
         WHEN GROUPING(DEPT_CODE) = 1 AND GROUPING(JOB_CODE) = 0 THEN '���޺��հ�'
         WHEN GROUPING(DEPT_CODE) = 0 AND GROUPING(JOB_CODE) = 0 THEN '�׷캰�հ�'
        ELSE '���հ�'
    END ����
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1;

-----SET OPERATION-----
-- �������� ������ ���� �� �׿� �ش��ϴ� ���� �� ������� ���ս�Ű�� ���� �� ���
-- UNION, INTERSECT, UNION ALL(������ ���� ����� �ϳ��� ��ġ��, �ߺ� ������ �ѹ� �� ������. ������ + ������), MINUS, GROUPING SETS

-- UNION : �������� ���� ����� �ϳ��� ��ġ�� ������
-- �ߺ��� ������ �����Ͽ� �ϳ��� ��ģ��
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

UNION

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- INTERSECT : ���� ���� SELECT �� ������� ���� �κи� ����� ����(������)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

INTERSECT

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- UNION ALL
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

UNION ALL

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- MINUS : ���� SELECT ������� ���� SELECT ����� ��ġ�� �κ��� ������ ������ �κи� ����(������)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

MINUS

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- GROUPING SETS : �׷캰�� ó���� �������� SELECT���� �ϳ��� ��ĥ �� ���
-- SET OPERATION ����� ����� ����
SELECT DEPT_CODE, JOB_CODE, MANAGER_ID, COUNT(*), FLOOR(AVG(SALARY))
FROM EMPLOYEE
GROUP BY GROUPING SETS(
    (DEPT_CODE, JOB_CODE, MANAGER_ID),
    (DEPT_CODE, MANAGER_ID),
    (JOB_CODE, MANAGER_ID));