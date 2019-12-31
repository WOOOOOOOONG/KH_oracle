-- �Լ�(Function) : �÷��� ���� �о ����� ����� ������

-- ������(SINGLE ROW) �Լ� : �÷��� ��ϵ� N���� ���� �о N���� ����� ����
-- (���̺� ��ȸ���� ����ϸ� �� �࿡ ����� �ݿ��Ǵ� �Լ�)
-- �׷�(GROUP) �Լ� : �÷��� ��ϵ� N���� ���� �о �� ���� ����� ����
-- (����� �׷�ȭ�Ͽ� �ϳ��� ����� �����ϴ� �Լ�)

-- SELECT ���� ������ �Լ��� �׷� �Լ��� �Բ� ��� ���� : ��� ���� ������ �ٸ��� ����
-- �Լ��� ����� �� �ִ� ��ġ : SELECT��, WHERE��, GROUP BY��, HAVING��, ORDER BY��

-- <������ �Լ�>
-- 1. ���� ���� �Լ�
-- LENGTH / LENGTHB
-- ����Ŭ Express Edition�� �ѱ��� 3����Ʈ�� �ν��Ѵ�.
-- LENGTH(�÷��� | '���ڿ���') : ���� �� ��ȯ
-- LENGTHB(�÷��� | '���ڿ���') : ������ ����Ʈ ������ ��ȯ
SELECT LENGTH('����Ŭ'), LENGTHB('����Ŭ')
FROM DUAL; -- DUMMY TABLE(���� ���̺�)

-- DUAL ���̺��̶� ? 
-- SYS ����ڰ� �����ϴ� DUMMY(����) ���̺�
-- �� ������ ����� ����ϱ� ���� ���̺�
-- ��� ������ ����� ���� �÷����� ���� �ѹ��� ����Ϸ��� �� �� ���
-- SQL Funcition�� �׽�Ʈ�غ��� ���� ���

SELECT LENGTH(EMAIL), LENGTHB(EMAIL)
FROM EMPLOYEE;

-------INSTR-------
-- INSTR('���ڿ�' | �÷���, '����', ã�� ��ġ�� ���۰�, [����])
-- ã�� ������ ��ġ ��ȯ

SELECT INSTR('AABAACAABBAA', 'B') FROM DUAL;
SELECT INSTR('AABAACAABBAA', 'B', 1) FROM DUAL;
SELECT INSTR('AABAACAABBAA', 'B', -1) FROM DUAL;
SELECT INSTR('AABAACAABBAA', 'B', 1, 2) FROM DUAL;
SELECT INSTR('AABAACAABBAA', 'B', -1, 2) FROM DUAL;

SELECT EMAIL, INSTR(EMAIL, '@', -1, 1) AS "@ ��ġ" FROM EMPLOYEE; 

SELECT EMAIL, INSTR(EMAIL, 's',  1, 2) FROM EMPLOYEE;

------SUBSTR------
-- �÷��̳� ���ڿ����� ������ ��ġ���� ������ ������ ���ڿ��� �߶� ��ȯ
-- (�ڹ��� String, SubString()�� ���� ����)
--> SUBSTR(STRING, POSITION, [LENGTH])
/*
STRING : ���� Ÿ�� �÷� �Ǵ� ���ڿ�
POSITION : ���ڿ��� �߶� ��ġ�� ����� ���� ���⿡�� ������ ����ŭ ������ �� ���⿡�� ������ ����ŭ�� ��ġ �ǹ�
LENGTH : ��ȯ�� ���� ����(���� �� ���ڿ��� ������ �ǹ�, ������ NULL ����)
*/
SELECT SUBSTR('SHOWMETHEMONEY', 5, 2) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', 7) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', 1, 6) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', -8, 3) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', -10, 2) FROM DUAL;
SELECT SUBSTR('��� �� �� �Ӵ�', 2, 5) FROM DUAL;

-- EMPLOYEE ���̺��� �̸�, �̸���, @���ĸ� ������ ���̵� ��ȸ
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@') - 1)
FROM EMPLOYEE;

-- �ֹε�Ϲ�ȣ�� �̿��� ��/�� �Ǵ�
-- �ֹε�Ϲ�ȣ���� ������ ��Ÿ���� �κи� �߶󺸱�
SELECT EMP_NAME, SUBSTR(EMP_NO, 8, 1) FROM EMPLOYEE;

SELECT EMP_NAME, '��' AS ����
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = 1;

SELECT EMP_NAME, '��' AS ����
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = 2;

-- EMPLOYEE ���̺��� �������� �ֹι�ȣ�� ��ȸ�Ͽ� ����, ����, ������ ���� �и��Ͽ� ��ȸ
-- SELECT �����, ����, ����, ���Ϸ� ��ȸ
SELECT EMP_NAME, SUBSTR(EMP_NO, 1, 2) AS ����, SUBSTR(EMP_NO, 3, 2) AS ����, SUBSTR(EMP_NO, 5, 2) AS ����
FROM EMPLOYEE;
-- SUBSTR���� �ڿ����� ���� �������� �� ���� �̾ƿ� ����

-------------------LPAD/RPAD--------------------
--> ('���ڿ�' | �÷���, ��ȯ�� ������ ����(����Ʈ), [�����̷��� ���ڿ�])
-- �־��� �÷��̳� ���ڿ��� ������ ���ڿ��� ����/�����ʿ� ���ٿ� ���� N�� ���ڿ��� ��ȯ
--> ���ϰ� �ְ�, ���� ���� �ϱ� ���� ���� ���
SELECT LPAD(EMAIL, 20) FROM EMPLOYEE;
-- ������ ���� ���� �� �������� ó��
SELECT LPAD(EMAIL, 20, '#') FROM EMPLOYEE;
SELECT RPAD(EMAIL, 20) FROM EMPLOYEE;
-- �Լ��� ��ø ��� ������ : �Լ� �ȿ��� �Լ��� ����� �� ����
-- EMPLOYEE ���̺��� �����, �ֹι�ȣ ��ȸ
-- ��, �ֹι�ȣ�� ������ϸ� ���̰� �ϰ�, '-' ���� ���� '*'�� �ٲ��
SELECT EMP_NAME �����, RPAD(SUBSTR(EMP_NO,1,7), 14, '*') �ֹι�ȣ
FROM EMPLOYEE;

-------LTRIM/RTRIM--------
--> ('���ڿ�' | �÷���, [�����Ϸ��� ���ڿ�])
-- �־��� �÷��̳� ���ڿ��� ���� Ȥ�� �����ʿ��� ������ STR�� ���Ե� ��� ���ڸ� ������ �������� ��ȯ
SELECT EMP_NAME, LTRIM(PHONE, '010'), RTRIM(EMAIL, '@kh.or.kr') FROM EMPLOYEE;
-- *���� ! STR�� ���Ե� ���� �ϳ��ϳ� ����*
SELECT LTRIM('   KH') FROM DUAL; -- ���ڿ� ������ �������� �ν�
SELECT LTRIM('ACABACCKH', 'ABC') FROM DUAL;
SELECT LTRIM('5782KH', '0123456789') FROM DUAL;

SELECT RTRIM('   KH') FROM DUAL; -- ���ڿ� ������ �������� �ν�
SELECT RTRIM('ACABACCKH', 'ABC') FROM DUAL;
SELECT RTRIM('5782KH', '0123456789') FROM DUAL;

------TRIM-------
-- �־��� �÷��̳� ���ڿ��� ��/��/���ʿ� �ִ� ������ ���ڸ� ����
-- ĳ���ʹ� �ϳ��� �����ϴ�. ������ ������ RTRIM/LTRIM ����.
SELECT TRIM('   KH   ') FROM DUAL;
SELECT TRIM('Z' FROM 'ZZZKHZZZ') FROM DUAL;
-- TRIM�� CHAR�� ��ġ ����, ��(LEADING)/��(TRAILING)/����(BOTH) ���� ����(�⺻ �� ����)
SELECT TRIM (LEADING '1' FROM '111KH111') FROM DUAL;
SELECT TRIM (TRAILING '1' FROM '111KH111') FROM DUAL;
SELECT TRIM (BOTH '1' FROM '111KH111') FROM DUAL;
-- ���ڿ� �ϳ��� ���� ����. �������� LTRIM, RTRIM ����

