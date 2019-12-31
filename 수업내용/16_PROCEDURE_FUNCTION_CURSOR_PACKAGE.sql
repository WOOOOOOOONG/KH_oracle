/*
    < PROCEDURE > 
    
    PL/SQL문을 저장하는 객체
    필요할 때마다 복잡한 구문을 다시 입력할 필요 없이 간단하게 호출해서 실행해 결과를 얻을 수 있음.
    특정 로직을 처리하기만 하고 결과 값을 반환하지는 않음.
    자바의 메소드와 동일한 개념
*/

---------------------------------------------------------------------------------------------------
-- 프로시저 생성 방법

/*
    [표현식]
    CREATE OR REPLACE PROCEDURE 프로시저명
        (매개변수명1 [IN|OUT|IN OUT] 데이터타입[:= DEFAULT값],
         매개변수명2 [IN|OUT|IN OUT] 데이터타입[:= DEFAULT값],
         ... )
    IS [AS]
        선언부
    BEGIN
        실행부
    [EXCEPTION
        예외처리부]
    END [프로시저명];
    /
    
    2. 프로시저 실행 방법
    [표현식]
    EXECUTE(OR EXEC) 프로시저명;
*/

-- 테스트용 테이블 생성
CREATE TABLE EMP_DUP
AS SELECT * FROM EMPLOYEE;

-- 프로시저 생성
-- : 호출 시 EMP_DUP 테이블을 모두 삭제하는 프로시저
SELECT * FROM EMP_DUP;

CREATE OR REPLACE PROCEDURE DEL_ALL_EMP
IS
BEGIN
    DELETE FROM EMP_DUP;
    COMMIT;
END;
/

-- DEL_ALL_EMP 프로시저 호출
SELECT * FROM EMP_DUP;

EXECUTE DEL_ALL_EMP;

SELECT * FROM EMP_DUP;

-- 프로시저를 관리하는 데이터 딕셔너리
-- USER_SOURCE
--> 프로시저 작성 구문이 라인별로 구분되어 저장되어 있음.
SELECT * FROM USER_SOURCE;

---------------------------------------------------------------------------------------------------
-- 1) 매개변수 있는 프로시저
--    프로시저 실행 시 매개변수로 인자값 전달해 줘야 함

-- 매개변수 있는 프로시저 생성
CREATE OR REPLACE PROCEDURE DEL_EMP_ID
    (P_EMP_ID EMPLOYEE.EMP_ID%TYPE)
IS
BEGIN
    DELETE FROM EMPLOYEE
    WHERE EMP_ID = P_EMP_ID;
END;
/

-- 프로시저 실행(단, 매개변수로 인자값 전달해줘야함)
-- EXECUTE DEL_EMP_ID; --> 에러 발생
EXEC DEL_EMP_ID('201');

SELECT * FROM EMPLOYEE;

-- 사용자가 입력한 값도 전달 가능
EXEC DEL_EMP_ID('&사원번호');

ROLLBACK;

---------------------------------------------------------------------------------------------------
-- 2) IN/OUT 매개변수 있는 프로시저
-- IN 매개변수 : 프로시저 내부에서 사용될 변수
-- OUT 매개변수 : 프로시저 호출부(외부)에서 사용될 변수

-- IN/OUT 매개변수 있는 프로시저 생성
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

-- * 바인드 변수(VARIABLE OR VAR)
-- SQL 문장을 실행할 때 SQL에 사용 값을 전달할 수 있는 통로 역할을 하는 변수
-- 위 프로시저 실행 시 조회 결과가 저장될 바인드 변수를 생성해야 된다.
VAR VAR_EMP_NAME VARCHAR2(30);
VAR VAR_SALARY NUMBER;
VAR VAR_BONUS NUMBER;

-- * 바인드 변수는 ':변수명' 형태로 참조 가능
EXEC SELECT_EMP_ID('&사번', :VAR_EMP_NAME, :VAR_SALARY, :VAR_BONUS);
--> 실행은 잘 되었지만 조회된 결과가 제대로 변수에 담겼는지 알 수 있음.


SELECT VAR_EMP_NAME, VAR_SALARY, VAR_BONUS FROM DUAL; --> 이런식으로 못씀

-- * PRINT
-- 해당 변수의 내용을 출력해주는 명령어
PRINT VAR_EMP_NAME;
PRINT VAR_SALARY;
PRINT VAR_BONUS;

-- * SET AUTOPRINT ON --> 기본은 OFF 상태
-- 성공적인 PL/SQL 블럭에서 사용되는 바인드 변수의 값을 자동으로 출력
-- 별도의 DBMS_OUTPUT.PUT_LINE() 필요없이 프로시저 호출문 실행 시 바로 RPINT
SET AUTOPRINT ON;

EXEC SELECT_EMP_ID('&사원', :VAR_EMP_NAME, :VAR_SALARY, :VAR_BONUS);

