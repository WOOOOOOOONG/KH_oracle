/*
    <PL /SQL>
    PROCEDURAL LANGUAGE EXTENSION TO SQL
    : SQL에 대한 절차적 언어 확장
    
    오라클 자체에 내자되어 있는 절차적 언어
    SQL 문장 내에서 변수의 정의, 조건 처리(IF), 반복 처리(LOOP, FOR, WHILE)
    등을 지원해서 SQL의 단점 보완
    
    * PL/SQL 구조
    - 선언부(DECLARE SECTION) : DECLARE로 시작, 변수나 상수를 선언하는 부분
    - 실행부(EXCUTABLE SECTION) : BEGIN으로 시작, 제어문, 반복문, 함수 등의 로직을 기술
    - 예외처리부(EXCEPTION SECTION) : EXCEPTION으로 시작, 예외상황 발생 시 해결하기 위한 문장 기술
    -> 변수부분, 함수부분, 예외부분 3개로 나뉜 듯
    
    * PL/SQL의 장점
    - PL/SQL문은 BLOCK 구조로 다수의 SQL문을 한번에 ORACLE DB로 보내 처리하므로 수행 속도 향상
    - PL/SQL의 모든 요소는 하나 또는 두 개 이상의 블록으로 구성하여 모듈화 가능
    - 단순, 복잡한 데이터 형태의 변수 및 테이블의 데이터 구조와 컬럼명에 준하여 동적으로 변수 선언 가능
*/

-- * 간단하게 화면에 HELLO WORLD 출력

BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO WORLD');
END;
/
-- DBMS_OUTPUT 패키지에 포함되어 있는 PUT_LINE이라는 프로시저를 이용하여 출력하는 기능
-- END; 뒤의 '/' 기호는 PL/SQL 블록을 종결시킨다는 의미

-- 출력 안되는 이유 ?
-- 프로시저 사용 시 출력하는 내용을 화면에 보여주도록 하는 환경변수가 OFF여서 성공적으로 완료했습니다만 뜸
-- (기본값 OFF)
SET SERVEROUTPUT ON;

---------------------------------------------------------------------------------------------------
-- 1. DECLARE 선언부

-- 1) 타입 변수 선언
--    변수의 선언 및 초기화, 변수 값 ㅊ출력
--    [표현법] 변수명 자료형[(크기)];
DECLARE --> 선언부 시작을 알리는 구문
    EMP_ID NUMBER;
    EMP_NAME VARCHAR2(30);
    PI CONSTANT NUMBER := 3.14;
BEGIN --> 실행부 시작
    EMP_ID := 888;
    EMP_NAME := '배장남';
    
    -- 변수 출력(문자열 연결 연산자 ||)
    DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('PI : ' || PI);
END;
/

---------------------------------------------------------------------------------------------------
-- 2) 레퍼런스 변수의 선언과 초기화, 변수값 출력
-- [표현법] 변수명 테이블명.컬럼명%TYPE

DECLARE
    EMP_ID EMPLOYEE.EMP_ID%TYPE;
    --> 변수 EMP_ID의 타입을 EMPLOYEE 테이블의 EMP_ID 컬럼 타입으로 지정
    EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME
    INTO EMP_ID, EMP_NAME --> EMPLOYEE 테이블에서 EMP_ID, EMP_NAME을 내 EMP_ID, EMP_NAME에 집어넣겠다
    FROM EMPLOYEE
    WHERE EMP_ID = '&ID'; --> '&'기호가 있는 문자열은 대체 변수를 입력(값을 입력) 하라는 의미
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || EMP_NAME);
END;
/
------------------------------------------------------------------------------------
-- 3) 한 행에 대한 ROWTYPE 변수 선언과 초기화
-- [표현법] 변수명 테이블명%ROWTYPE;
DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = '&사원아이디';
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || E.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('EMP_NO : ' || E.EMP_NO);
    DBMS_OUTPUT.PUT_LINE('SALARY : ' || E.SALARY);
END;
/
    
------------------------------------실습 문제 --------------------------------------
-- 1. 레퍼런스 변수로 EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY를 선언하고 각 자료형은 EMPLOYEE 테이블의 각 컬럼 타입으로 지정
-- EMPLOYEE 테이블에서 사번, 이름, 직급코드, 부서코드 급여를 조회하고 선언한 
-- 레퍼런스 변수에 담아 각각 출력. 단, 입력받은 이름과 일치하는 조건의 직원을 조회
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
    WHERE EMP_ID = '&사원아이디';
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('DEPT_CODE : ' || DEPT_CODE);
    DBMS_OUTPUT.PUT_LINE('JOB_CODE : ' || JOB_CODE);
    DBMS_OUTPUT.PUT_LINE('SALARY : ' || SALARY);