----------------LOWER/UPPER/INITCAP--------------
-- LOWER(���ڿ� | �÷�) : �ҹ��ڷ� �������ִ� �Լ�
SELECT LOWER('Welcome To My World') FROM DUAL;
-- UPPER
SELECT UPPER('Welcome To My World') FROM DUAL;
-- INITCAP(���ڿ� | �÷�) : �� ������ �ձ��ڸ� �빮�ڷ� �������ִ� �Լ�(Initial Capital. �빮�� �ʱ�ȭ)
SELECT INITCAP('welcome to my world') FROM DUAL;

--------------CONCAT-----------------
-- �÷��� ���� Ȥ�� ���ڿ��� �ΰ� ���޹޾� �ϳ��� ��ģ �� ��ȯ
-- CONCAT(STRING, STRING)
-- ||�� ���� ����
SELECT CONCAT('�����ٶ�', 'ABCD') FROM DUAL;
SELECT '�����ٶ�' || 'ABCD' FROM DUAL;

--------------REPLACE----------------
-- �÷��� ���� Ȥ�� ���ڿ����� Ư�� ����(��)�� ������ ����(��)�� �ٲ� �� ��ȯ
-- REPLACE(STRING, STR1, STR2)
SELECT REPLACE('����� ������ ���ﵿ', '���ﵿ', '�Ｚ��') FROM DUAL;
SELECT REPLACE('sun_di@kh.or.kr', '@kh.or.kr', '@gmail.com') FROM DUAL;


-- 2. ���� ���� �Լ�

-----------ABS----------
-- (���� | ���ڷ� �� �÷���) : ���밪�� ���Ͽ� �����ϴ� �Լ�
SELECT ABS(-10) FROM DUAL;
SELECT ABS(-10.9) FROM DUAL;

-----------MOD-----------
-- (���� | ���ڷ� �� �÷���, ���� | ���ڷ� �� �÷���) : �� ���� ������ �������� ���ϴ� �Լ�
-- ó�� ���ڴ� ���������� ��, �� ��° ���ڴ� ���� ��
SELECT MOD(10, 3) FROM DUAL;
SELECT MOD(10.9, 3) FROM DUAL;

-----------ROUND----------
-- (���� | ���ڷ� �� �÷���, [��ġ]) : �ݿø��Ͽ� �����ϴ� �Լ�
SELECT ROUND(123.456) FROM DUAL;
SELECT ROUND(123.456, 0) FROM DUAL;
SELECT ROUND(123.456, 1) FROM DUAL;
SELECT ROUND(123.456, 2) FROM DUAL;
SELECT ROUND(123.456, -2) FROM DUAL;

-----------FLOOR---------
-- (���� | ���ڷ� �� �÷���) : ����ó�� �ϴ� �Լ�
SELECT FLOOR(123.456) FROM DUAL;
SELECT FLOOR(123.678) FROM DUAL;

-----------TRUNC--------- (truncation ���� �߶󳻴�)
-- (���� | ���ڷ� �� �÷���, [��ġ]) : ����ó�� �ϴ� �Լ�
SELECT TRUNC(123.456) FROM DUAL;
SELECT TRUNC(123.678) FROM DUAL;
SELECT TRUNC(123.456, 1) FROM DUAL;
SELECT TRUNC(123.456, 2) FROM DUAL;
SELECT TRUNC(123.456, -2) FROM DUAL;

------------CEIL-------------
SELECT CEIL(123.456) FROM DUAL;
SELECT CEIL(123.678) FROM DUAL;

SELECT ROUND(123.456), FLOOR(123.456), TRUNC(123.456), CEIL(123.456) FROM DUAL;
-- ROUND �ݿø�, FLOOR ����, TRUNC ���������� ���� ��ġ ���� ����, CEIL �ø�


-- 3. ��¥ ���� �Լ�

--------SYSDATE-----------
-- �ý��ۿ� ����Ǿ� �ִ� ��¥�� ��ȯ�ϴ� �Լ�
SELECT SYSDATE FROM DUAL;

--------MONTHS_BETWEEN(��¥, ��¥) : ���� ���� ���̸� ���ڷ� �����ϴ� �Լ�-------
SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) || '������' AS �ټӿ� FROM EMPLOYEE;

--------ADD_MONTHS(��¥, ����) : ��¥�� ���ڸ�ŭ �������� ���Ͽ� ��¥�� ����--------
SELECT ADD_MONTHS(SYSDATE, 5) FROM DUAL;
-- EMPLOYEE ���̺��� ����� �̸�, �Ի���, �Ի� �� 6������ �� ��¥ ��ȸ
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 6)
FROM EMPLOYEE;

---------NEXT_DAY(���� ��¥, ����(���� | ����)) -> ������ ��� 1 = �Ͽ���, ....., 7  = �����-----------
-- ���� ��¥���� ���Ϸ��� ������ ���� ����� ��¥�� �����ϴ� �Լ�
SELECT SYSDATE, NEXT_DAY(SYSDATE, '�����') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 5) FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '��') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'THURSDAY') FROM DUAL;

ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'THURSDAY') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '�����') FROM DUAL;
ALTER SESSION SET NLS_LANGUAGE = KOREAN;

---------LAST_DAY(��¥) : �ش� ���� ������ ��¥�� ���Ͽ� ����---------
SELECT SYSDATE, LAST_DAY(SYSDATE) FROM DUAL;

-----------�ǽ� ����----------
-- 1. EMPLOYEE ���̺��� �����, �Ի���-����, ����-�Ի��� ��ȸ
-- ��, ��Ī�� �ٹ��ϼ�1, �ٹ��ϼ�2�� �ϰ� ��� ����ó��, ����� �ǵ��� ó��
SELECT EMP_NAME, CEIL(HIRE_DATE - SYSDATE) AS �ٹ��ϼ�1, CEIL(SYSDATE - HIRE_DATE) AS �ٹ��ϼ�2 
FROM EMPLOYEE;

-- 2. EMPLOYEE ���̺��� ����� Ȧ���� �������� ���� ��� ��ȸ
SELECT * FROM EMPLOYEE WHERE MOD(EMP_ID, 2) = 1 ;

-- 3. EMPLOYEE ���̺��� �ٹ� ����� 20�� �̻��� ���� ���� ��ȸ
SELECT * FROM EMPLOYEE WHERE MONTHS_BETWEEN(SYSDATE, HIRE_DATE) >= 240;

-- 4. EMPLOYEE ���̺��� �����, �Ի���, �Ի��� ���� �ٹ� �ϼ�(�ָ� ����)�� ��ȸ
SELECT EMP_NAME, HIRE_DATE, CEIL(LAST_DAY(HIRE_DATE)-HIRE_DATE) AS "�Ի�� �ٹ��ϼ�" FROM EMPLOYEE;

------------------------------------
-- EXTRACT : ��, ��, �� ������ �����Ͽ� ����------------------
-- EXTRACT(YEAR FROM ��¥) : �⵵�� ����--------------------
-- EXTRACT(MONTH FROM ��¥) : ���� ����--------------
-- EXTRACT(DAY FROM ��¥) : �ϸ� ����-----------------
-- EMPLOYEE ���̺��� ����� �̸�, �Ի� ��, �Ի� ��, �Ի� �� ��ȸ---------------
SELECT EMP_NAME ����̸�,
    EXTRACT(YEAR FROM HIRE_DATE) �Ի�⵵,
    EXTRACT(MONTH FROM HIRE_DATE) �Ի��,
    EXTRACT(DAY FROM HIRE_DATE) �Ի���
FROM EMPLOYEE;
-- ORDER BY EMP_NAME ASC;
-- ORDER BY EMP_NAME DESC;
-- ORDER BY ����̸�;
-- ORDER BY 1; -- ����̸� �����ε�
-- ORDER BY �Ի�⵵ ASC, ����̸� DESC; -- �Ի�⵵�� �������� �������� �ϵ�, �Ի�⵵�� ���ٸ� ����̸����� ��������

-- EMPLOYEE ���̺��� ����� �̸�, �Ի���, �ٹ���� ��ȸ
-- 1) (����⵵ - �Ի�⵵)�� ��ȸ
SELECT EMP_NAME, HIRE_DATE, EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) "�ٹ����"
FROM EMPLOYEE;
-- 2) MONTHS_BETWEEN���� �ٹ���� ��ȸ
SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12) AS "�ٹ����" 
FROM EMPLOYEE;

-- ��¥ ���� ����
ALTER SESSION SET NLS_DATE_FORMAT = 'RR-MM-DD'; --YY�� �ƴ� RR�� �� ( ���� �ؿ� ����)
ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';

-------------------------4. ����ȯ �Լ�-------------
-- �̰� �ϳ��ϳ� �� ������ ��
-- TO_CHAR(��¥, [����]) : ��¥�� �����͸� ������ �����ͷ� ����
-- TO_CHAR(����, [����]) : ������ �����͸� ������ �����ͷ� ����
SELECT TO_CHAR(1234) FROM DUAL;
SELECT TO_CHAR(1234, '99999') FROM DUAL; -- 5ĭ ��� ������ ����, ��ĭ ����
SELECT TO_CHAR(1234, '00000') FROM DUAL; -- 5ĭ ��� ������ ����, ��ĭ 0���� ä��
SELECT TO_CHAR(1234, 'L99999') FROM DUAL; -- ���� ������ ������ ȭ�� ���� ����
SELECT TO_CHAR(1234, '$99999') FROM DUAL; -- $��� ȭ�� ���� ����
SELECT TO_CHAR(1234, '99,999') FROM DUAL; -- �ݾ׿��� �ڸ����� �޸� ����
SELECT TO_CHAR(1234, '00,000') FROM DUAL; -- �ݾ׿��� �ڸ����� �޸� ��� ���� 0���� ä��
SELECT TO_CHAR(1234, '999') FROM DUAL; -- �ڸ����� �����ϸ� ǥ������ �ʴ´�
-- 0, 9, 'L', '$', ',', ���� ũ��

-- EMPLOYEE ���̺��� �����, �޿� ��ȸ
-- �޿��� ��ȭ ���� ǥ��
SELECT EMP_NAME, TO_CHAR(SALARY, 'L999,999,999')
FROM EMPLOYEE;

