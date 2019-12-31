-- SUBQUERY
/*
    - �ϳ��� SQL�� �ȿ� ���Ե� �� �ٸ� SQL��
    - ���� ����(���� ����)
    -
*/

-- �������� ����
-- �μ��ڵ尡 ���ö ����� ���� �Ҽ��� ���� ��� ��ȸ

-- 1) ������� ���ö�� ����� �μ� ��ȸ
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '���ö';

-- 2) �μ� �ڵ尡 D9�� ���� ��ȸ
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- 3) �������� �̿�
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '���ö');
                   
-- �������� ����2
-- �� ������ ��� �޿����� ���� �޿��� �ް� �ִ� ������ ���, �̸�, �����ڵ�, ���� ��ȸ
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT AVG(SALARY)
                FROM EMPLOYEE);
-- ���������� �˷����� ���� ������ �̿��� �˻��� ���� ���            
                                      
----------------------------------------------------------
-- <�������� ����>

-- ������ �������� : ���������� ��ȸ ��� ���� ������ 1���� ��
-- ������ �������� : ���������� ��ȸ ��� ���� ������ �������� ��
-- ���߿� �������� : �������� SELECT���� ������ �׸� ���� �������� ��
-- ������ ���߿� �������� : ��ȸ ��� ����� ������ �������� ��
--> ���������� �������� �÷��� ������ ���� �ʴ� ������ ����������
--  ���������� ��(���������� ����� ���)�� �����ϱ� ���� �������� �ַ� ���

-- ��(ȣ��)�� �������� : ���������� ���� ��� ���� ���� ������ �� ������ ��
--                      ���� ���� ���̺��� ���� ����Ǹ� ���������� ��� ���� �ٲ�� ��������
-- ��Į�� �������� : ��� Ŀ���̸鼭 ��� ���� �ϳ��� ��������

--> ���������� �������� Į���� ������ �ִ� ������ ��������
-- �Ϲ������δ� ���������� ���� ����Ǿ� ������ �����͸� ������������ ������ �´��� Ȯ���ϰ��� �� �� �ַ� ���

-- *** ���������� ������ ���� �������� �տ� �ٴ� �����ڰ� �ٸ�***
--------------------------------------------------------------------
-- 1. ������ ��������(SINGLE ROW SUBQUERY)
-- ���� ������ ��ȸ ��� ���� ������ 1�� ��
-- ������ �������� �տ��� �Ϲ� ������ ���
-- <, >, <=, >=, =, !=/<>/^= (��������)

-- ���� 1-1
-- �� ������ �޿� ��պ��� ���� �޿��� �޴� ������ �̸�, ����, �μ�, �޿� ��ȸ
-- ���� �� ����
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= (SELECT AVG(SALARY)
                FROM EMPLOYEE)
ORDER BY 2;

-- ���� 1-2
-- ���ö ����� �޿����� ���� �޴� ������ ���, �̸�, �μ�, ����, �޿��� ��ȸ
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '���ö');
                
-- ���� 1-3
-- ���� ���� �޿��� �޴� ������ ���, �̸�, ����, �μ�, �޿�, �ϻ��� ��ȸ
SELECT EMP_ID, EMP_NAME, JOB_CODE, DEPT_CODE, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY)
                FROM EMPLOYEE);
                
-- *** ���������� WHERE���Ӹ� �ƴ϶� SELECT, HAVING, FROM���� ��� ���� ***
-- ���� 1-4
-- �μ���(�μ��� ���� ��� ����) �޿��� �հ� �� ���� ū �μ��� �μ��� �޿� �հ� ��ȸ
-- 1) �μ��� �޿� �հ�
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
JOIN DEPARTMENT
-- �μ��� ���� ������ ���� -> �� ������ ���� ��ȸ�� ���� LEFT JOIN
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE;

-- 2) �޿� �հ谡 ���� ū �μ��� �޿� �հ�
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 3) �μ��� �޿��� �հ� �� ���� ū �μ�
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE
-- �μ��� �׷� �հ谡 ���� ū �׷� -> �׷쿡 ���� ������ HAVING
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                    FROM EMPLOYEE
                    GROUP BY DEPT_CODE);

----------------------------------------------------------
-- 2. ������ ��������(MULTI ROW SUBQUERY)
-- ���������� ��ȸ ��� ���� ������ �������� ��

-- ������ �������� �տ��� �Ϲ� �� ������ ��� ���Ѵ�(�������� ���ؾ� �ϴϱ�)
-- IN/NOT IN
-- ANY, < ANY : ���� ���� ��� �� �߿��� �� ���� ū / ���� ���
-- ALL, < ALL : ��� ������ ū / ���� ���
-- EXIST / NOT EXISTS : ���� �����ϴ°� �������� �ʴ°�

-- ���� 2-1
-- �μ��� �ְ� �޿��� �޴� ������ �̸�, ����, �μ�, �޿� ��ȸ
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN (SELECT MAX(SALARY)
                FROM EMPLOYEE
                GROUP BY DEPT_CODE)
ORDER BY 3;

-- ���� 2-2
-- �����ڿ� �ش��ϴ� ������ ���� ���� ���� ��ȸ
-- ���, �̸�, �μ���, ����, ����(������/����)

-- 1) �����ڿ� �ش��ϴ� ��� ��ȣ ��ȸ
SELECT DISTINCT MANAGER_ID -- ������ �Ѹ��� ������ ������ �� �����Ƿ� �ߺ� ����
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL;

-- 2) ������ ���, �̸�, �μ���, ���� �ڵ�
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, GOB_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE);

-- 3) �����ڿ� �ش��ϴ� ������ ����
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '������' AS ����
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
            WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID 
            FROM EMPLOYEE
            WHERE MANAGER_ID IS NOT NULL);
            
-- 4) �����ڿ� �ش����� �ʴ� ������ ���� ���� ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '���' AS ����
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
            WHERE EMP_ID NOT IN (SELECT DISTINCT MANAGER_ID 
            FROM EMPLOYEE
            WHERE MANAGER_ID IS NOT NULL);
            
-- 5) 3, 4�� ��ȸ ����� �ϳ��� ��ħ -> UNION       
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '������' AS ����
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
            WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID 
            FROM EMPLOYEE
            WHERE MANAGER_ID IS NOT NULL)
            
UNION

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '���' AS ����
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
            WHERE EMP_ID NOT IN (SELECT DISTINCT MANAGER_ID 
            FROM EMPLOYEE
            WHERE MANAGER_ID IS NOT NULL);
            
-- *** SELECT�������� �������� ����� �� ���� ***
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME,
       CASE WHEN EMP_ID IN (SELECT DISTINCT(MANAGER_ID)
                            FROM EMPLOYEE
                            WHERE MANAGER_ID IS NOT NULL) THEN '������'
            ELSE '����'
       END AS ����
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE);

-- ���� 2-3
-- �븮 ������ ������ �߿��� ���� ������ �ּ� �޿����� ���� �޴� ������ ���, �̸�, ����, �޿� ��ȸ
-- ��, > ANY Ȥ�� < ANY �����ڸ� ����ϼ���
-- 1) �븮 ������ �ֵ�
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '�븮'
AND SALARY >= '2000000';

-- 2) ���� ���� ������ �޿�
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '����';

-- 3) ANY ������ ���
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '�븮'
AND SALARY >= ANY (SELECT SALARY --> ANY �������� ��� �� �߿��� �� ���� ū ���
                    FROM EMPLOYEE
                 JOIN JOB USING(JOB_CODE)
                    WHERE JOB_NAME = '����');
                    
-- ���� 2-4
-- ���� ������ �޿��� ���� ū ������ ���� �޴� ���� ���� ������ ���, �̸�, ����, �޿� ��ȸ(��, > ALL Ȥ�� < ALL ������ ���)
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '����'
AND SALARY >= ALL (SELECT SALARY
                   FROM EMPLOYEE
                   JOIN JOB USING(JOB_CODE)
                   WHERE JOB_NAME = '����');                
-------------------------------------------------------------
-- 3. ���� �� ��������
-- �������� SELECT���� ���� �� ���� ���� �������� ��

-- ���� 3-1
-- ����� �������� ���� �μ�, ���� ���޿� �ش��ϴ� ����� �̸�, ����, �μ�, �Ի����� ��ȸ

-- 1) ����� ������
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = 2
AND ENT_YN = 'Y';

-- 2) ����� �������� ���� �μ�, ���� ���� (���Ͽ� ǥ�� �� -> �ϳ��� �÷��� ��)
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
-- ���� �μ�
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE SUBSTR(EMP_NO, 8, 1) = 2
                    AND ENT_YN = 'Y')
-- ���� ����
AND JOB_CODE = (SELECT JOB_CODE
                FROM EMPLOYEE
                WHERE SUBSTR(EMP_NO, 8, 1) = 2
                AND ENT_YN = 'Y')