END;
/

-- 2. ROWTYPE 벼수로 DEPARTMENT 테이블의 타입의 변수를 선언하고 입력받은 부서 코드와 
-- 일치하는 조건의 행을 선언한 ROWTYPE 변수에 담아 부서코드, 부서명, 지역코드 출력
DECLARE
    D DEPARTMENT%ROWTYPE;
BEGIN
    SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID
    INTO D
    FROM DEPARTMENT
    WHERE DEPT_ID = '&부서코드';
    
    DBMS_OUTPUT.PUT_LINE('DEPT_CODE : ' || D.DEPT_ID);
    DBMS_OUTPUT.PUT_LINE('DEPT_TITLE : ' || D.DEPT_TITLE);
    DBMS_OUTPUT.PUT_LINE('LOCATION_ID : ' || D.LOCATION_ID);
END;
/
    
-----------------------------------------------------------------------------------------
-- 2. BEGIN

-- **조건문**
-- 1) IF~THEN~END IF(단일 IF문)
-- EMP_ID를 입력받아 해당 사원의 사번, 이름, 급여, 보너스율을 출력
-- 단, 보너스를 받지 않는 사원은 보너스율 출력 전 '보너스를 지급받지 않는 사원입니다' 출력
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
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('보너스율 : ' || BONUS * 100 || '%');
END;
/
    
-- 2) IF~THEN~ELSE~END IF(IF~ELSE문)
-- EMP_ID를 입력받아 해당 사원의 사번, 이름, 부서명, 소속(NATIONAL_CODE)을 출력
-- TEAM 변수를 만들어 소속 'ko'인 사원은 '국내팀' 아니면 '해외팀'으로 출력
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
        THEN TEAM := '국내팀';
    ELSE TEAM:= '해외팀';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('DEPT_TITLE : ' || DEPT_TITLE);
    DBMS_OUTPUT.PUT_LINE('NATIONAL_CODE : ' || NATIONAL_CODE);
    DBMS_OUTPUT.PUT_LINE('라인 : ' || TEAM);
END;
/

----------------------------------------
--  3) IF~THEN~ELSIF~ELSE~END IF(IF~ELSE IF~ELSE문)

-- 점수를 입력받아 SCORE 변수에 저장하고 90점 이상은 'A', 80점 이상은 'B'
-- 70점 이상은 'C', 60점 이상은 'D', 60점 미만은 'F'로 조건 처리하여 GRADE 변수에 저장하고
-- '당신의 점수는 90점이고, 학점은 A학점입니다.' 형태로 출력하시오
DECLARE
    SCORE INT;
    --> INT : ANSI 타입의 자료형, 오라클 NUMBER(38)과 같은 타입
    GRADE VARCHAR2(2);
BEGIN
    SCORE := '&점수';
    
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
    
    DBMS_OUTPUT.PUT_LINE('당신의 점수는 ' || SCORE || '점이고 학점은' || GRADE || '학점입니다.');
END;
/

---------------------------------------------------------------------------------------------------
-- 4) CASE~WHEN~THEN~END (SWITCH문)
-- 사원 번호를 입력하여 해당 사원의 사번, 이름, 부서명 출력
DECLARE
    EMP EMPLOYEE%ROWTYPE;
    DNAME VARCHAR2(20);
BEGIN
    SELECT *
    INTO EMP
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    DNAME := CASE EMP.DEPT_CODE
                WHEN 'D1' THEN '인사관리부'
                WHEN 'D2' THEN '회계관리부'
                WHEN 'D3' THEN '마케팅부'
                WHEN 'D4' THEN '국내영업부'
                WHEN 'D5' THEN '해외영업1부'
                WHEN 'D6' THEN '해외영업2부'
                WHEN 'D7' THEN '해외영업3부'
                WHEN 'D8' THEN '기술지원부'
                WHEN 'D9' THEN '총무부'
             END;
    DBMS_OUTPUT.PUT_LINE('사번 이름   부서명');
    DBMS_OUTPUT.PUT_LINE(EMP.EMP_ID || ' ' || EMP.EMP_NAME || ' ' || DNAME);
END;
/