-- ��¥ ������ ���� ����ÿ��� TO_CHAR �Լ� ��� --
SELECT TO_CHAR(SYSDATE, 'PM HH24:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'AM HH:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MON, DY, YYYY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY-fmMM-DD DAY') FROM DUAL; -- fm�� ������ �� �ڸ� ������ �� 0 ����
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-fmDD DAY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YEAR, Q') || '�б�' FROM DUAL; -- �� �𸣰��� ???
SELECT TO_CHAR(SYSDATE, 'YYYY-fmMM-DD DAY PM HH24:MI:SS') FROM DUAL;
SELECT EMP_NAME , TO_CHAR(HIRE_DATE, 'YYYY"��" MM"��" DD"��"')
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE �����Ի���, TO_CHAR(HIRE_DATE, 'YYYY/MM/DD HH24:MI:SS')
FROM EMPLOYEE;

-- �⵵�� ���� ���� ���ڴ� 'Y', 'R'�� ����--
SELECT TO_CHAR(SYSDATE, 'YYYY'), TO_CHAR(SYSDATE, 'RRRR'), TO_CHAR(SYSDATE, 'YY'), TO_CHAR(SYSDATE, 'RR')
FROM DUAL;
-- RR�� ���ڸ� �⵵�� ���ڸ��� �ٲ� �� �ٲ� �⵵�� 50 �̸��̳� 2000���� ����, 50 �̻��̸� 1900���� ����
-- YY�� ������ 2000��� ����

-- ���� ��¥���� ���� ��� ó��---
SELECT TO_CHAR(SYSDATE, 'MM'), TO_CHAR(SYSDATE, 'MONTH'), TO_CHAR(SYSDATE, 'MON'), TO_CHAR(SYSDATE, 'RM') -- RM�� �θ� ǥ��
FROM DUAL;

-- ���� ��¥���� �ϸ� ���---
SELECT TO_CHAR(SYSDATE, '"1�����" DDD "��°"'), TO_CHAR(SYSDATE, '"�ޱ���" DD "��°"'), TO_CHAR(SYSDATE, '"�� ����" D "��°"')
FROM DUAL;

-- EMPLOYEE ���̺��� �̸�, �Ի��� ��ȸ
-- �Ի����� ���� ������ '2019�� 09�� 17�� (ȭ)' �������� ���
SELECT EMP_NAME, TO_CHAR(HIRE_DATE, 'YYYY"��" MM"��" DD"��" "("DY")"')
FROM EMPLOYEE;

-- TO_DATE : ������ �����͸� ��¥�� �����ͷ� ��ȯ�Ͽ� ����---
-- TO_DATE(������ ������, [����]) : ������ �����͸� ��¥�� ����---
-- TO_DATE(������ ������, [����]) : ������ �����͸� ��¥�� ����---
SELECT TO_DATE('20100101', 'RRRRMMDD') FROM DUAL;
SELECT TO_DATE(20100101, 'YYYYMMDD') FROM DUAL;
SELECT TO_CHAR(TO_DATE('20100101', 'YYYYMMDD'), 'YYYY, MON') FROM DUAL;

SELECT TO_CHAR(TO_DATE('980630', 'YYMMDD'), 'YYYYMMDD') FROM DUAL;
SELECT TO_CHAR(TO_DATE('140918', 'YYMMDD'), 'YYYYMMDD') FROM DUAL;

SELECT TO_CHAR(TO_DATE('980630', 'YYMMDD'), 'RRRRMMDD') FROM DUAL;
SELECT TO_CHAR(TO_DATE('140918', 'RRMMDD'), 'RRRRMMDD') FROM DUAL;

-- TO_NUMBER(���ڵ�����, [����]) : ������ �����͸� ���� �����ͷ�----
SELECT TO_NUMBER('123456789') FROM DUAL;
SELECT '123' + '456' FROM DUAL; -- ���ڷ� �ڵ� �� ��ȯ�Ǿ� ���ڷ� ��ģ ����� ���´�. ���� �Է½� ���� �߻�
SELECT '1,000,0000' + '550,000' FROM DUAL;
SELECT TO_NUMBER('1,000,000', '99,999,999') + TO_NUMBER('550,000', '999,999') FROM DUAL;

-- TO_CHAR, TO_DATE, TO_NUMBER

----------5. NULL ó�� �Լ�--------
-- NVL(�÷���, �÷����� NULL�� �� �ٲ� ��)--
SELECT EMP_NAME, BONUS, NVL(BONUS, 0)
FROM EMPLOYEE;
SELECT EMP_NAME, DEPT_CODE, NVL(DEPT_CODE, '00')
FROM EMPLOYEE;

-- NVL2(�÷���, �ٲܰ�1, �ٲܰ�2) ---
-- �ش� �÷��� ���� ������ �ٲܰ�1, NULL�̸� �ٲܰ�2�� ����
-- EMPLOYEE ���̺��� ���ʽ��� NULL�� ������ 0.5��, NULL�� �ƴ� ��� 0.7�� ����
SELECT EMP_NAME, BONUS, NVL2(BONUS, 0.7, 0.5)
FROM EMPLOYEE;

-- NULLIF(�񱳴��1, �񱳴��2) ---
-- �ΰ��� ���� �����ϸ� NULL, �׷��� ������ �񱳴��1�� ����
SELECT NULLIF('123', '123') FROM DUAL;
SELECT NULLIF('123', '1234') FROM DUAL;

----6. ���� �Լ� ----
-- �������� ��쿡 ������ �� �� �ִ� ��� ����.
-- DECODE(���� | �÷���, ���ǰ�1, ���ð�1, ���ǰ�2, ���ð�2 ...)
-- ���ϰ��� �ϴ� �� �Ǵ� �÷��� ���ǽİ� ������ ��� �� ��ȯ
-- ��ġ�ϴ� ���� Ȯ��(�ڹ��� SWITCH�� �����)
SELECT EMP_ID, EMP_NAME, EMP_NO, DECODE(SUBSTR(EMP_NO, 8, 1), '1', '��', '2', '��') ����
FROM EMPLOYEE;

-- ������ ���ڷ� ���ǰ� ���� ���ð��� �ۼ��ϸ� �ƹ��͵� �ش����� ���� �� �������� �ۼ��� ���� ������ ����

-- ������ �޿��� �λ�
-- �����ڵ尡 J7�̸� 10% �λ�
-- �����ڵ尡 j6�̸� 15% �λ�
-- �����ڵ尡 J5�̸� 20% �λ�
-- �� �� ������ ������ 5%�� �λ�
SELECT EMP_NAME, JOB_CODE, SALARY, 
DECODE(JOB_CODE, 
    'J7', SALARY * 1.1, 
    'J6', SALARY * 1.15, 
    'J5', SALARY * 1.2,
    SALARY * 1.05) �λ�޿�
FROM EMPLOYEE;
-- �ش��ϴ� ���� ������ NULL ����

-- CASE WHEN ���ǽ� THEN �����
--      WHEN ���ǽ� THEN �����
--      ELSE ����� END (��Ī ����)
SELECT EMP_ID, EMP_NAME, EMP_NO,
    CASE WHEN SUBSTR(EMP_NO, 8, 1) = 1 THEN '��'
        ELSE '��'
    END ����
FROM EMPLOYEE;

SELECT EMP_NAME, SALARY,
    CASE WHEN SALARY > 5000000 THEN '1���'
        WHEN SALARY > 3500000 THEN '2���'
        WHEN SALARY > 2000000 THEN '3���'
        ELSE '4���'
        END ���
FROM EMPLOYEE;

-- ���� �޿� �λ� CASE WHEN�������� ����
SELECT  EMP_NAME, JOB_CODE, SALARY, 
    CASE WHEN JOB_CODE = 'J7' THEN SALARY * 1.1
        WHEN JOB_CODE = 'J6' THEN SALARY * 1.15
        WHEN JOB_CODE = 'J5' THEN SALARY * 1.2
        ELSE SALARY * 1.05
        END �λ�޿�
FROM EMPLOYEE;

-------------------------------------------------------------
----------------------�׷� �Լ�--------------------------------
-- <�׷� �Լ�> --
-- �ϳ� �̻��� ���� �׷����� ���� �����ϸ� ����, ��� ���� �ϳ��� ����� ��ȯ�ϴ� �Լ�
-- SUM, AVG, MIN, MAX, COUNT

-- SUM(���ڰ� ��ϵ� �÷���) : �հ踦 ���Ͽ� ���� --------
-- EMPLOYEE ���̺��� �� ����� �޿� ���� ��ȸ
SELECT SUM(SALARY)
FROM EMPLOYEE;

-- EMPLOYEE ���̺��� ���� ����� �޿� ���� ��ȸ
SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = 1;

-- EMPLOYEE ���̺��� �μ� �ڵ尡 D5�� ������ ���ʽ� ���� ���� ��ȸ
SELECT SUM((SALARY + (SALARY * NVL(BONUS, 0))) * 12)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

------- AVG(���ڰ� ��ϵ� �÷���) : ����� ���Ͽ� ���� ---------

-- EMPLOYEE ���̺��� �� ����� �޿� ��� ��ȸ
SELECT AVG(SALARY)
FROM EMPLOYEE;

-- EMPLOYEE ���̺��� �� ����� ���ʽ� ����� �Ҽ� ��°�ڸ����� �ݿø� �� �� ��ȸ
-- BONUS�� NULL�� ����� 0���� ó��
SELECT ROUND(AVG(NVL(BONUS, 0)), 2)
FROM EMPLOYEE;
-- *NVL�� ���� ������ NULL ���� ���� ���� ��� ��꿡�� ���ܵǾ� ���Ǳ⿡ ����� ũ�� �޶�����
SELECT ROUND(AVG(BONUS), 2)
FROM EMPLOYEE;

SELECT AVG(BONUS) �⺻���,
    AVG(DISTINCT BONUS) �ߺ��������,
    AVG(NVL(BONUS, 0)) NULL�������
FROM EMPLOYEE;

-- MIN(�÷���) : �÷����� ���� ���� �� ����
-- ����ϴ� �ڷ����� ANY TYPE��

-- EMPLOYEE ���̺��� ���ĺ� ������ ���� ���� �̸���, ���� ���� �Ի���, ���� ���� �޿� ��ȸ
SELECT MIN(EMAIL), MIN(HIRE_DATE), MIN(SALARY)
FROM EMPLOYEE;

-- MAX(�÷���) : �÷����� ���� ū �� ����
-- ����ϴ� �ڷ����� ANY TYPE��

-- EMPLOYEE ���̺��� ��� 200�� �����ϰ�
-- ���ĺ� ������ ���� �ʴ� �̸���, ���� �ֱ� �Ի���, ���� ���� �޿� ��ȸ
SELECT MAX(EMAIL), MAX(HIRE_DATE), MAX(SALARY)
FROM EMPLOYEE
WHERE EMP_ID <> 200;

-- COUNT(* | �÷���) : �� ������ ��Ʒ��� ����
-- COUNT([DISTINCT] �÷���) : �ߺ��� ������ �� ������ ��Ʒ��� ����
-- COUNT(*) : NULL�� ������ ��ü �� ������ ����
-- COUNT(�÷���) : NULL�� ������ ���� ���� ��ϵ� �� ���� ����

-- EMPLOYEE ���̺��� ��ü ��� ��, �μ��ڵ尡 �ִ� ��� ��, ������� �����ִ� �μ��� �� ��ȸ
SELECT COUNT(*), COUNT(DEPT_CODE), COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;

-- �Լ�(Function) :  �÷��� ���� �о ����� ����� ������

-- ������(SINGLE ROW) �Լ� : �÷��� ��� �� N���� ���� �о N���� ����� ����
-- (���̺� ��ȸ���� ����ϸ� �� �࿡ ����� �ݿ��Ǵ� �Լ�)
-- �׷� (GROUP) �Լ� : �÷��� ��ϵ� N���� ���� �о �� ���� ����� ����
-- (����� �׷�ȭ�Ͽ� �ϳ��� ����� �����ϴ� �Լ�)

-- SELECT ���� ������ �Լ��� �׷� �Լ��� �Բ� ��� ���� : ��� ���� ������ �ٸ��� ����

-- �Լ��� ����� �� �ִ� ��ġ : SELECT��, WHERE��, 
--                          GROUP BY��, HAVING��, ORDER BY��

-- < ������ �Լ� >
-- 1. ���� ���� �Լ�

-- *** LENGTH / LENGTHB ***
/*
    ����Ŭ Express Edition�� �ѱ��� 3����Ʈ�� �ν�
    LENGTH(�÷��� | '���ڿ���') : ���� �� ��ȯ
    LENGTHB(�÷��� | '���ڿ���') : ������ ����Ʈ ������ ��ȯ
*/

SELECT LENGTH('����Ŭ'), LENGTHB('����Ŭ')
FROM DUAL; -- DUMMY TABLE(���� ���̺�)

-- DUAL ���̺��̶�?
-- SYS ����ڰ� �����ϴ� DUMMY(����) ���̺�
-- �� ������ ����� ����ϱ� ���� ���̺�
-- ��� ������ ����� ���� �÷����� ���� �ѹ��� ����Ϸ��� �� �� ���
-- SQL Function �� �׽�Ʈ�غ��� ���� ���

SELECT LENGTH(EMAIL), LENGTHB(EMAIL)
FROM EMPLOYEE;

-- *** INSTR ***
--> INSTR('���ڿ�' | �÷���, '����', ã�� ��ġ�� ���۰�, [����])

SELECT INSTR('AABAACAABBAA', 'B') FROM DUAL;
-- 1�� �ε������� ã�ƶ�
SELECT INSTR('AABAACAABBAA', 'B', 1) FROM DUAL;
-- ������ ���밪��ŭ �������� �̵� �� �������� �˻��� �����϶�
SELECT INSTR('AABAACAABBAA', 'B', -1) FROM DUAL;
-- 1�� �ε������� �ι�° ��ġ�� B�� ã�ƶ�
SELECT INSTR('AABAACAABBAA', 'B', 1, 2) FROM DUAL;
-- �ǳ� �ε������� �������� �̵��ϸ� �ι�° B�� ã�ƶ�
SELECT INSTR('AABAACAABBAA', 'B', -1, 2) FROM DUAL;

SELECT EMAIL, INSTR(EMAIL, '@', -1, 1) "@ ��ġ"
FROM EMPLOYEE;

SELECT EMAIL, INSTR(EMAIL, 's', 1, 2) "�ι�° s ��ġ"
FROM EMPLOYEE;
--------------------------------------------------------------------------------------------
-- ** SUBSTR ***
-- �÷��̳� ���ڿ����� ������ ��ġ���� ������ ������ ���ڿ��� �߶󳻾� ��ȯ
-- (�ڹ��� String.subString()�� ���� ����)
--> SUBSTR(STRING, POSITION, [LENGTH])
/*
STRING : ���� Ÿ�� �÷� �Ǵ� ���ڿ�
POSITION : ���ڿ��� �߶� ��ġ�� ����� ���� ���⿡�� ������ ����ŭ,
           ������ �� ���⿡�� ������ ����ŭ�� ��ġ �ǹ�
LENGTH : ��ȯ�� ���� ����(���� �� ���ڿ��� ������ �ǹ�, ������ NULL ����)
*/

SELECT SUBSTR('SHOWMETHEMONEY', 5, 2) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', 7) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', 1, 6) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', -8, 3) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', -10, 2) FROM DUAL;
SELECT SUBSTR('��� �� �� �Ӵ�', 2, 5) FROM DUAL;

