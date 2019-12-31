/*
    TCL(TRANSACTION CONTROL LANGUAGE : Ʈ����� ���� ó��(����) ���
    
    COMMIT(Ʈ����� ���� ó�� �� ����),
    ROLLBACK(Ʈ����� ���),
    SAVEPOINT(�ӽ�����)
    
    Ʈ�����
    - �����ͺ��̽��� ���� ���� ����
    - �������� ���� ���׵��� ��� �ϳ��� Ʈ����ǿ� ��Ƽ� ó��
    - Ʈ������� ����� �Ǵ� SQL : INSERT, UPDATE, DELETE
    
    COMMIT ���� : �޸� ���ۿ� �ӽ� ���� �� ������ -> DB �ݿ�
    ROLLBACK ���� : �޸� ���ۿ� �ӽ� ���� �� �������� ���� ����
                   �� �����ϰ� ������ COMMIT ���·� ���ư�
    SAVEPOINT
    �������� �����ϸ� �ѹ��� �� Ʈ����ǿ� ���� �� ��ü �۾���
    �ѹ��ϴ°� �ƴ϶� �� �������� SAVEPOINT������ Ʈ����� �Ϻθ� �ѹ�
    SAVEPOINT ����Ʈ��1;
    ROLLBACK TO ����Ʈ��1;
    
*/
SELECT * FROM EMP_01;

-- EMP_01 ���̺� �����͸� �� �� ����(EMP_ID�� 900�� ���)
DELETE FROM EMP_01
WHERE EMP_ID = 900;

SELECT * FROM EMP_01;

ROLLBACK;

SELECT * FROM EMP_01; --> ������

-- �� ���� ������ ���¿��� SAVEPOINT ����
DELETE FROM EMP_01
WHERE EMP_ID = 900;

SAVEPOINT SP1;

DELETE FROM EMP_01
WHERE EMP_ID = 217;

SELECT * FROM EMP_01;

-- SP1���� ROLLBACK
ROLLBACK TO SP1;

SELECT * FROM EMP_01;

-- ������ COMMIT �������� ROLLBACK
ROLLBACK;

SELECT * FROM EMP_01;