---------------------------------------------- 실습 문제------------------------------------------------
-- 1. 월을 입력받아 변수에 저장하고 1~3월은 '1분기', 4~6월은 '2분기', 7~9월은 '3분기', 10~12월은 '4분기',
-- 그 외에 숫자는 '잘못된 숫자 입력'으로 조건 처리하여 변수에 저장하고 '9월은 3분기입니다.' 형태로 출력
DECLARE
    MONTH INT;
    QUARTER VARCHAR2(30);
BEGIN
    MONTH := '&월';
    
    IF(MONTH >= 1 AND MONTH <= 3)
        THEN QUARTER := '1분기';
    ELSIF(MONTH >= 4 AND MONTH <= 6)
        THEN QUARTER := '2분기';
    ELSIF(MONTH >= 7 AND MONTH <= 9)
        THEN QUARTER := '3분기';
    ELSIF(MONTH >= 10 AND MONTH <= 12)
        THEN QUARTER := '4분기';
    ELSE QUARTER := '잘못된 숫자 입력';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(MONTH || '월은 ' || QUARTER || '입니다.');
END;
/
    
-- 2. 사원 번호를 입력하여 해당 사원의 사번, 이름, 직급명을 출력하시오
-- EMPLOYEE ROWTYPE변수와 CASE~WHEN~THEN~END 구문 이용
DECLARE
    EMP EMPLOYEE%ROWTYPE;
    JOBNAME VARCHAR2(30);
BEGIN
    SELECT *
    INTO EMP
    FROM EMPLOYEE
    WHERE EMP_ID = '&사원번호';
    
    JOBNAME := CASE EMP.JOB_CODE
                WHEN 'J1' THEN '대표'
                WHEN 'J2' THEN '부사장'
                WHEN 'J3' THEN '부장'
                WHEN 'J4' THEN '차장'
                WHEN 'J5' THEN '과장'
                WHEN 'J6' THEN '대리'
                WHEN 'J7' THEN '사원'
               END;
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EMP.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || EMP.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('직급명 : ' || JOBNAME);
END;
/
    
    

-- 3.입력받은 EMP_ID에 해당하는 사원의 연봉을 구해서 월급, 사원명, 연봉 출력
-- 단, 보너스가 있는 사원은 보너스도 포함해서 계산
DECLARE
    E EMPLOYEE%ROWTYPE;
    INCOME INT;
BEGIN
    SELECT *
    INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = '&사원번호';
    
    INCOME := (E.SALARY + (E.SALARY * NVL(E.BONUS, 0))) * 12;
    
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('월급 : ' || E.SALARY);
    DBMS_OUTPUT.PUT_LINE('연봉 : ' || INCOME);
END;
/

---------------------------------------------------------------------------------------------------------
-- ** 반복문 **

/*
    1) BASIC LOOP
       내부에 처리문을 작성하고 마지막에 LOOP로 벗어날 조건을 명시
       
    [표현식]
    LOOP
        처리문
        조건문
    END LOOP
    
    -> 조건문 (2가지 표현)
    1. IF 조건식 THEN EXIT; END IF;
    2. EXIT WHEN 조건식;
*/

DECLARE
    N NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
    
        N := N + 1;
    
--        IF N > 5 THEN EXIT; 
--        END IF;   -> 조건식 1
        EXIT WHEN N > 5; --> 조건식2
    END LOOP;
END;
/

--------------------------------------------------------------------------------------------
/*
    2) FOR LOOP
    
    [표현식]
    FOR 인덱스 IN [REVERSE] 초기값..최종값
    LOOP
        처리문
    END LOOP
*/
-- 1~5까지 순서대로 출력
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

-- 반복문을 이용한 데이터 삽입
-- 테이블 생성 후  순서대로 데이터 삽입
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

-- 중첩 LOOP
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
    [표현식]
    WHILE 조건
    LOOP
        처리문
    END LOOP;
*/

-- 1~5 순서대로 출력
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

-- WHILE문 곱셈
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

--------------------------실습문제--------------------
-- 1. FOR LOOP로 구구단 짝수단만 출력
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

-- 2. WHILE LOOP로 구구단 홀수 단만 출력
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
-- 타입 변수 선언