-- EMPLOYEE ���̺��� �̸�, �̸���, @���ĸ� ������ ���̵� ��ȸ
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')-1)
FROM EMPLOYEE;

-- �ֹε�Ϲ�ȣ�� �̿��Ͽ� ��/�� �Ǵ�
-- �ֹι�ȣ���� ������ ��Ÿ���� �κи� �߶󺸱�
SELECT EMP_NAME, SUBSTR(EMP_NO, 8, 1)
FROM EMPLOYEE;

SELECT EMP_NAME, '��' ����
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) = 1;

SELECT EMP_NAME, '��' ����
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) = 2;

-- EMPLOYEE ���̺��� �������� �ֹι�ȣ�� ��ȸ�Ͽ�
-- ����, ����, ������ ���� �и��Ͽ� ��ȸ�Ͻÿ�
-- SELECT �����, ����, ����, ���Ϸ� ��ȸ
SELECT EMP_NAME �����,
      SUBSTR(EMP_NO, 1, 2) ����,
      SUBSTR(EMP_NO, 3, 2) ����,
      SUBSTR(EMP_NO, 5, 2) ����
FROM EMPLOYEE;
-------------------------------------------------------------------------------------------
-- *** LPAD / RPAD ***
--> ('���ڿ�' | �÷���, ��ȯ�� ������ ����(����Ʈ), [�����̷��� ���ڿ�])
-- �־��� �÷��̳� ���ڿ��� ������ ���ڿ��� ���� / �����ʿ� ���ٿ� ���� N�� ���ڿ��� ��ȯ
--> ���ϰ� �ְ�, ���� ���� �ϱ� ���� ���� ���
SELECT LPAD(EMAIL, 20)
FROM EMPLOYEE;
-- ������ ���ڿ� ���� �� �������� ó��

SELECT LPAD(EMAIL, 20, '#')
FROM EMPLOYEE;

SELECT RPAD(EMAIL, 20, '#')
FROM EMPLOYEE;

-- �Լ��� ��ø ��� ������ : �Լ� �ȿ��� �Լ��� ����� �� ����
-- EMPLOYEE ���̺��� �����, �ֹι�ȣ ��ȸ
-- ��, �ֹι�ȣ�� ������ϸ� ���̰� �ϰ�, '-' ���� ���� '*'�� �ٲ��
SELECT EMP_NAME �����,
       RPAD(SUBSTR(EMP_NO,1,7), 14, '*') �ֹι�ȣ
FROM EMPLOYEE;
-------------------------------------------------------------------------------------
-- *** LTRIM / RTRIM ***
--> ('���ڿ�' | �÷���, [�����Ϸ��� ���ڿ�])
-- �־��� �÷��̳� ���ڿ��� ���� Ȥ�� �����ʿ��� ������ STR�� ���Ե� ��� ���ڸ� ������ �������� ��ȯ
SELECT EMP_NAME, LTRIM(PHONE, '010'), RTRIM(EMAIL, '@kh.or.kr')
FROM EMPLOYEE;

-- ����!! STR�� ���Ե� ���� �ϳ��ϳ� ����!!
SELECT LTRIM('   KH') FROM DUAL; -- ���ڿ� ������ �������� �ν�
SELECT LTRIM('ACABACCKHABC', 'ABC') FROM DUAL;
SELECT LTRIM('5782KH5782', '0123456789') FROM DUAL;

SELECT RTRIM('   KH') FROM DUAL; -- ���ڿ� ������ �������� �ν�
SELECT RTRIM('ACABACCKHABC', 'ABC') FROM DUAL;
SELECT RTRIM('5782KH5782', '0123456789') FROM DUAL;

-- *** TRIM ***
-- �־��� �÷��̳� ���ڿ��� ��/��/���ʿ� �ִ� ������ ���ڸ� ����
SELECT TRIM('   KH   ') FROM DUAL;
SELECT TRIM('Z' FROM 'ZZZKHZZZ') FROM DUAL;

-- TRIM�� CHAR�� ��ġ ����, ��(LEADING)/��(TRAILING)/����(BOTH) ���� ����(�⺻ �� ����)
SELECT TRIM (LEADING '1' FROM '111KH111') FROM DUAL;
SELECT TRIM (TRAILING '1' FROM '111KH111') FROM DUAL;
SELECT TRIM (BOTH '1' FROM '111KH111') FROM DUAL;
----------------------------------------------------------------------------------------------
-- *** LOWER / UPPER / INITCAP ***
-- LOWER(���ڿ� | �÷�) : �ҹ��ڷ� �������ִ� �Լ�
SELECT LOWER('Welcome To My World') FROM DUAL;
-- UPPER(���ڿ� | �÷�) : �빮�ڷ� �������ִ� �Լ�
SELECT UPPER('Welcome To My World') FROM DUAL;
-- INITCAP(���ڿ� | �÷�) : �ձ��ڸ� �빮�ڷ� �������ִ� �Լ�
SELECT INITCAP('welcome to my world') FROM DUAL;

------------------------------------------------------------------------------------------------
-- *** CONCAT ***
-- �÷��� ���� Ȥ�� ���ڿ��� �ΰ� ���� �޾� �ϳ��� ��ģ �� ��ȯ
-- CONCAT(STRING, STRING)
SELECT CONCAT('�����ٶ�', 'ABCD') FROM DUAL;

-- ||�� ���� ����
SELECT '�����ٶ�' || 'ABCD' FROM DUAL;
-----------------------------------------------------------------------------
-- *** REPLACE ***
-- �÷��� ���� Ȥ�� ���ڿ����� Ư�� ����(��)�� ������ ����(��)�� �ٲ� �� ��ȯ
-- REPLACE(STRING, STR1, STR2)
SELECT REPLACE('����� ������ ���ﵿ', '���ﵿ', '�Ｚ��')
FROM DUAL;

SELECT REPLACE('sun_di@kh.or.kr', '@kh.or.kr', '@gmail.com') FROM DUAL;
------------------------------------------------------------------------------------------------
-- 2. ���� ó�� �Լ�
-- *** ABS ***
-- (���� | ���ڷ� �� �÷���) : ���밪�� ���Ͽ� �����ϴ� �Լ�
SELECT ABS(-10) FROM DUAL;
SELECT ABS(-10.9) FROM DUAL;