-- [실습문제]
-- 사번을 IN 매개변수로 하고 사원명, 부서명, 직급명을 OUT 매개변수로 하는 SELECT_EMP라는 이름의 프로시저
-- 를 만들고 바인드변수 만들어 실행 후 출력확인
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

EXEC SELECT_EMP('&사원번호', :V_EMP_NAME, :V_DEPT_TITLE, :V_JOB_NAME);

---------------------------------------------------------------------------------------------------
/*
    < FUNCTION >
    프로시저와 사용 용도가 거의 비슷하지만 프로시저와 다르게 OUT 매개변수를 사용하지 않아도 실행 결과를 되돌려
    받을 수 있다. (RETURN)
    
    [표현식]
    CREATE OR REPLACE FUNCTION 함수명
        (매개변수1 타입,
         매개변수2 타입,
         ... )
    RETURN 데이터 타입
    IS[AS]
        선언부
    BEGIN
        실행부
        RETURN 반환값; --> 프로시저와 다르게 RETURN 구문이 추가됨
    [EXCEPTION
        예외처리부]
    END [함수명];
*/

-- 함수 생성
-- : 사번을 입력받아 해당 사원의 연봉을 계산해서 리턴
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

-- 함수 결과를 반환받아 저장할 바인드 변수 선언
VARIABLE VAR_CALC NUMBER;

EXEC :VAR_CALC := BONUS_CALC('&사번'); --> 반환값이 있기 때문에 받아줘야 한다.

-- * 함수는 RETURN 값이 있기 때문에 SELECT 문에서도 사용 가능(EXEC 생략 가능)
SELECT EMP_ID, EMP_NAME, BONUS_CALC(EMP_ID)
FROM EMPLOYEE
WHERE BONUS_CALC(EMP_ID) > 30000000;

---------------------------------------------------------------------------------------------------
/*
    < CURSOR >
    SELECT문 처리 결과(처리 결과가 여러 행)를 담고 있는 메모리 공간에 대한 포인터(참조)
    커서 사용시 여러 ROW로 나타난 처리 결과에 순차적으로 접근 가능
    --> SELECT 결과가 단일행일 경우 INTO절을 이용해 변수에 저장 가능하지만, 
               결과가 다중행일 경우 CURSOR를 이용하면 행(ROW)단위로 처리 가능
    
    * 커서 사용 방법 (총 4단계)
    1) CURSOR --> 커서 선언
    2) OPEN --> 커서 오픈
    3) FETCH --> 커서에서 데이터 추출
    4) CLOSE --> 커서 닫기
    
    * 커서 종류
    묵시적/명시적 커서
    
    1. 묵시적 커서(IMPLICIT CURSOR)
    오라클에서 자동으로 생성되어 사용하는 커서
    PL/SQL 블록에서 실행하는 SQL문 실행시마다 자동으로 만들어져 사용됨
    사용자는 생성 유무를 알 수 없지만, 커서 속성을 활용하여 커서의 정보를 얻어 올 수 있다.
    
    * 커서 속성
    (묵시적 커서 속성 정보 참조시 커서명 = SQL)
    - 커서명%ROWCOUNT : SQL 처리 결과로 얻어온 ROW 수
    -> 0 시작, FETCH시마다 1씩 증가
    - 커서명%FOUND : 커서 영역의 ROW 수가 한 개 이상일 경우 TRUE, 아님 FALSE
    - 커서명%NOTFOUNT : 커서 영역의 ROW 수가 없으면 TRUE, 아님 FALSE
    - 커서명%ISOPEN : 커서가 OPEN 상태인 경우 TRUE, 아님 FALSE(묵시적 커서는 항상 FALSE)    
*/

SET SERVEROUTPUT ON;

-- 묵시적 커서 확인
-- BONUS가 NULL인 사원의 BONUS를 0으로 수정
COMMIT;

BEGIN
    UPDATE EMPLOYEE
    SET BONUS = 0
    WHERE BONUS IS NULL;
    
    -- (묵시적 커서 속성 정보 참조시 커서명 = SQL)
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || '행 수정됨');
END;
/
ROLLBACK;

---------------------------------------------------------------------------------------------------
/*
    2. 명시적 커서(EXPLICIT CURSOR)
    사용자가 직접 선언해서 사용할 수 있는 이름 있는 커서
    
    [표현식]
    CURSOR 커서명 IS [SELECT문]
    OPEN 커서명;
    FETCH 커서명 INTO 변수;
    CLOSE 커서명;
    -- 커서 정의 -> 열기 -> 추출 -> 닫기. 순서
*/

-- 급여가 3000000 이상인 사원의 사번, 이름, 급여 출력
DECLARE
    V_EMP_ID EMPLOYEE.EMP_ID%TYPE;
    V_EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
    V_SALARY EMPLOYEE.SALARY%TYPE;
    
    CURSOR C1 IS --> 커서 생성 : 서브쿼리의 결과를 커서 영역에 담아 둠
        SELECT EMP_ID, EMP_NAME, SALARY
        FROM EMPLOYEE
        WHERE SALARY >= 3000000;
