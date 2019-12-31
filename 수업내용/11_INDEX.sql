/*
    < 인덱스 INDEX >
    인덱스는 어떤 종류의 검색 연산을 최적화하기 위해 데이터베이스상에
    로우들의 정보를 구성하는 데이터 구조
    인덱스를 이용하면 전체 데이터를 검색하지 않고 데이터베이스에서
    원하는 정보를 빠르게 검색할 수 있음
    SQL 명령문의 처리 속도를 향상시키기 위해서 컬럼에 대해 생성하는
    오라클 객체로 내부 구조는 B*트리 형식으로 구성됨
    
    - 장점
      트리 형식으로 구성되어 자동 정렬 및 검색 속도가 빨라짐
      시스템에 걸리는 부하를 줄여 시스템 전체 성능 향상
      
    - 단점
      인덱스를 추가하기 위한 별도의 저장공간이 필요
      인덱스를 생성하는데 시간이 걸림
      데이터 변경 작업(DML)이 빈번한 경우에는 오히려 성능 저하
    
*/

/*
    1. 인덱스 생성 방법
    [표현식]
    CREATE [UNIQUE] INDEX 인덱스명
    ON 테이블명(컬럼명, 컬럼명, ... | 함수명, 함수계산식);

*/

-- 인덱스를 관리하는 DATA DICTIONARY
SELECT *
FROM USER_IND_COLUMNS;

---------------------------------------------------------------
-- 2. 인덱스 구조

/*
    ROWID : DB내 데이터 공유 주소, ROWID를 이용해 데이터 접근 가능
    
    1~6 번째 : 데이터 오브젝트 번호
    7~9 번째 : 파일 번호
    10~15번째 : BLOCK 번호
    16~18번째 : ROW 번호
*/
SELECT ROWID, EMP_ID, EMP_NAME
FROM EMPLOYEE;
------------------------------------------------------------
-- 3. 인덱스 원리
--    인덱스 생성 시 지정한 컬럼은 KEY, ROWID는 VALUE가 되어 
--    MAP처럼 구성 됨

-- SELECT시 WHERE절에 인덱스가 생성되어 있는 컬럼을 추가하면
-- 데이터 조회 시 테이블의 모든 데이터에 접근(풀스캐닝)하는 것이 아니라
-- 해당 컬럼(KEY)와 매칭되는 ROWID(VALUE)가 가리키는 ROW주소 값을
-- 조회해 주어 속도가 향상 됨

-- 인덱스 활용
-- 인덱스 활용 X SELECT문
SELECT EMP_ID, EMP_NAME
FROM EMPLOYEE
WHERE EMP_NAME = '윤은해';

-- 인덱스 활용 O SELECT문
SELECT EMP_ID, EMP_NAME
FROM EMPLOYEE
WHERE EMP_ID = '210';

/*
    WHERE절에
    INDEX가 부여되지 않은 컬럼으로 조회 시
    --> 윤은해가 어느 곳에 있는지 모르기 때문에 EMPLOYEE 테이블 
        데이터 전부를 DB BUFFER 캐시로 복사한 뒤 FULL SCAN으로 찾음
    INDEX가 부여된 컬럼으로 조회
    --> INDEX에 먼저 가서 210 정보가 어떤 ROWID를 가지고 있는지
        확인한 뒤 해당 ROWID에 있는 블럭만 찾아가서 DB BUFFER 캐시에 복사
*/

---------------------------------------------------------------
/*
    4. 인덱스 종류
    
    1) 고유 인덱스(UNIQUE INDEX)
    2) 비고유 인덱스(NONUNIQUE INDEX)
    3) 단일 인덱스(SINGLE INDEX)
    4) 결합 인덱스(COMPOSITE INDEX)
    5) 함수 기반 인덱스(FUNCTION BASED INDEX)
*/

/*
    1) 고유 인덱스 (UNIQUE INDEX)
    - UNIQUE INDEX에 생성 된 컬럼에는 중복 값 포함 불가
    - 오라클 PRIMARY KEY, UNIQUE KEY 제약조건 설정 시 해당 컬럼
      에 대한 INDEX가 존재하지 않으면 자동으로 해당 컬럼에 UNIQUE INDEX 생성
    - PRIMARY KEY를 이용하여 ACCESS 하는 경우 성능 향상에 효과가 있음
*/