-- 테이블 타입 변수 선언 및 값 대입 출력
/*
    - 키와 값 쌍으로 이루어진 컬렉션(오라클 SQL의 테이블이 아님)
    - 하나의 테이블이 가지고 있는 한 컬럼의 데이터를 저장
    - 테이블 타입 변수의 크기 제한은 없으며 데이터가 들어옴에 따라 자동으로 증가함
    - BINARY_INDEX 타입(부호가 있는 숫자)의 인덱스 번호로 숫자가 정해짐

    [표현식]
    TYPE 테이블명 IS TABLE OF 데이터타입
    INDEX BY BINARY INTEGER;
*/

-- EMPLOYEE 테이블에
DECLARE
    -- 테이블 타입 선언
    -- EMPLOYEE.EMP_ID의 타입의 데이터를 저장할 수 있는 테이블 타입 변수
    -- EMP_ID_TABLE_TYPE 선언
    TYPE EMP_ID_TABLE_TYPE IS TABLE OF EMPLOYEE.EMP_ID%TYPE
    INDEX BY BINARY_INTEGER; --> 마치 Map<BINARY_INTEGER, VARCHAR2(3)> 와 같음
                             --> 혹은 일종의 일차원 배열
    -- EMPLOYEE,EMP_NAME의 타입의 데이터를 저장할 수 있는 테이블 타입 변수
    TYPE EMP_NAME_TABLE_TYPE IS TABLE OF EMPLOYEE.EMP_NAME%TYPE
    INDEX BY BINARY_INTEGER;
    
    -- 테이블 타입(EMP_ID_TABLE_TYPE) 변수 EMP_ID_TABLE 선언
    EMP_ID_TABLE EMP_ID_TABLE_TYPE;
    
    -- 테이블 타입(EMP_NAME_TABLE_TYPE) 변수 EMP_NAME_TABLE 선언
    EMP_NAME_TABLE EMP_NAME_TABLE_TYPE;
    
    -- BINARY_INTEGER 타입 변수 I 선언, 0 초기화
    I BINARY_INTEGER := 0;
BEGIN
    FOR K IN (SELECT EMP_ID, EMP_NAME FROM EMPLOYEE)
    -- K는 자동으로 선언되는 BINARY_INTEGER형 변수로 1부터 1씩 증가함
    LOOP
        I := I + 1;
        
        -- K에 접근 : SELECT문의 결과에 각 K번째 인덱스 값에 접근
        -- EMP_ID_TABLE, EMP_NAME_TABLE의 I번째 인덱스에 SELECT문 조회 결과의 K번째 인덱스의 EMP_ID, EMP_NAME 저장
        EMP_ID_TABLE(I) := K.EMP_ID;
        EMP_NAME_TABLE(I) := K.EMP_NAME;
    END LOOP;
    
    -- EMP_ID_TABLE, EMP_NAME_TABLE에 저장된 모든 값 출력
    FOR J IN 1..I
    LOOP
        DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP_ID_TABLE(J) || ', EMP_NAME : ' ||
                                EMP_NAME_TABLE(J));
    END LOOP;
END;
/

-- 레코드 타입의 변수 선언 및 값 대입 출력
/*
    - 기본 데이터 타입과 다른 복합형 구조를 갖는 PL/SQL이 제공하는 데이터 타입
    - 서로 다른 유형의 데이터를 한 줄로 나열한 형태의 데이터가 한 행(ROW)밖에 없는 테이블이라고 생각하면 편함.
    
    [표현식]
    TYPE 레코드명 IS RECORED(
        필드명 필드타입 [[NOT NULL] := DEFAULT값],
        필드명 필드타입 [[NOT NULL] := DEFAULT값],
        ...
    );
    레코드변수명 레코드명;
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
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EMP_RECORD.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || EMP_RECORD.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('부서 : ' || EMP_RECORD.DEPT_TITLE);
    DBMS_OUTPUT.PUT_LINE('직급 : ' || EMP_RECORD.JOB_NAME);
END;
/

---------------------------------------------------------------------------------------------------
-- 3. 예외처리부
/*
    예외(EXCEPTION) : 런타임 중 로직 처리간 발생하는 오류
    
    [표현식]
    EXCEPTION
        WHEN 예외명1 THEN 예외처리구문1
        WHEN 예외명2 THEN 예외처리구문2
        ...
        WHEN OTHERS THEN 예외처리구문N;
*/

