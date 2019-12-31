-- CREATE TABLE 권한이 없어서 오류 발생
-- 3_1. CREATE TABLE 권한 부여 되면 오류 안남
-- 3_2. 그 밖에 TABLE 스페이스를 할당해 줘야함
CREATE TABLE TEST(
    TID NUMBER PRIMARY KEY
);

-- 해당 계정의 테이블에 접근할 수 있는 권한이 없다면 오류 발생 
-- 4. SELECT 권한 부여받게 되면 오류 안남
SELECT * FROM kh.EMPLOYEE;

-- 해당 계정의 테이블에 삽입할 수 있는 권한이 없다면 오류 발생
-- 5. INSERT 권한 부여 받게 되면 오류 안남
INSERT INTO kh.DEPARTMENT VALUES('D0', '해외영업4부', 'L1');