-- EMPLOYEE 테이블의 EMP_NAME 컬럼 UNIQUE INDEX 생성하기
CREATE UNIQUE INDEX IDX_EMP
ON EMPLOYEE(EMP_NAME);

-- 사용자가 생성한 인덱스 조회
SELECT *
FROM USER_INDEXES
WHERE TABLE_NAME = 'EMPLOYEE';

-- 인덱스의 키가 되는 컬럼 조회
SELECT *
FROM USER_IND_COLUMNS
WHERE TABLE_NAME = 'EMPLOYEE';
--> PRIMARY KEY(EMP_ID), UNIQUE(EMP_NO)에 대한 인덱스는 이미 생성
--  되어 있고, 새로 생성한 IDX_EMP 인덱스가 추가되어 있음

-- 인덱스로 지정한 EMP_NAME 컬럼을 이용한 조회
SELECT * FROM EMPLOYEE
WHERE EMP_NAME = '하이유';

INSERT INTO EMPLOYEE
VALUES(100, '하이유', '111111-2222222', 'rkd@naver.com',
       '01011112222', 'D1', 'J7', 'S3', 3000000, 0.3, 201,
       SYSDATE, NULL, DEFAULT);
-- 원래는 이름에 대한 UNIQUE 조건이 없었지만 UNIQUE INDEX 생성으로
-- 이제는 UNIQUE 값만 입력해야 함

-- EMPLOYEE 테이블의 DEPT_CODE 컬럼 UNIQUE INDEX 생성
CREATE UNIQUE INDEX IDX_DEPTCODE
ON EMPLOYEE(DEPT_CODE);
-- duplicate keys found
--> 컬럼 값들 중에 중복되는 값이 있을 경우 UNIQUE INDEX 생성 불가
------------------------------------------------------------
/*
    2) 비고유 인덱스(NONUNIQUE INDEX)
    - 빈번하게 사용되는 일반 컬럼을 대상으로 생성
    - 주로 성능 향상을 목적으로 생성
    
    3) 단일 인덱스(SINGLE INDEX)
    - 한 개의 컬럼으로 구성 된 인덱스

*/
-- EMPLOYEE 테이블의 DEPT_CODE 컬럼에 인덱스 생성
CREATE INDEX IDS_DEPTCODE
ON EMPLOYEE(DEPT_CODE);
--> 비고유(중복 값 포함 가능)이면서 단일(컬럼이 한개)인덱스

-- 인덱스 이름 수정
ALTER INDEX IDS_DEPTCODE
RENAME TO IDX_DEPTCODE;

-- 인덱스 조회
SELECT * FROM USER_IND_COLUMNS
WHERE TABLE_NAME = 'EMPLOYEE';

-- 인덱스 삭제
DROP INDEX IDX_DEPTCODE;
-----------------------------------------------------------
/*
    4) 결합 인덱스(COMPOSITE INDEX)
    - 두 개 이상의 컬럼으로 구성 된 인덱스
*/
-- DEPARTMENT 테이블의 DEPT_ID, DEPT_TITLE 결합 인덱스 생성
CREATE INDEX IDX_DEPT
ON DEPARTMENT(DEPT_ID, DEPT_TITLE);

-- 인덱스 조회
SELECT * FROM USER_IND_COLUMNS
WHERE TABLE_NAME = 'DEPARTMENT';
-- IDX_DEPT라는 하나의 인덱스 이름으로 두 컬럼이 생성됨

-- 결합 인덱스 활용 예시
SELECT * FROM DEPARTMENT
WHERE (DEPT_ID, DEPT_TITLE) = (SELECT DEPT_ID, DEPT_TITLE
                               FROM DEPARTMENT
                               WHERE DEPT_ID = 'D1');
------------------------------------------------------------
/*
    5. 인덱스 활용 여부 확인
    
    EMPLOYEE 테이블을 복사한 EMP001 테이블을 만들고
    1) EMP001 테이블의 EMP_ID 컬럼에 대해 UNIQUE INDEX 만듦 : IDX_EID
    2) EMP001 테이블의 EMP_ID가 200미만인 새 직원 정보 삽입 후
        (1) 인덱스 활용 X 전체 조회
        (2) 인덱스 활용 O 전체 조회
         + 인덱스 모니터링을 통한 인덱스 모니터링 사용 여부 확인
*/
-- EMP001 테이블 생성
CREATE TABLE EMP001
AS SELECT * FROM EMPLOYEE;