/*
    1) 시스템 예외(미리 정의되어 있는 예외)
       오라클 내부에 미리 정의되어 있는 예외(PREDEFINED ORACLE SERVER, 약 20개)
       따로 선언할 필요 없이 발생 시 예외절에 자동 트랩됨
       
       대표적인 시스템 예외
       - NO_DATA_FOUND : SELECT문이 아무런 데이터 행을 반환하지 못할 때
       - TOO_MANY ROWS : 하나만 리턴해야 하는 SELECT문이 하나 이상의 행을 반환할 때
       - INVALID_CURSOR : 잘못된 커서 연선
       - ZERO_DIVIDE : 0으로 나눌때
       - DUP_VAL_ON_INDEX : UNIQUE 제약을 갖는 컬럼에 중복되는 데이터가 INSERT될 때
       
       OTHERS : 모든 예외처리
*/

-- 숫자를 0으로 나눌 경우 예외처리
DECLARE
    NUM NUMBER := 0;
BEGIN
    NUM := 10 / 0;
    DBMS_OUTPUT.PUT_LINE('SUCCESS!');

EXCEPTION
    --WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('ZERO_DIVIDE EXCEPTION 발생');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('EXCEPTION 발생'); --> 모든 예외처리
END;
/

-- UNIQUE 제약 조건 위배 시
BEGIN
    UPDATE EMPLOYEE
    SET EMP_ID = '&사번'
    WHERE EMP_ID = 201;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('이미 존재하는 사번입니다.');
END;
/

/*
    2) 사용자 정의 예외처리(제공되지 않는 예외처리)
       미리 정의된 예외를 제외한 모든 예외
       선언부에 선언 해야하고, 예외 발생 시 자동 트랩됨
       
       * 사용자 정의 예외처리 순서
       - STEP 1 : 예외 이름을 선언(DECLARE절)
       - STEP 2 : PRAGMA EXCEPTION_INIT 문장으로 예외의 이름과 오라클 오류번호 결합(DECLARE절에서)
                  PRAGMA : 컴파일러가 실행되기 전 전처리기 역할을 하는 키워드
                  오류번호 : 구글링...
       - STEP 3 : 예외가 발생할 경우 해당 예외를 참조(EXCEPTION절)
*/
-- 현재 EMAIL에 NOT NULL 제약 조건이 없어서 NULL값이 가능
-- 이메일을 수정할 때 값을 입력 안하게 되면 예외 발생하게 만들기
DECLARE
    NEWEMAIL EMPLOYEE.EMAIL%TYPE;
    DUP_EMAIL EXCEPTION; --> STEP 1
    PRAGMA EXCEPTION_INIT(DUP_EMAIL, -00001); --> STEP 2
BEGIN
    NEWEMAIL := '&이메일';
    
    IF NEWEMAIL IS NULL
        THEN RAISE DUP_EMAIL;
    ELSE
        UPDATE EMPLOYEE
        SET EMAIL = NEWEMAIL
        WHERE EMP_ID = 201;
    END IF;
EXCEPTION
    WHEN DUP_EMAIL THEN DBMS_OUTPUT.PUT_LINE('반드시 값을 입력해주세요');
    --> STEP 3
END;
/

-------------------------실습 문제-------------------------------------------
-- 1. EMPLOYEE 테이블에서 이름으로 검색하여 이름과 부서명과 지역명을 RECORD TYPE
-- 변수 하나에 담아 출력. 단, 이름에 해당하는 사원이 없으면 예외처리부에서 
-- '입력하신 이름에 해당하는 사원이 없습니다' 라고 출력
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
    WHERE EMP_NAME = '&사원명';
    
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || EMP.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('부서명 : ' || EMP.DEPT_TITLE);
    DBMS_OUTPUT.PUT_LINE('지역명 : ' || EMP.LOCAL_NAME);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('입력하신 이름에 해당하는 사원이 없습니다.');
END;
/

-- 2. 나이를 입력받고 입력받은 나이가 20세 이상이면 입장 가능합니다를 출력하고
-- 20 미만이면 UNDER_TWENTY라는 예외를 발생시켜 20세 미만은 입장 불가합니다를 출력
DECLARE
    AGE NUMBER;
    UNDER_TWENTY EXCEPTION;
    PRAGMA EXCEPTION_INIT(UNDER_TWENTY, -0000001);
BEGIN
    AGE := '&나이';
    
    IF AGE >= 20
        THEN DBMS_OUTPUT.PUT_LINE('입장 가능합니다');
    ELSE 
        RAISE UNDER_TWENTY;
    END IF;
EXCEPTION
    WHEN UNDER_TWENTY THEN DBMS_OUTPUT.PUT_LINE('20세 미만은 입장 불가합니다');
END;
/

set serveroutput on;