BEGIN
    OPEN C1; --> 커서 오픈
    
    LOOP
        FETCH C1 INTO V_EMP_ID, V_EMP_NAME, V_SALARY;
        --> 커서 패치 : 서브 쿼리의 결과에서 한 ROW씩 데이터를 가져옴
        EXIT WHEN C1%NOTFOUND; --> 무한루프 종료 조건
                 --> %NOTFOUND : 커서가 비어있지 않으면 TRUE
        DBMS_OUTPUT.PUT_LINE(V_EMP_ID || ' ' || V_EMP_NAME || ' ' || V_SALARY);
    END LOOP;
    
    CLOSE C1; --> 커서 종료
END;
/

-- 프로시저 생성 시 커서 사용
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
        DBMS_OUTPUT.PUT_LINE('부서 코드 : ' || V_DEPT.DEPT_ID ||
                                ', 부서명 : ' || V_DEPT.DEPT_TITLE ||
                                ', 지역 : ' || V_DEPT.LOCATION_ID);
    END LOOP;
    
    CLOSE C1;
END;
/

EXEC CURSOR_DEPT;

-- FOR IN LOOP 이용한 커서 활용
-- 반복시 자동으로 CURSOR OPEN
-- FETCH도 자동으로 실행
-- LOOP 종료 시 자동 CLOSE
CREATE OR REPLACE PROCEDURE CURSOR_DEPT
IS
    V_DEPT DEPARTMENT%ROWTYPE;
    
    CURSOR C1
    IS SELECT * FROM DEPARTMENT;
BEGIN
    FOR V_DEPT IN C1 LOOP
        DBMS_OUTPUT.PUT_LINE('부서코드 : ' || V_DEPT.DEPT_ID || ', 부서명 : ' || V_DEPT.DEPT_TITLE || 
                                ', 지역 : ' || V_DEPT.LOCATION_ID);
    END LOOP;
END;
/

EXEC CURSOR_DEPT;

-- CURSOR를 별도로 생성하지 않고 바로 SELECT문을 작성해도 가능
CREATE OR REPLACE PROCEDURE CURSOR_DEPT
IS
    V_DEPT DEPARTMENT%ROWTYPE;
BEGIN
    FOR V_DEPT IN (SELECT * FROM DEPARTMENT) LOOP
        DBMS_OUTPUT.PUT_LINE('부서코드 : ' || V_DEPT.DEPT_ID || ', 부서명 : ' || V_DEPT.DEPT_TITLE || 
                                ', 지역 : ' || V_DEPT.LOCATION_ID);
    END LOOP;
END;
/

EXEC CURSOR_DEPT;

---------------------------------------------------------------------------------------------------
/* 
    < PACKAGE >
    프로시저와 함수를 효율적으로 관리하기 위해 묶는 단위
    패키지는 선언부, 본문(BODY)로 나눠짐
    
    * PACKAGE 선언부 
    - 변수, 상수, 예외, TYPE구문, 커서, 프로시저, 함수 명시 가능
    - 패키지 선언부만 있어도 컴파일 후 사용 가능
    - 단, 프로시저, 함수, 커서 사용 시 패키지 BODY를 꼭 작성해야 한다.
*/

-- 1) 패키지 선언부에 변수, 상수 선언 및 사용 방법
CREATE OR REPLACE PACKAGE TEST_PACK
IS
     TEST1 VARCHAR2(20); --> 변수
     TEST2 CONSTANT VARCHAR2(20) := '상수!!'; --> 상수
END TEST_PACK;
/

-- 패키지에 선언된 변수, 상수 사용
BEGIN
    TEST_PACK.TEST1 := '변수!!';
    
    DBMS_OUTPUT.PUT_LINE('변수 : ' || TEST_PACK.TEST1);
    DBMS_OUTPUT.PUT_LINE('상수 : ' || TEST_PACK.TEST2);
END;
/

-- 2) 패키지 선언부에 프로시저, 함수, 커서 선언 및 사용 방법
CREATE OR REPLACE PACKAGE KH_PACK
IS 
    PROCEDURE SHOW_EMP;
END;
/

EXEC KH_PACK.SHOW_EMP; --> 에러 발생. 패키지 BODY 부분을 생성해야 한다.

-- 패키지 본문(BODY 생성)
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
            DBMS_OUTPUT.PUT_LINE('사번 : ' || V_EMP.EMP_ID || 
                                    ', 이름 : ' || V_EMP.EMP_NAME || 
                                    ', 주민번호 : ' || V_EMP.EMP_NO);
        END LOOP;                                    
    END;
END;
/

EXEC KH_PACK.SHOW_EMP;