-- ���¸� ��� �̸� ����
AND EMP_NAME <> (SELECT EMP_NAME
                FROM EMPLOYEE
                WHERE SUBSTR(EMP_NO, 8, 1) = 2
                AND ENT_YN = 'Y');
                
-- 3) ���߿��� ����     
-- ���߿��� ���������� ���� ������ �̸�, ������������ �������� ���� ������ �̸��� �����.
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) IN (SELECT DEPT_CODE, JOB_CODE
                                FROM EMPLOYEE
                                WHERE SUBSTR(EMP_NO, 8, 1) = 2
                                AND ENT_YN = 'Y')
AND EMP_NAME <> (SELECT EMP_NAME
                FROM EMPLOYEE
                WHERE SUBSTR(EMP_NO, 8, 1) = 2
                AND ENT_YN = 'Y');
                
----------------------------�ǽ� ����-------------------------------------
-- 1. ���ö ����� ���� �μ�, ���� ������ ����� ��ȸ(��, ���ö ��� ����)
-- ���, �̸�, �μ��ڵ�, �����ڵ�, �μ���, ���޸� ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
JOIN JOB USING(JOB_CODE)
WHERE (DEPT_CODE, JOB_CODE) IN (SELECT DEPT_CODE, JOB_CODE
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '���ö')
AND EMP_NAME != '���ö';
                
-- 2. 2000�⵵�� �Ի��� ����� �μ��� ������ ���� ��� ��� ��ȸ
-- ���, �̸�, �μ��ڵ�, �����ڵ�, �����
SELECT EMP_ID, EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                                FROM EMPLOYEE
                                WHERE EXTRACT(YEAR FROM HIRE_DATE) = 2000);

-- 3. 77��� ���� ����� �μ��� �����ڸ� ���� ��� ����� ��ȸ
-- ���, �̸�, �μ��ڵ�, �����ڹ�ȣ, �ֹι�ȣ, �����
SELECT  EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID, EMP_NO, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, MANAGER_ID) = (SELECT DEPT_CODE, MANAGER_ID
                                FROM EMPLOYEE
                                WHERE SUBSTR(EMP_NO, 1, 2) = 77 AND SUBSTR(EMP_NO, 8, 1) = 2);
                                
---------------------------4. ���� �� ���� �� ��������-----------------------------------                                
-- �������� ��ȸ ��� ����� ������ �������� ��

-- ���� 4-1
-- �ڱ� ������ ��ձ޿��� �ް� �ִ� ������ ���, �̸�, ����, �޿� ��ȸ
-- ��, �޿��� �޿� ����� �ʸ��� ������ ���

-- 1) �޿��� 200, 600���� �޴� ����
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN (2000000, 6000000);

-- 2) ���޺� ��� �޿�(�ʸ��� ������ ����)
SELECT JOB_CODE, TRUNC(AVG(SALARY), -5)
FROM EMPLOYEE
GROUP BY JOB_CODE;

-- 3) �ڱ� ������ ��� �޿��� �ް� �ִ� ����
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, TRUNC(AVG(SALARY), -5)
                            FROM EMPLOYEE
                            GROUP BY JOB_CODE);
                            
----------------------5. ��[ȣ��]�� ��������--------------------------
-- �Ϲ������� ���������� ���� ��� ���� ���������� �� �����ϴ� �����ε�,
-- ��������� ���������� ����ϴ� ���̺� ���� ���������� �̿��ؼ� ����� �����.
-- ���������� ���̺� ���� ����Ǹ� ���������� ������� �ٲ�� �Ǵ� ����

-- ���� 5-1
-- ������ ����� EMPLOYEE ���̺� �����ϴ� ������ ���, �̸�, �μ���, ������ ��� ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE EXISTS (SELECT EMP_ID
                FROM EMPLOYEE M
                WHERE E.MANAGER_ID = M.EMP_ID);
-- EXISTS : ���������� �ش��ϴ� ���� ��� �� �� �̻� ������ ��찡 �����Ǹ� SELECT ����
-- ������������ ���������� ���̺� ���� E.MANAGER_ID�� �̿��Ͽ� ����� ����
-- �� �������� ���� ���� )
-- 1) ������������ ������ ���(E.MANAGER_ID)�� �о� ���������� ����
--    (������ ����� �������� ������ NULL ����)
-- 2) ���������� ������������ ���� ������ ����� �ش��ϴ� ���(EMP_ID)�� SELECT
--    (NULL�� ���޵Ǿ��ٸ� �ش��ϴ� ���� 0��)
-- 3) �ٽ� ���������� ������������ SELECT�� ���� ��� �� �� �̻� �����Ѵٸ� SELECT ����(EXIST ����)
--    (NULL�� ���� �Ǿ��ٸ� SELECT�� �������� �ʾƼ� ���� ����� ������

-- ���� 5-2
-- ���޺� �޿� ��պ��� �޿��� ���� �޴� ������ �̸�, ����, �޿� ��ȸ
-- ��, �޿��� �޿� ����� �ʸ��� ���� ���
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE E
WHERE SALARY > (SELECT TRUNC(AVG(SALARY), 5)
                FROM EMPLOYEE M
                WHERE E.JOB_CODE = M.JOB_CODE);
-- 1) ������������ �����ڵ�(E.JOB_CODE)�� �о� ���������� ����
-- 2) ���������� ������������ ���� �����ڵ�� ��ձ޿� ���
-- 3) �ٽ� ���������� ���������� ��� �޿����� ū �޿��� ���� ���

-----------------------------6. ��Į�� ��������-----------------------------------
-- ��������� �� ����
-- SELECT���� ���Ǵ� �������� ����� 1�ุ ��ȯ
-- SQL���� ���ϰ��� ������ '��Į��'��� �Ѵ�
-- ��� �� �� ��

-- ���� 6
-- ��� ����� ���, �̸�, �����ڻ��, �����ڸ� ��ȸ
-- ��, �����ڰ� ���� ��� '����'���� ǥ��
SELECT E.EMP_ID, E.EMP_NAME, E.MANAGER_ID,
        NVL((SELECT M.EMP_NAME
            FROM EMPLOYEE M
            WHERE E.MANAGER_ID = M.EMP_ID), '����') AS �����ڸ�
FROM EMPLOYEE E
ORDER BY 1;

-----------------------------------------------------------------------------------
-- 7. �ζ��� ��(INLINE_VIEW)
-- FROM������ ���������� ���
-- ���������� ���� ��� ����(RESULT SET)�� ���̺� ��ſ� �����

-- ���� 7-1 : �ζ��κ並 Ȱ���� TOP-N �м�
-- �� ���� �� �޿��� ���� ���� 5���� ����, �̸�, �޿� ��ȸ

-- *** ROWNUM : ��ȸ�� ������� 1���� ��ȣ�� �ű� *** 

-- ��� 1
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM <= 5 -- ���� 5��
ORDER BY SALARY DESC;
-- ORDER BY�� SALARY�� �ߴٰ� �ؼ� ���ϴ´�� ���� �ʰ�, ���� �����ͽ�Ʈ���� ù ��°�� ������
-- *** ROWNUM�� FROM���� �����ϸ鼭 �ٿ����� ������ TOP-N�м� �� SELECT���� ����� ROWNUM�� �ǹ� ����(ORDER BY �ȸ���)
--> ORDER BY�� ����� ROWNUM�� �ٿ� �ذ�

-- ��� 2
SELECT ROWNUM, EMP_NAME, SALARY
FROM (SELECT * FROM EMPLOYEE
      ORDER BY SALARY DESC)
WHERE ROWNUM <= 5;

-- �޿� ��� 3���ȿ� ��� �μ��� �μ��ڵ�� �μ���, ��� �޿��� ��ȸ
SELECT DEPT_CODE, DEPT_TITLE, "��� �޿�"
FROM (SELECT DEPT_CODE, DEPT_TITLE, FLOOR(AVG(SALARY)) "��� �޿�"
        FROM EMPLOYEE
        LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
        GROUP BY DEPT_CODE, DEPT_TITLE
        ORDER BY 3 DESC) -- ��� �޿��� ������ ���̺��� ���̺�� ����, �� ���̺��� ������ �Ű� �ٽ� 3�� �ȿ� ��� �μ��� ��ȸ
WHERE ROWNUM <= 3;

-------------------8. WITH-------------------------
-- ���������� �̸��� �ٿ��ְ� ��� �� �̸��� ����ϰ� �Ѵ�.
-- �ζ��κ�� ���� ���������� �ַ� �̿�ȴ�
-- ���� ���� ������ ������ ���� ��� �ߺ� �ۼ��� ���� �� �ְ�
-- ���� �ӵ��� �������ٴ� ������ �ִ�
-- ���� ������ �ʴ´�.

-- ���� 8
-- �� ������ �޿� ����
-- ����, �̸�, �޿� ��ȸ
WITH TOPN_SAL AS (SELECT EMP_ID, EMP_NAME, SALARY --�̸� �����ϰ� ��
                    FROM EMPLOYEE
                    ORDER BY SALARY DESC)
SELECT ROWNUM, EMP_NAME, SALARY
FROM TOPN_SAL;

-- RANK() OVER : ������ ���� ������ ����� ������ �ο� ����ŭ �ǳʶٰ� ���� ���---
-- ROWNUM���� ������ ��� ������ ó�� �κ��� �ٸ���.
-- EX) ���� 1���� 2���̸� ���� �����ڴ� 2���� �ƴ� 3��

SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) AS ����
FROM EMPLOYEE;
-- ���� 19�� �� 21���� �´�

-- DENSE_RANK() OVER : �ߺ��Ǵ� ���� ������ ����� ������ ����� ó��
-- EX) ���� 1���� 2���̾ ���� �����ڴ� 2��
SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) AS ����
FROM EMPLOYEE;
-- ���� 20�� �� 20��

-----------------------------------------------------
-- �μ��� �޿� �հ谡 ��ü �޿� �� ���� ��պ��� 20%���� ���� �μ��� �μ���� �μ��� �޿� �հ� ��ȸ
--> ������ ��������
SELECT DEPT_TITLE, TRUNC("��� �޿�", -5)
FROM (SELECT DEPT_TITLE, AVG(SALARY) "��� �޿�"
        FROM EMPLOYEE
        LEFT JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
        GROUP BY DEPT_TITLE)
WHERE "��� �޿�" >= (SELECT AVG(SALARY)
                    FROM EMPLOYEE);


-- ���� ���̺��� ���ʽ� ������ ������ ���� 5���� ���, �̸�, �μ���, ���޸�, �Ի��� ���� ��ȸ
--> �ζ��� ��
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE
FROM (SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE
        FROM EMPLOYEE
        LEFT JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
        JOIN JOB USING (JOB_CODE)
        ORDER BY ((SALARY * (1 + NVL(BONUS, 0))) * 12) DESC)
WHERE ROWNUM <= 5;

-- HOMEWORK 18�� ����
SELECT STUDENT_NO, STUDENT_NAME
FROM (SELECT STUDENT_NO, STUDENT_NAME
        FROM TB_STUDENT
        JOIN TB_GRADE USING(STUDENT_NO)
        JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
        WHERE DEPARTMENT_NAME = '������а�'
        GROUP BY STUDENT_NO, STUDENT_NAME
        ORDER BY AVG(POINT) DESC)
WHERE ROWNUM = 1;
        
-- DB ���� �� �����ؼ� ���� �����(KH��������)
---- �μ��� ��� �޿� ������ 1������ 3�������� �μ��� �ش��ϴ� ���� ��, ��ü �μ��� �޿� ��պ��� ���� ����� ����Ͻÿ�
---- �̸�, �μ���, �μ� ��ձ޿�
---- �޿��� 10���� ������ ���
WITH AVGSALARY AS (SELECT DEPT_TITLE, DEPT_CODE, AVG(SALARY) "�μ� ��ձ޿�"
               FROM EMPLOYEE 
               JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
               GROUP BY DEPT_TITLE, DEPT_CODE
               ORDER BY 2 DESC)
SELECT EMP_NAME, SALARY, DEPT_TITLE, TRUNC("�μ� ��ձ޿�", -5) "�μ� ��ձ޿�"
      FROM  AVGSALARY, EMPLOYEE
WHERE AVGSALARY.DEPT_CODE = EMPLOYEE.DEPT_CODE
AND SALARY > (SELECT AVG(SALARY)
                FROM EMPLOYEE);


-- �μ��� ��� �޿� ������ 1������ 3�������� �ش��ϴ� �μ��� �̸�, �μ� ��ձ޿�, ���� ���
-- �޿��� 10���� ������ ���
SELECT DEPT_TITLE, TRUNC("�μ� ��ձ޿�", -5) "�μ� ��ձ޿�", ROWNUM "�μ� �޿�����"
      FROM  (SELECT DEPT_TITLE, DEPT_CODE, AVG(SALARY) "�μ� ��ձ޿�"
               FROM EMPLOYEE 
               JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
               GROUP BY DEPT_TITLE, DEPT_CODE
               ORDER BY 2 DESC)
WHERE ROWNUM <= 3;