-- *** MOD ***
-- (���� | ���ڷ� �� �÷���, ���� | ���ڷ� �� �÷���) : �� ���� ����� �������� ���ϴ� �Լ�
-- ó�� ���ڴ� ���������� ��, �ι�° ���ڴ� ���� ��
SELECT MOD(10, 3) FROM DUAL;
SELECT MOD(10.9, 3) FROM DUAL;
-------------------------------------------------------------------------------------
-- *** ROUND ***
-- (���� | ���ڷ� �� �÷���, [��ġ]) : �ݿø��Ͽ� �����ϴ� �Լ�
SELECT ROUND(123.456) FROM DUAL;
SELECT ROUND(123.456, 0) FROM DUAL;
SELECT ROUND(123.456, 1) FROM DUAL;
SELECT ROUND(123.456, 2) FROM DUAL;
SELECT ROUND(123.456, -2) FROM DUAL;

-- *** FLOOR ***
-- (���� | ���ڷ� �� �÷���) : ����ó�� �ϴ� �Լ�
SELECT FLOOR(123.456) FROM DUAL;
SELECT FLOOR(123.678) FROM DUAL;

-- *** TRUNC ***
-- (���� | ���ڷ� �� �÷���, [��ġ]) : ����ó�� �ϴ� �Լ�
SELECT TRUNC(123.456) FROM DUAL;
SELECT TRUNC(123.678) FROM DUAL;
SELECT TRUNC(123.456, 1) FROM DUAL;
SELECT TRUNC(123.456, 2) FROM DUAL;
SELECT TRUNC(123.456, -2) FROM DUAL;

-- *** CEIL ***
-- (���� | ���ڷ� �� �÷���) : �ø�ó���ϴ� �Լ�
SELECT CEIL(123.456) FROM DUAL;
SELECT CEIL(123.678) FROM DUAL;

SELECT ROUND(123.456),
       FLOOR(123.456),
       TRUNC(123.456),
       CEIL(123.456)
FROM DUAL;
---------------------------------------------------------------------------------------
-- 3. ��¥ ó�� �Լ�
-- SYSDATE : �ý��ۿ� ����Ǿ� �ִ� ��¥�� ��ȯ�ϴ� �Լ�
SELECT SYSDATE FROM DUAL;

-- MONTHS_BETWEEN(��¥, ��¥) : ���� ���� ���̸� ���ڷ� �����ϴ� �Լ�
-- EMPLOYEE ���̺��� ����� �̸�, �Ի���, �ٹ� ���� ���� ��ȸ
SELECT EMP_NAME, HIRE_DATE, MONTHS_BETWEEN(SYSDATE, HIRE_DATE)
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) || '������'
FROM EMPLOYEE;

-- ADD_MONTHS(��¥, ����) : ��¥�� ���ڸ�ŭ �������� ���Ͽ� ��¥�� ����
SELECT ADD_MONTHS(SYSDATE, 5) FROM DUAL;

-- EMPLOYEE ���̺��� ����� �̸�, �Ի���, �Ի� �� 6������ �� ��¥ ��ȸ
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 6)
FROM EMPLOYEE;

-- NEXT_DAY(���� ��¥, ����(���� | ����)) --> ������ ��� 1 = �Ͽ���, ..., 7 = �����
-- ���� ��¥���� ���Ϸ��� ������ ���� ����� ��¥�� �����ϴ� �Լ�
SELECT SYSDATE, NEXT_DAY(SYSDATE, '�����') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 5) FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '��') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'THURSDAY') FROM DUAL; -- ����

ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'THURSDAY') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '�����') FROM DUAL; -- ����
ALTER SESSION SET NLS_LANGUAGE = KOREAN;

-- LAST_DAY(��¥) : �ش� ���� ������ ��¥�� ���Ͽ� ����
SELECT SYSDATE, LAST_DAY(SYSDATE) FROM DUAL;

------------------------------------- �ǽ� ���� ------------------------------------------
-- 1. EMPLOYEE ���̺��� �����, �Ի���-����, ����-�Ի��� ��ȸ
-- ��, ��Ī�� �ٹ��ϼ�1, �ٹ��ϼ�2�� �ϰ�
-- ��� ����ó��, ����� �ǵ��� ó��
SELECT EMP_NAME, 
       FLOOR(ABS(HIRE_DATE - SYSDATE)) "�ٹ��ϼ�1", 
       FLOOR(ABS(SYSDATE - HIRE_DATE)) "�ٹ��ϼ�2"
FROM EMPLOYEE;
-- 2. EMPLOYEE ���̺��� ����� Ȧ���� �������� ���� ��� ��ȸ
SELECT *
FROM EMPLOYEE
WHERE MOD(EMP_ID, 2) = 1;
-- 3. EMPLOYEE ���̺��� �ٹ� ����� 20�� �̻��� ���� ���� ��ȸ
SELECT *
FROM EMPLOYEE
-- WHERE MONTHS_BETWEEN(SYSDATE, HIRE_DATE) >= 240;
WHERE ADD_MONTHS(HIRE_DATE, 240) <= SYSDATE;

-- 4. EMPLOYEE ���̺��� �����, �Ի���, �Ի��� ���� �ٹ� �ϼ�(�ָ� ����)�� ��ȸ
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE) - HIRE_DATE + 1 "�Ի���� �ٹ��ϼ�"
FROM EMPLOYEE;

------------------------------------------------------------------------------------------
-- EXTRACT : ��, ��, �� ������ �����Ͽ� ����
-- EXTRACT(YEAR FROM ��¥) : �⵵�� ����
-- EXTRACT(MONTH FROM ��¥) : ���� ����
-- EXTRACT(DAY FROM ��¥) : �ϸ� ����

-- EMPLOYEE ���̺��� ����� �̸�, �Ի� ��, �Ի� ��, �Ի� �� ��ȸ
SELECT EMP_NAME ����̸�,
       EXTRACT(YEAR FROM HIRE_DATE) �Ի�⵵,
       EXTRACT(MONTH FROM HIRE_DATE) �Ի��,
       EXTRACT(DAY FROM HIRE_DATE) �Ի���
FROM EMPLOYEE
--ORDER BY EMP_NAME ASC;
--ORDER BY EMP_NAME DESC;
--ORDER BY ����̸�;
--ORDER BY 1;
ORDER BY �Ի�⵵, ����̸� DESC;

-- EMPLOYEE ���̺��� ����� �̸�, �Ի���, �ٹ������ ��ȸ
-- 1) (����⵵ - �Ի�⵵)�� ��ȸ
SELECT EMP_NAME, HIRE_DATE,
       EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) "�ٹ����"
FROM EMPLOYEE;
-- 2) MONTHS_BETWEEN���� �ٹ���� ��ȸ
SELECT EMP_NAME, HIRE_DATE,
       FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12) �ٹ����
FROM EMPLOYEE;

-- ��¥ ���� ����
ALTER SESSION SET NLS_DATE_FORMAT = 'RR-MM-DD';
ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';
-----------------------------------------------------------------------------------------------
-- 4. ����ȯ �Լ�
-- TO_CHAR(��¥, [����]) : ��¥�� �����͸� ������ �����ͷ� ����
-- TO_CHAR(����, [����]) : ������ �����͸� ������ �����ͷ� ����
SELECT TO_CHAR(1234) FROM DUAL;
SELECT TO_CHAR(1234, '99999') FROM DUAL; -- 5ĭ, ������ ����, ��ĭ ����
SELECT TO_CHAR(1234, '00000') FROM DUAL; -- 5ĭ, ������ ����, ��ĭ 0
SELECT TO_CHAR(1234, 'L99999') FROM DUAL; -- ���� ������ ������ ȭ�� ����
SELECT TO_CHAR(1234, '$99999') FROM DUAL;
SELECT TO_CHAR(1234, '99,999') FROM DUAL; -- �ڸ��� ���� �޸�
SELECT TO_CHAR(1234, '00,000') FROM DUAL;
SELECT TO_CHAR(1234, '999') FROM DUAL; --�ڸ����� �����ϸ� ǥ��X

-- EMPLOYEE ���̺��� �����, �޿� ��ȸ
-- �޿��� ��ȭ �������� ǥ��
SELECT EMP_NAME, TO_CHAR(SALARY, 'L999,999,999')
FROM EMPLOYEE;