-- 1) EMP_ID 컬럼에 대해 UNIQUE INDEX 생성
CREATE UNIQUE INDEX IDX_EID
ON EMP001(EMP_ID);

-- 인덱스 조회
SELECT * FROM USER_IND_COLUMNS
WHERE TABLE_NAME = 'EMP001';

-- 2) EMP001 테이블에 EMP_ID가 200미만인 새직원 삽입
INSERT INTO EMP001
VALUES(199, '테스트', '880101-1234567', 'test@kh.or.kr', 
       '01096341245', 'D9', 'J1', 'S3', 1000000, 0.5, NULL,
       SYSDATE, NULL, DEFAULT);
       
-- 인덱스 모니터링 : 만들어진 인덱스가 조회 시 사용 되었는지 확인
-- 모니터링 할 인덱스 설정
ALTER INDEX IDX_EID MONITORING USAGE;

-- 인덱스 모니터링
SELECT *
FROM V$OBJECT_USAGE;
-- V$OBJECT_USAGE : 인덱스 활용과 관련 된 데이터를 수집하는 뷰
-- USED : 모니터링 시작 후 해당 인덱스가 사용되었는지 확인

-- (1) 인덱스 활용 X 전체 조회
SELECT * FROM EMP001;
--> 새 직원의 정보가 테이블의 제일 마지막에 조회 됨

-- 인덱스 모니터링
SELECT *
FROM V$OBJECT_USAGE;

-- (2) 인덱스 활용 O 전체 조회
SELECT * FROM EMP001
WHERE EMP_ID > '0';
--> 새 직원의 정보가 자동 정렬되어 제일 위에 조회 됨

-- 인덱스 모니터링
SELECT *
FROM V$OBJECT_USAGE;

-- 인덱스 모니터링 종료
ALTER INDEX IDX_EID NOMONITORING USAGE;
----------------------------------------------------------
/*
    5. 함수 기반 인덱스(FUNCTION-BASED INDEX)
    - SELECT절이나 WHERE절에 산술 계산식이나 함수식이 사용된 경우
    계산식은 인덱스의 적용을 받지 않음
    - 계산식으로 검색하는 경우가 많으면, 수식이나 함수식을 인덱스로
      만들 수 있다.
*/
-- SALARY 컬럼에 인덱스 생성
CREATE INDEX IDX_SAL
ON EMPLOYEE(SALARY);

-- 모니터링 ON
ALTER INDEX IDX_SAL MONITORING USAGE;

-- 산술 계산식, 함수식 사용하여 SELECT
SELECT EMP_ID, EMP_NAME, SALARY, ((SALARY + (SALARY * NVL(BONUS, 0)))*12)
FROM EMPLOYEE
WHERE ((SALARY + (SALARY * NVL(BONUS, 0)))*12) > 30000000;

-- 인덱스 모니터링 : USED -> NO
SELECT *
FROM V$OBJECT_USAGE;

-- 함수 기반 인덱스 생성
CREATE INDEX IDX_SALYEAR
ON EMPLOYEE(((SALARY + (SALARY * NVL(BONUS, 0))) * 12));

-- 인덱스 조회
SELECT * FROM USER_IND_COLUMNS
WHERE TABLE_NAME = 'EMPLOYEE';

-- 모니터링 ON
ALTER INDEX IDX_SALYEAR MONITORING USAGE;

-- 함수 기반 인덱스 사용한 SELECT
SELECT EMP_ID, EMP_NAME, SALARY, ((SALARY + (SALARY * NVL(BONUS, 0)))*12)
FROM EMPLOYEE
WHERE ((SALARY + (SALARY * NVL(BONUS, 0)))*12) > 30000000;

-- 인덱스 모니터링 : USED -> YES
SELECT *
FROM V$OBJECT_USAGE;
-----------------------------------------------------------
/* 
    6. 인덱스 재구성(INDEX REBUILD)
    DML 작업 명렁을 수행한 경우
    해당 인덱스 내에서 엔트리가 논리적으로만 제거되고 실제 엔트리는
    그냥 남아있게 된다. 인덱스가 필요 없는 공간을 차지(저장공간 낭비)
    하고 있기 때문에 인덱스를 재 생성 할 필요가 있음!!!
    
*/
ALTER INDEX IDX_EID REBUILD;













