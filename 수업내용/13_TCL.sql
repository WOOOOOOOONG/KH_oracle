/*
    TCL(TRANSACTION CONTROL LANGUAGE : 트랜잭션 관리 처리(제어) 언어
    
    COMMIT(트랜잭션 종료 처리 후 저장),
    ROLLBACK(트랜잭션 취소),
    SAVEPOINT(임시저장)
    
    트랜잭션
    - 데이터베이스의 논리적 연산 단위
    - 데이터의 변경 사항들을 묶어서 하나의 트랜잭션에 담아서 처리
    - 트랜잭션의 대상이 되는 SQL : INSERT, UPDATE, DELETE
    
    COMMIT 진행 : 메모리 버퍼에 임시 저장 된 데이터 -> DB 반영
    ROLLBACK 진행 : 메모리 버퍼에 임시 저장 된 데이터의 변경 사항
                   을 삭제하고 마지막 COMMIT 상태로 돌아감
    SAVEPOINT
    저장점을 정의하면 롤백할 때 트랜잭션에 포함 된 전체 작업을
    롤백하는게 아니라 현 시점에서 SAVEPOINT까지의 트랜잭션 일부만 롤백
    SAVEPOINT 포인트명1;
    ROLLBACK TO 포인트명1;
    
*/
SELECT * FROM EMP_01;

-- EMP_01 테이블에 데이터를 한 행 삭제(EMP_ID가 900인 사원)
DELETE FROM EMP_01
WHERE EMP_ID = 900;

SELECT * FROM EMP_01;

ROLLBACK;

SELECT * FROM EMP_01; --> 복구됨

-- 한 행이 삭제된 상태에서 SAVEPOINT 지정
DELETE FROM EMP_01
WHERE EMP_ID = 900;

SAVEPOINT SP1;

DELETE FROM EMP_01
WHERE EMP_ID = 217;

SELECT * FROM EMP_01;

-- SP1으로 ROLLBACK
ROLLBACK TO SP1;

SELECT * FROM EMP_01;

-- 마지막 COMMIT 시점으로 ROLLBACK
ROLLBACK;

SELECT * FROM EMP_01;