-- ��¥ ������ ���� ����ÿ��� TO_CHAR �Լ� ���
SELECT TO_CHAR(SYSDATE, 'PM HH24:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'AM HH:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MON, DY, YYYY')FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY-fmMM-DD DAY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-fmDD DAY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YEAR, Q') || '�б�' FROM DUAL;

SELECT EMP_NAME, TO_CHAR(HIRE_DATE, 'YYYY"��" MM"��" DD"��"') �Ի���
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE �����Ի���,
       TO_CHAR(HIRE_DATE, 'YYYY/MM/DD HH24:MI:SS') ���Ի���
FROM EMPLOYEE;

-- �⵵�� ���� ���� ���ڴ� 'Y', 'R'�� ����
SELECT TO_CHAR(SYSDATE, 'YYYY'), TO_CHAR(SYSDATE, 'RRRR'),
       TO_CHAR(SYSDATE, 'YY'), TO_CHAR(SYSDATE, 'RR')
FROM DUAL;
-- RR�� ���ڸ� �⵵�� ���ڸ��� �ٲ� ��
-- �ٲ� �⵵�� 50�̸��̸� 2000���� ����, 50 �̻��̸� 1900���� ����

-- ���� ��¥���� ���� ��� ó��
SELECT TO_CHAR(SYSDATE, 'MM'),
       TO_CHAR(SYSDATE, 'MONTH'),
       TO_CHAR(SYSDATE, 'MON'),
       TO_CHAR(SYSDATE, 'RM')
FROM DUAL;

-- ���� ��¥���� �ϸ� ���
SELECT TO_CHAR(SYSDATE, '"1�����" DDD "��°"'),
       TO_CHAR(SYSDATE, '"�� ����" DD "��°"'),
       TO_CHAR(SYSDATE, '"�� ����" D "��°"')
FROM DUAL;

-- EMPLOYEE ���̺��� �̸�, �Ի��� ��ȸ
-- �Ի����� ���� ������ '2019�� 09�� 17�� (ȭ)' �������� ���
SELECT EMP_NAME, TO_CHAR(HIRE_DATE,'YYYY"��" MM"��" DD"��" "("DY")"')
FROM EMPLOYEE;

-- TO_DATE
-- TO_DATE(������ ������, [����]) : ������ �����͸� ��¥�� ����
-- TO_DATE(������ ������, [����]) : ������ �����͸� ��¥�� ����
SELECT TO_DATE('20100101', 'YYYYMMDD') FROM DUAL;
SELECT TO_DATE(20100101, 'YYYYMMDD') FROM DUAL;
SELECT TO_CHAR(TO_DATE('20100101', 'YYYYMMDD'), 'YYYY, MON') FROM DUAL;

SELECT TO_CHAR(TO_DATE('980630', 'YYMMDD'), 'YYYYMMDD') FROM DUAL;
SELECT TO_CHAR(TO_DATE('140918', 'YYMMDD'), 'YYYYMMDD') FROM DUAL;

SELECT TO_CHAR(TO_DATE('980630', 'RRMMDD'), 'RRRRMMDD') FROM DUAL;
SELECT TO_CHAR(TO_DATE('140918', 'RRMMDD'), 'RRRRMMDD') FROM DUAL;

-- TO_NUMBER(���ڵ�����, [����]) : �����������͸� ���� �����ͷ�
SELECT TO_NUMBER('123456789') FROM DUAL;

SELECT '123' + '456' FROM DUAL; -- ���ڷ� �ڵ� ����ȯ, ���� �Է½� ���� �߻�

SELECT '1,000,000' + '550,000' FROM DUAL; -- ���� �߻�

-- TO_NUMBER�� ���ڷ� ���� �� �ذ�
SELECT TO_NUMBER('1,000,000', '9,999,999') + TO_NUMBER('550,000', '999,999') FROM DUAL; 
----------------------------------------------------------------------------------------------
-- 5. NULL ó�� �Լ�
-- NVL(�÷���, �÷����� NULL�϶� �ٲ� ��)
SELECT EMP_NAME, BONUS, NVL(BONUS, 0)
FROM EMPLOYEE;

SELECT EMP_NAME, DEPT_CODE, NVL(DEPT_CODE, '00')
FROM EMPLOYEE;

-- NVL2(�÷���, �ٲܰ�1, �ٲܰ�2)
-- �ش� �÷��� ���� ������ �ٲܰ�1�� ����,
-- �ش� �÷��� NULL�̸� �ٲܰ�2�� ����

-- EMPLOYEE ���̺��� ���ʽ��� NULL�� ������ 0.5��, NULL�� �ƴ� ��� 0.7�� ����
SELECT EMP_NAME, BONUS, NVL2(BONUS, 0.7, 0.5)
FROM EMPLOYEE;

-- NULLIF(�񱳴��1, �񱳴��2)
-- �ΰ��� ���� �����ϸ� NULL, �׷��� ������ �񱳴��1�� ����
SELECT NULLIF('123', '123') FROM DUAL;
SELECT NULLIF('123', '1234') FROM DUAL;
--------------------------------------------------------------------------------------------
-- 6. �����Լ�
-- �������� ��쿡 ������ �� �� �ִ� ����� �����Ѵ�

-- DECODE(���� | �÷���, ���ǰ�1, ���ð�1, ���ǰ�2, ���ð�2 ...)
-- ���ϰ��� �ϴ� �� �Ǵ� �÷��� ���ǽİ� ������ ��� �� ��ȯ
-- ��ġ�ϴ� ���� Ȯ��(�ڹ��� SWITCH�� �����)
SELECT EMP_ID, EMP_NAME, EMP_NO,
       DECODE(SUBSTR(EMP_NO, 8, 1), '1', '��', '2', '��')
FROM EMPLOYEE;

-- ������ ���ڷ� ���ǰ� ���� ���ð��� �ۼ��ϸ�
-- �ƹ��͵� �ش����� ���� �� �������� �ۼ��� ���� ���� ������ �����Ѵ�

-- ������ �޿��� �λ�
-- �����ڵ尡 J7�̸� 10%�λ�
-- �����ڵ尡 J6�̸� 15%�λ�
-- �����ڵ尡 J5�̸� 20%�λ�
-- �� �� ������ ������ 5%�� �λ�
-- ������, �����ڵ�, �޿�, �λ�޿� ��ȸ
SELECT EMP_NAME, JOB_CODE, SALARY, 
       DECODE(JOB_CODE, 'J7', SALARY * 1.1,
                        'J6', SALARY * 1.15,
                        'J5', SALARY * 1.2,
                        SALARY * 1.05) �λ�޿�
FROM EMPLOYEE;
-- �ش��ϴ� ���� ������ NULL ����!!!

-- CASE WHEN ���ǽ� THEN �����
--      WHEN ���ǽ� THEN �����
--      ELSE �����
-- END
-- ���ϰ��� �ϴ� �� �Ǵ� �÷��� ���ǽİ� ������ ��� �� ��ȯ
-- ������ ���� �� ����

SELECT EMP_ID, EMP_NAME, EMP_NO,
       CASE WHEN SUBSTR(EMP_NO, 8, 1) = 1 THEN '��'
            ELSE '��'
       END ����
FROM EMPLOYEE;

SELECT EMP_NAME, SALARY,
       CASE WHEN SALARY > 5000000 THEN '1���'
            WHEN SALARY > 3500000 THEN '2���'
            WHEN SALARY > 2000000 THEN '3���'
            ELSE '4���'
       END ���
FROM EMPLOYEE;

-- ���� �޿� �λ� CASE WHEN �������� �����ϱ�
SELECT EMP_NAME, JOB_CODE, SALARY,
       CASE WHEN JOB_CODE = 'J7' THEN SALARY * 1.1
            WHEN JOB_CODE = 'J6' THEN SALARY * 1.15
            WHEN JOB_CODE = 'J5' THEN SALARY * 1.2
            ELSE SALARY * 1.05
       END �λ�޿�
FROM EMPLOYEE;
----------------------------------------------------------------------------------------------

-- < �׷� �Լ� >
-- �ϳ� �̻��� ���� �׷����� ���� �����ϸ� ����, ��� ���� �ϳ��� ����� ��ȯ�ϴ� �Լ�

-- SUM(���ڰ� ��ϵ� �÷���) : �հ踦 ���Ͽ� ����
-- EMPLOYEE ���̺��� �� ����� �޿� ���� ��ȸ
SELECT SUM(SALARY)
FROM EMPLOYEE;

-- EMPLOYEE ���̺��� ���� ����� �޿� ���� ��ȸ
SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = 1;

-- EMPLOYEE ���̺��� �μ� �ڵ尡 D5�� ������ ���ʽ� ���� ���� ��ȸ
SELECT SUM((SALARY + (SALARY * NVL(BONUS,0))) *12)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- AVG(���ڰ� ��ϵ� �÷���) : ����� ���Ͽ� ����

-- EMPLOYEE ���̺��� �� ����� �޿� ��� ��ȸ
SELECT AVG(SALARY)
FROM EMPLOYEE;

-- EMPLOYEE ���̺��� �� ����� ���ʽ� ����� �Ҽ� ��°�ڸ����� �ݿø� �� �� ��ȸ
-- BONUS�� NULL�� ����� 0���� ó��
SELECT ROUND(AVG(NVL(BONUS, 0)), 2)
FROM EMPLOYEE;
-- *NVL�� ���� ���� �� NULL ���� ���� ���� ��� ��꿡�� ���ܵǾ� ���

SELECT AVG(BONUS) �⺻���,
       AVG(DISTINCT BONUS) �ߺ��������,
       AVG(NVL(BONUS, 0)) NULL�������
FROM EMPLOYEE;

-- MIN(�÷���) : �÷����� ���� ���� �� ����
-- ����ϴ� �ڷ����� ANY TYPE��

-- EMPLOYEE ���̺��� ���ĺ� ������ ���� ���� �̸���, ���� ���� �Ի���, ���� ���� �޿� ��ȸ
SELECT MIN(EMAIL), MIN(HIRE_DATE), MIN(SALARY)
FROM EMPLOYEE;

-- MAX(�÷���) : �÷����� ���� ū �� ����
-- ����ϴ� �ڷ����� ANY TYPE

-- EMPLOYEE ���̺��� ��� 200�� �����ϰ�
-- ���ĺ� ������ ���� �ʴ� �̸���, ���� �ֱ� �Ի���, ���� ���� �޿� ��ȸ
SELECT MAX(EMAIL), MAX(HIRE_DATE), MAX(SALARY)
FROM EMPLOYEE
WHERE EMP_ID <> 200;

-- COUNT(* | �÷���) : �� ������ ��Ʒ��� ����
-- COUNT([DISTINCT] �÷���) : �ߺ��� ������ �� ������ ��Ʒ��� ����
-- COUNT(*) : NULL�� ������ ��ü �� ������ ����
-- COUNT(�÷���) : NULL�� ������ ���� ���� ��� �� �� ������ ����

-- EMPLOYEE ���̺��� ��ü ��� ��, �μ��ڵ尡 �ִ� ��� ��, ������� �����ִ� �μ��� �� ��ȸ
SELECT COUNT(*), COUNT(DEPT_CODE), COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;

---------------------------------------------------------------------------------------
-- �Լ� ���� ����
--1. ������� �ֹι�ȣ�� ��ȸ��
--  ��, �ֹι�ȣ 9��° �ڸ����� �������� '*'���ڷ� ä��
--  �� : ȫ�浿 771120-1******
SELECT EMP_NAME, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*')
FROM EMPLOYEE;

--2. ������, �����ڵ�, ����(��) ��ȸ
--  ��, ������ ��57,000,000 ���� ǥ�õǰ� ��
--     ������ ���ʽ�����Ʈ�� ����� 1��ġ �޿���
SELECT EMP_NAME ������, JOB_CODE �����ڵ�, TO_CHAR((SALARY + (1+(SALARY * NVL(BONUS, 0))) * 12), 'L999,999,999') ����
FROM EMPLOYEE;


--3. �μ��ڵ尡 D5, D9�� ������ �߿��� 2004�⵵�� �Ի��� ������ 
--	��� ����� �μ��ڵ� �Ի���
SELECT EMP_ID ���, EMP_NAME, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE = 'D5' OR DEPT_CODE = 'D9') AND EXTRACT(YEAR FROM HIRE_DATE) = 2004;

-- 4. ������, �Ի���, �Ի��� ���� �ٹ��ϼ� ��ȸ
-- ��, �ָ��� ������
SELECT EMP_NAME AS ������, 
    HIRE_DATE AS �Ի���, 
    EXTRACT(DAY FROM LAST_DAY(HIRE_DATE) - SUBSTR(HIRE_DATE, 7, 2)) + 1 AS "ù�� �ٹ��ϼ�"
FROM EMPLOYEE;

-- 5. ������, �μ��ڵ�, �������, ����(�ѱ���) ��ȸ
-- ��, ��������� �ֹι�ȣ���� �����ؼ�, 
-- ������ ������ �����Ϸ� ��µǰ� ��.
-- ���� �⵵ - �¾ �⵵ + 1
SELECT EMP_NAME ������, 
    DEPT_CODE �μ��ڵ�,  
    TO_CHAR(TO_DATE(SUBSTR(EMP_NO, 1, 6), 'YYMMDD'), 'YY"��"MM"��"DD"��') �������,
    (119 - SUBSTR(EMP_NO, 1, 2)) + 1 AS ����
FROM EMPLOYEE;

-- 6. �������� �Ի��Ϸ� ���� �⵵�� ������, �� �⵵�� �Ի��ο����� ���Ͻÿ�.
--  �Ʒ��� �⵵�� �Ի��� �ο����� ��ȸ�Ͻÿ�.
--  => TO_CHAR, DECODE, COUNT ���
--	-------------------------------------------------------------
--	��ü������   2001��   2002��   2003��   2004��
--	-------------------------------------------------------------
-- ?
SELECT COUNT(HIRE_DATE) AS ��ü������,
    COUNT(DECODE(TO_CHAR(HIRE_DATE, 'RRRR'), '2001', 1)) "2001��", -- 2001�⿡�� 1�� ����, ������ �͵鿡�� NULL�� ���� ������ 2001�� ��ȿ�� ���� �Ǿ� �� �� �ִ�
    COUNT(DECODE(TO_CHAR(HIRE_DATE, 'RRRR'), '2002', 1)) "2002��", -- DECODE�� ������ ���� ������ NULL�̳� ���� �Ű����� �������� ���� ���� ����.
    COUNT(DECODE(TO_CHAR(HIRE_DATE, 'RRRR'), '2003', 1)) "2003��", -- DECODE�� CHAR�� �˻��� �� �ִµ�
    COUNT(DECODE(TO_CHAR(HIRE_DATE, 'RRRR'), '2004', 1)) "2004��"
FROM EMPLOYEE;
--    COUNT(SUBSTR(HIRE_DATE, 1, 2) = '2000'),
--    COUNT(SUBSTR(HIRE_DATE, 1, 2) = '2001'),
--    COUNT(SUBSTR(HIRE_DATE, 1, 2) = '2002'),
--    COUNT(SUBSTR(HIRE_DATE, 1, 2) = '2003')  ���� Ʋ�� �ڵ�


--7.  �μ��ڵ尡 D5�̸� �ѹ���, D6�̸� ��ȹ��, D9�̸� �����η� ó���Ͻÿ�.
--   ��, �μ��ڵ尡 D5, D6, D9 �� ������ ������ ��ȸ��
--  => case ���
SELECT EMP_NAME, DEPT_CODE, CASE WHEN DEPT_CODE = 'D5' THEN '�ѹ���'
    WHEN DEPT_CODE = 'D6' THEN '��ȹ��'
    WHEN DEPT_CODE = 'D9' THEN '������'
    END �μ�
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' OR DEPT_CODE = 'D6' OR DEPT_CODE = 'D9';
-- WHERE DEPT_CODE IN('D5', 'D6', 'D9'); �� ����




