-- 함수(Function) : 컬럼의 값을 읽어서 계산한 결과를 리턴함

-- 단일행(SINGLE ROW) 함수 : 컬럼에 기록된 N개의 값을 읽어서 N개의 결과를 리턴
-- (테이블 조회에서 사용하면 각 행에 결과가 반영되는 함수)
-- 그룹(GROUP) 함수 : 컬럼에 기록된 N개의 값을 읽어서 한 개의 결과를 리턴
-- (행들을 그룹화하여 하나의 결과를 도출하는 함수)

-- SELECT 절에 단일행 함수와 그룹 함수를 함께 사용 못함 : 결과 행의 갯수가 다르기 때문
-- 함수를 사용할 수 있는 위치 : SELECT절, WHERE절, GROUP BY절, HAVING절, ORDER BY절

-- <단일행 함수>
-- 1. 문자 관련 함수
-- LENGTH / LENGTHB
-- 오라클 Express Edition은 한글을 3바이트로 인식한다.
-- LENGTH(컬럼명 | '문자열값') : 글자 수 반환
-- LENGTHB(컬럼명 | '문자열값') : 글자의 바이트 사이즈 반환
SELECT LENGTH('오라클'), LENGTHB('오라클')
FROM DUAL; -- DUMMY TABLE(가상 테이블)

-- DUAL 테이블이란 ? 
-- SYS 사용자가 소유하는 DUMMY(가상) 테이블
-- 한 행으로 결과를 출력하기 위한 테이블
-- 산술 연산의 결과나 가상 컬럼등의 값을 한번만 출력하려고 할 때 사용
-- SQL Funcition을 테스트해보기 위해 사용

SELECT LENGTH(EMAIL), LENGTHB(EMAIL)
FROM EMPLOYEE;

-------INSTR-------
-- INSTR('문자열' | 컬럼명, '문자', 찾을 위치의 시작값, [순번])
-- 찾을 문자의 위치 반환

SELECT INSTR('AABAACAABBAA', 'B') FROM DUAL;
SELECT INSTR('AABAACAABBAA', 'B', 1) FROM DUAL;
SELECT INSTR('AABAACAABBAA', 'B', -1) FROM DUAL;
SELECT INSTR('AABAACAABBAA', 'B', 1, 2) FROM DUAL;
SELECT INSTR('AABAACAABBAA', 'B', -1, 2) FROM DUAL;

SELECT EMAIL, INSTR(EMAIL, '@', -1, 1) AS "@ 위치" FROM EMPLOYEE; 

SELECT EMAIL, INSTR(EMAIL, 's',  1, 2) FROM EMPLOYEE;

------SUBSTR------
-- 컬럼이나 문자열에서 지정한 위치부터 지정한 개수의 문자열을 잘라내 반환
-- (자바의 String, SubString()과 같은 동작)
--> SUBSTR(STRING, POSITION, [LENGTH])
/*
STRING : 문자 타입 컬럼 또는 문자열
POSITION : 문자열을 잘라낼 위치로 양수면 시작 방향에서 지정한 수만큼 음수면 끝 방향에서 지정한 수만큼의 위치 의미
LENGTH : 반환할 문자 개수(생략 시 문자열의 끝까지 의미, 음수면 NULL 리턴)
*/
SELECT SUBSTR('SHOWMETHEMONEY', 5, 2) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', 7) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', 1, 6) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', -8, 3) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', -10, 2) FROM DUAL;
SELECT SUBSTR('쇼우 미 더 머니', 2, 5) FROM DUAL;

-- EMPLOYEE 테이블의 이름, 이메일, @이후를 제외한 아이디 조회
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@') - 1)
FROM EMPLOYEE;

-- 주민등록번호를 이용해 남/녀 판단
-- 주민등록번호에서 성별을 나타내는 부분만 잘라보기
SELECT EMP_NAME, SUBSTR(EMP_NO, 8, 1) FROM EMPLOYEE;

SELECT EMP_NAME, '남' AS 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = 1;

SELECT EMP_NAME, '여' AS 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = 2;

-- EMPLOYEE 테이블에서 직원들의 주민번호를 조회하여 생년, 생월, 생일을 각각 분리하여 조회
-- SELECT 사원명, 생년, 생월, 생일로 조회
SELECT EMP_NAME, SUBSTR(EMP_NO, 1, 2) AS 생년, SUBSTR(EMP_NO, 3, 2) AS 생월, SUBSTR(EMP_NO, 5, 2) AS 생일
FROM EMPLOYEE;
-- SUBSTR에서 뒤에꺼는 시작 기준으로 몇 개를 뽑아올 건지

-------------------LPAD/RPAD--------------------
--> ('문자열' | 컬럼명, 반환할 문자의 길이(바이트), [덧붙이려는 문자열])
-- 주어진 컬럼이나 문자열에 임의의 문자열을 왼쪽/오른쪽에 덧붙여 길이 N의 문자열을 반환
--> 통일감 있게, 보기 좋게 하기 위해 자주 사용
SELECT LPAD(EMAIL, 20) FROM EMPLOYEE;
-- 덧붙일 문자 생략 시 공백으로 처리
SELECT LPAD(EMAIL, 20, '#') FROM EMPLOYEE;
SELECT RPAD(EMAIL, 20) FROM EMPLOYEE;
-- 함수는 중첩 사용 가능함 : 함수 안에서 함수를 사용할 수 있음
-- EMPLOYEE 테이블에서 사원명, 주민번호 조회
-- 단, 주민번호는 생년월일만 보이게 하고, '-' 다음 값은 '*'로 바꿔라
SELECT EMP_NAME 사원명, RPAD(SUBSTR(EMP_NO,1,7), 14, '*') 주민번호
FROM EMPLOYEE;

-------LTRIM/RTRIM--------
--> ('문자열' | 컬럼명, [제거하려는 문자열])
-- 주어진 컬럼이나 문자열의 왼쪽 혹은 오른쪽에서 지정한 STR에 포함된 모든 문자를 제거한 나머지를 반환
SELECT EMP_NAME, LTRIM(PHONE, '010'), RTRIM(EMAIL, '@kh.or.kr') FROM EMPLOYEE;
-- *주의 ! STR에 포함된 문자 하나하나 읽음*
SELECT LTRIM('   KH') FROM DUAL; -- 문자열 생략시 공백으로 인식
SELECT LTRIM('ACABACCKH', 'ABC') FROM DUAL;
SELECT LTRIM('5782KH', '0123456789') FROM DUAL;

SELECT RTRIM('   KH') FROM DUAL; -- 문자열 생략시 공백으로 인식
SELECT RTRIM('ACABACCKH', 'ABC') FROM DUAL;
SELECT RTRIM('5782KH', '0123456789') FROM DUAL;

------TRIM-------
-- 주어진 컬럼이나 문자열의 앞/뒤/양쪽에 있는 지정한 문자를 제거
-- 캐릭터는 하나만 가능하다. 여러개 쓰려면 RTRIM/LTRIM 쓴다.
SELECT TRIM('   KH   ') FROM DUAL;
SELECT TRIM('Z' FROM 'ZZZKHZZZ') FROM DUAL;
-- TRIM할 CHAR의 위치 지정, 앞(LEADING)/뒤(TRAILING)/양쪽(BOTH) 지정 가능(기본 값 양쪽)
SELECT TRIM (LEADING '1' FROM '111KH111') FROM DUAL;
SELECT TRIM (TRAILING '1' FROM '111KH111') FROM DUAL;
SELECT TRIM (BOTH '1' FROM '111KH111') FROM DUAL;
-- 문자열 하나만 제거 가능. 여러개는 LTRIM, RTRIM 쓰기

----------------LOWER/UPPER/INITCAP--------------
-- LOWER(문자열 | 컬럼) : 소문자로 변경해주는 함수
SELECT LOWER('Welcome To My World') FROM DUAL;
-- UPPER
SELECT UPPER('Welcome To My World') FROM DUAL;
-- INITCAP(문자열 | 컬럼) : 각 어절의 앞글자만 대문자로 변경해주는 함수(Initial Capital. 대문자 초기화)
SELECT INITCAP('welcome to my world') FROM DUAL;

--------------CONCAT-----------------
-- 컬럼의 문자 혹은 문자열을 두개 전달받아 하나로 합친 후 반환
-- CONCAT(STRING, STRING)
-- ||와 같은 동작
SELECT CONCAT('가나다라', 'ABCD') FROM DUAL;
SELECT '가나다라' || 'ABCD' FROM DUAL;

--------------REPLACE----------------
-- 컬럼의 문자 혹은 문자열에서 특정 문자(열)을 지정한 문자(열)로 바꾼 후 반환
-- REPLACE(STRING, STR1, STR2)
SELECT REPLACE('서울시 강남구 역삼동', '역삼동', '삼성동') FROM DUAL;
SELECT REPLACE('sun_di@kh.or.kr', '@kh.or.kr', '@gmail.com') FROM DUAL;


-- 2. 숫자 관련 함수

-----------ABS----------
-- (숫자 | 숫자로 된 컬럼명) : 절대값을 구하여 리턴하는 함수
SELECT ABS(-10) FROM DUAL;
SELECT ABS(-10.9) FROM DUAL;

-----------MOD-----------
-- (숫자 | 숫자로 된 컬럼명, 숫자 | 숫자로 된 컬럼명) : 두 수를 나누어 나머지를 구하는 함수
-- 처음 인자는 나누어지는 수, 두 번째 인자는 나눌 수
SELECT MOD(10, 3) FROM DUAL;
SELECT MOD(10.9, 3) FROM DUAL;

-----------ROUND----------
-- (숫자 | 숫자로 된 컬럼명, [위치]) : 반올림하여 리턴하는 함수
SELECT ROUND(123.456) FROM DUAL;
SELECT ROUND(123.456, 0) FROM DUAL;
SELECT ROUND(123.456, 1) FROM DUAL;
SELECT ROUND(123.456, 2) FROM DUAL;
SELECT ROUND(123.456, -2) FROM DUAL;

-----------FLOOR---------
-- (숫자 | 숫자로 된 컬럼명) : 내림처리 하는 함수
SELECT FLOOR(123.456) FROM DUAL;
SELECT FLOOR(123.678) FROM DUAL;

-----------TRUNC--------- (truncation 끝을 잘라내다)
-- (숫자 | 숫자로 된 컬럼명, [위치]) : 내림처리 하는 함수
SELECT TRUNC(123.456) FROM DUAL;
SELECT TRUNC(123.678) FROM DUAL;
SELECT TRUNC(123.456, 1) FROM DUAL;
SELECT TRUNC(123.456, 2) FROM DUAL;
SELECT TRUNC(123.456, -2) FROM DUAL;

------------CEIL-------------
SELECT CEIL(123.456) FROM DUAL;
SELECT CEIL(123.678) FROM DUAL;

SELECT ROUND(123.456), FLOOR(123.456), TRUNC(123.456), CEIL(123.456) FROM DUAL;
-- ROUND 반올림, FLOOR 내림, TRUNC 내림이지만 내림 위치 지정 가능, CEIL 올림


-- 3. 날짜 관련 함수

--------SYSDATE-----------
-- 시스템에 저장되어 있는 날짜를 반환하는 함수
SELECT SYSDATE FROM DUAL;

--------MONTHS_BETWEEN(날짜, 날짜) : 개월 수의 차이를 숫자로 리턴하는 함수-------
SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) || '개월차' AS 근속월 FROM EMPLOYEE;

--------ADD_MONTHS(날짜, 숫자) : 날짜에 숫자만큼 개월수를 더하여 날짜를 리턴--------
SELECT ADD_MONTHS(SYSDATE, 5) FROM DUAL;
-- EMPLOYEE 테이블에서 사원의 이름, 입사일, 입사 후 6개월이 된 날짜 조회
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 6)
FROM EMPLOYEE;

---------NEXT_DAY(기준 날짜, 요일(문자 | 숫자)) -> 숫자의 경우 1 = 일요일, ....., 7  = 토요일-----------
-- 기준 날짜에서 구하려는 요일의 가장 가까운 날짜를 리턴하는 함수
SELECT SYSDATE, NEXT_DAY(SYSDATE, '목요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 5) FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '목') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'THURSDAY') FROM DUAL;

ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'THURSDAY') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '목요일') FROM DUAL;
ALTER SESSION SET NLS_LANGUAGE = KOREAN;

---------LAST_DAY(날짜) : 해당 월의 마지막 날짜를 구하여 리턴---------
SELECT SYSDATE, LAST_DAY(SYSDATE) FROM DUAL;

-----------실습 문제----------
-- 1. EMPLOYEE 테이블에서 사원명, 입사일-오늘, 오늘-입사일 조회
-- 단, 별칭은 근무일수1, 근무일수2로 하고 모두 정수처리, 양수가 되도록 처리
SELECT EMP_NAME, CEIL(HIRE_DATE - SYSDATE) AS 근무일수1, CEIL(SYSDATE - HIRE_DATE) AS 근무일수2 
FROM EMPLOYEE;

-- 2. EMPLOYEE 테이블에서 사번이 홀수인 직원들의 정보 모두 조회
SELECT * FROM EMPLOYEE WHERE MOD(EMP_ID, 2) = 1 ;

-- 3. EMPLOYEE 테이블에서 근무 년수가 20년 이상인 직원 정보 조회
SELECT * FROM EMPLOYEE WHERE MONTHS_BETWEEN(SYSDATE, HIRE_DATE) >= 240;

-- 4. EMPLOYEE 테이블에서 사원명, 입사일, 입사한 월의 근무 일수(주말 포함)를 조회
SELECT EMP_NAME, HIRE_DATE, CEIL(LAST_DAY(HIRE_DATE)-HIRE_DATE) AS "입사월 근무일수" FROM EMPLOYEE;

------------------------------------
-- EXTRACT : 년, 월, 일 정보를 추출하여 리턴------------------
-- EXTRACT(YEAR FROM 날짜) : 년도만 추출--------------------
-- EXTRACT(MONTH FROM 날짜) : 월만 추출--------------
-- EXTRACT(DAY FROM 날짜) : 일만 추출-----------------
-- EMPLOYEE 테이블에서 사원의 이름, 입사 년, 입사 월, 입사 일 조회---------------
SELECT EMP_NAME 사원이름,
    EXTRACT(YEAR FROM HIRE_DATE) 입사년도,
    EXTRACT(MONTH FROM HIRE_DATE) 입사월,
    EXTRACT(DAY FROM HIRE_DATE) 입사일
FROM EMPLOYEE;
-- ORDER BY EMP_NAME ASC;
-- ORDER BY EMP_NAME DESC;
-- ORDER BY 사원이름;
-- ORDER BY 1; -- 사원이름 기준인듯
-- ORDER BY 입사년도 ASC, 사원이름 DESC; -- 입사년도를 기준으로 오름차순 하되, 입사년도가 같다면 사원이름으로 내림차순

-- EMPLOYEE 테이블에서 사원의 이름, 입사일, 근무년수 조회
-- 1) (현재년도 - 입사년도)로 조회
SELECT EMP_NAME, HIRE_DATE, EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) "근무년수"
FROM EMPLOYEE;
-- 2) MONTHS_BETWEEN으로 근무년수 조회
SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12) AS "근무년수" 
FROM EMPLOYEE;

-- 날짜 포맷 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'RR-MM-DD'; --YY가 아닌 RR을 씀 ( 이유 밑에 적음)
ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';

-------------------------4. 형변환 함수-------------
-- 이건 하나하나 다 봐야할 듯
-- TO_CHAR(날짜, [포맷]) : 날짜형 데이터를 문자형 데이터로 변경
-- TO_CHAR(숫자, [포맷]) : 숫자형 데이터를 문자형 데이터로 변경
SELECT TO_CHAR(1234) FROM DUAL;
SELECT TO_CHAR(1234, '99999') FROM DUAL; -- 5칸 잡고 오른쪽 정렬, 빈칸 공백
SELECT TO_CHAR(1234, '00000') FROM DUAL; -- 5칸 잡고 오른쪽 정렬, 빈칸 0으로 채움
SELECT TO_CHAR(1234, 'L99999') FROM DUAL; -- 현재 설정된 나라의 화페 단위 설정
SELECT TO_CHAR(1234, '$99999') FROM DUAL; -- $라는 화폐 단위 설정
SELECT TO_CHAR(1234, '99,999') FROM DUAL; -- 금액에서 자릿수에 콤마 찍음
SELECT TO_CHAR(1234, '00,000') FROM DUAL; -- 금액에서 자릿수에 콤마 찍되 앞을 0으로 채움
SELECT TO_CHAR(1234, '999') FROM DUAL; -- 자릿수가 부족하면 표현되지 않는다
-- 0, 9, 'L', '$', ',', 숫자 크기

-- EMPLOYEE 테이블에서 사원명, 급여 조회
-- 급여는 원화 형식 표시
SELECT EMP_NAME, TO_CHAR(SALARY, 'L999,999,999')
FROM EMPLOYEE;

-- 날짜 데이터 포맷 적용시에도 TO_CHAR 함수 사용 --
SELECT TO_CHAR(SYSDATE, 'PM HH24:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'AM HH:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MON, DY, YYYY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY-fmMM-DD DAY') FROM DUAL; -- fm이 붙으면 한 자리 숫자일 때 0 없앰
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-fmDD DAY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YEAR, Q') || '분기' FROM DUAL; -- 잘 모르겠음 ???
SELECT TO_CHAR(SYSDATE, 'YYYY-fmMM-DD DAY PM HH24:MI:SS') FROM DUAL;
SELECT EMP_NAME , TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일"')
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE 기존입사일, TO_CHAR(HIRE_DATE, 'YYYY/MM/DD HH24:MI:SS')
FROM EMPLOYEE;

-- 년도에 대한 포맷 문자는 'Y', 'R'이 있음--
SELECT TO_CHAR(SYSDATE, 'YYYY'), TO_CHAR(SYSDATE, 'RRRR'), TO_CHAR(SYSDATE, 'YY'), TO_CHAR(SYSDATE, 'RR')
FROM DUAL;
-- RR은 두자리 년도를 네자리로 바꿀 때 바꿀 년도가 50 미만이년 2000년을 적용, 50 이상이면 1900년을 적용
-- YY는 무조건 2000년대 적용

-- 오늘 날짜에서 월만 출력 처리---
SELECT TO_CHAR(SYSDATE, 'MM'), TO_CHAR(SYSDATE, 'MONTH'), TO_CHAR(SYSDATE, 'MON'), TO_CHAR(SYSDATE, 'RM') -- RM은 로마 표기
FROM DUAL;

-- 오늘 날짜에서 일만 출력---
SELECT TO_CHAR(SYSDATE, '"1년기준" DDD "일째"'), TO_CHAR(SYSDATE, '"달기준" DD "일째"'), TO_CHAR(SYSDATE, '"주 기준" D "일째"')
FROM DUAL;

-- EMPLOYEE 테이블에서 이름, 입사일 조회
-- 입사일은 포맷 적용한 '2019년 09월 17일 (화)' 형식으로 출력
SELECT EMP_NAME, TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일" "("DY")"')
FROM EMPLOYEE;

-- TO_DATE : 문자형 데이터를 날짜형 데이터로 변환하여 리턴---
-- TO_DATE(문자형 데이터, [포맷]) : 문자형 데이터를 날짜로 변경---
-- TO_DATE(숫자형 데이터, [포맷]) : 숫자형 데이터를 날짜로 변경---
SELECT TO_DATE('20100101', 'RRRRMMDD') FROM DUAL;
SELECT TO_DATE(20100101, 'YYYYMMDD') FROM DUAL;
SELECT TO_CHAR(TO_DATE('20100101', 'YYYYMMDD'), 'YYYY, MON') FROM DUAL;

SELECT TO_CHAR(TO_DATE('980630', 'YYMMDD'), 'YYYYMMDD') FROM DUAL;
SELECT TO_CHAR(TO_DATE('140918', 'YYMMDD'), 'YYYYMMDD') FROM DUAL;

SELECT TO_CHAR(TO_DATE('980630', 'YYMMDD'), 'RRRRMMDD') FROM DUAL;
SELECT TO_CHAR(TO_DATE('140918', 'RRMMDD'), 'RRRRMMDD') FROM DUAL;

-- TO_NUMBER(문자데이터, [포맷]) : 문자형 데이터를 숫자 데이터로----
SELECT TO_NUMBER('123456789') FROM DUAL;
SELECT '123' + '456' FROM DUAL; -- 숫자로 자동 형 변환되어 숫자로 합친 결과가 나온다. 문자 입력시 에러 발생
SELECT '1,000,0000' + '550,000' FROM DUAL;
SELECT TO_NUMBER('1,000,000', '99,999,999') + TO_NUMBER('550,000', '999,999') FROM DUAL;

-- TO_CHAR, TO_DATE, TO_NUMBER

----------5. NULL 처리 함수--------
-- NVL(컬럼명, 컬럼값이 NULL일 때 바꿀 값)--
SELECT EMP_NAME, BONUS, NVL(BONUS, 0)
FROM EMPLOYEE;
SELECT EMP_NAME, DEPT_CODE, NVL(DEPT_CODE, '00')
FROM EMPLOYEE;

-- NVL2(컬럼명, 바꿀값1, 바꿀값2) ---
-- 해당 컬럼의 값이 있으면 바꿀값1, NULL이면 바꿀값2로 변경
-- EMPLOYEE 테이블에서 보너스가 NULL인 직원은 0.5로, NULL이 아닌 경우 0.7로 변경
SELECT EMP_NAME, BONUS, NVL2(BONUS, 0.7, 0.5)
FROM EMPLOYEE;

-- NULLIF(비교대상1, 비교대상2) ---
-- 두개의 값이 동일하면 NULL, 그렇지 않으면 비교대상1을 리턴
SELECT NULLIF('123', '123') FROM DUAL;
SELECT NULLIF('123', '1234') FROM DUAL;

----6. 선택 함수 ----
-- 여러가지 경우에 선택을 할 수 있는 기능 제공.
-- DECODE(계산식 | 컬럼명, 조건값1, 선택값1, 조건값2, 선택값2 ...)
-- 비교하고자 하는 값 또는 컬럼이 조건식과 같으면 결과 값 반환
-- 일치하는 값을 확인(자바의 SWITCH와 비슷함)
SELECT EMP_ID, EMP_NAME, EMP_NO, DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') 성별
FROM EMPLOYEE;

-- 마지막 인자로 조건값 없이 선택값을 작성하면 아무것도 해당하지 않을 때 마지막에 작성한 값을 무조건 선택

-- 직원의 급여를 인상
-- 직급코드가 J7이면 10% 인상
-- 직급코드가 j6이면 15% 인상
-- 직급코드가 J5이면 20% 인상
-- 그 외 직급의 직원은 5%만 인상
SELECT EMP_NAME, JOB_CODE, SALARY, 
DECODE(JOB_CODE, 
    'J7', SALARY * 1.1, 
    'J6', SALARY * 1.15, 
    'J5', SALARY * 1.2,
    SALARY * 1.05) 인상급여
FROM EMPLOYEE;
-- 해당하는 값이 없으면 NULL 리턴

-- CASE WHEN 조건식 THEN 결과값
--      WHEN 조건식 THEN 결과값
--      ELSE 결과값 END (별칭 가능)
SELECT EMP_ID, EMP_NAME, EMP_NO,
    CASE WHEN SUBSTR(EMP_NO, 8, 1) = 1 THEN '남'
        ELSE '여'
    END 성별
FROM EMPLOYEE;

SELECT EMP_NAME, SALARY,
    CASE WHEN SALARY > 5000000 THEN '1등급'
        WHEN SALARY > 3500000 THEN '2등급'
        WHEN SALARY > 2000000 THEN '3등급'
        ELSE '4등급'
        END 등급
FROM EMPLOYEE;

-- 직원 급여 인상 CASE WHEN구문으로 변경
SELECT  EMP_NAME, JOB_CODE, SALARY, 
    CASE WHEN JOB_CODE = 'J7' THEN SALARY * 1.1
        WHEN JOB_CODE = 'J6' THEN SALARY * 1.15
        WHEN JOB_CODE = 'J5' THEN SALARY * 1.2
        ELSE SALARY * 1.05
        END 인상급여
FROM EMPLOYEE;

-------------------------------------------------------------
----------------------그룹 함수--------------------------------
-- <그룹 함수> --
-- 하나 이상의 행을 그룹으로 묶어 연산하며 총합, 평균 등의 하나의 결과를 반환하는 함수
-- SUM, AVG, MIN, MAX, COUNT

-- SUM(숫자가 기록된 컬럼명) : 합계를 구하여 리턴 --------
-- EMPLOYEE 테이블에서 전 사원의 급여 총합 조회
SELECT SUM(SALARY)
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 남자 사원의 급여 총합 조회
SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = 1;

-- EMPLOYEE 테이블에서 부서 코드가 D5인 직원의 보너스 포함 연봉 조회
SELECT SUM((SALARY + (SALARY * NVL(BONUS, 0))) * 12)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

------- AVG(숫자가 기록된 컬럼명) : 평균을 구하여 리턴 ---------

-- EMPLOYEE 테이블에서 전 사원의 급여 평균 조회
SELECT AVG(SALARY)
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 전 사원의 보너스 평균을 소수 셋째자리에서 반올림 한 것 조회
-- BONUS가 NULL인 사원은 0으로 처리
SELECT ROUND(AVG(NVL(BONUS, 0)), 2)
FROM EMPLOYEE;
-- *NVL을 하지 않을시 NULL 값을 가진 행은 평균 계산에서 제외되어 계산되기에 결과가 크게 달라진다
SELECT ROUND(AVG(BONUS), 2)
FROM EMPLOYEE;

SELECT AVG(BONUS) 기본평균,
    AVG(DISTINCT BONUS) 중복제거평균,
    AVG(NVL(BONUS, 0)) NULL포함평균
FROM EMPLOYEE;

-- MIN(컬럼명) : 컬럼에서 가장 작은 값 리턴
-- 취급하는 자료형은 ANY TYPE임

-- EMPLOYEE 테이블에서 알파벳 순위가 가장 빠른 이메일, 가장 빠른 입사일, 가장 낮은 급여 조회
SELECT MIN(EMAIL), MIN(HIRE_DATE), MIN(SALARY)
FROM EMPLOYEE;

-- MAX(컬럼명) : 컬럼에서 가장 큰 값 리턴
-- 취급하는 자료형은 ANY TYPE임

-- EMPLOYEE 테이블에서 사번 200번 제외하고
-- 알파벳 순위가 가장 늦는 이메일, 가장 최근 입사일, 가장 높은 급여 조회
SELECT MAX(EMAIL), MAX(HIRE_DATE), MAX(SALARY)
FROM EMPLOYEE
WHERE EMP_ID <> 200;

-- COUNT(* | 컬럼명) : 행 개수를 헤아려서 리턴
-- COUNT([DISTINCT] 컬럼명) : 중복을 제거한 행 개수를 헤아려서 리턴
-- COUNT(*) : NULL을 포함한 전체 행 개수를 리턴
-- COUNT(컬럼명) : NULL을 제외한 실제 값이 기록된 행 개수 리턴

-- EMPLOYEE 테이블에서 전체 사원 수, 부서코드가 있는 사원 수, 사원들이 속해있는 부서의 수 조회
SELECT COUNT(*), COUNT(DEPT_CODE), COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;

-- 함수(Function) :  컬럼의 값을 읽어서 계산한 결과를 리턴함

-- 단일행(SINGLE ROW) 함수 : 컬럼에 기록 된 N개의 값을 읽어서 N개의 결과를 리턴
-- (테이블 조회에서 사용하면 각 행에 결과가 반영되는 함수)
-- 그룹 (GROUP) 함수 : 컬럼에 기록된 N개의 값을 읽어서 한 개의 결과를 리턴
-- (행들을 그룹화하여 하나의 결과를 도출하는 함수)

-- SELECT 절에 단일행 함수와 그룹 함수를 함께 사용 못함 : 결과 행의 갯수가 다르기 때문

-- 함수를 사용할 수 있는 위치 : SELECT절, WHERE절, 
--                          GROUP BY절, HAVING절, ORDER BY절

-- < 단일행 함수 >
-- 1. 문자 관련 함수

-- *** LENGTH / LENGTHB ***
/*
    오라클 Express Edition은 한글을 3바이트로 인식
    LENGTH(컬럼명 | '문자열값') : 글자 수 반환
    LENGTHB(컬럼명 | '문자열값') : 글자의 바이트 사이즈 반환
*/

SELECT LENGTH('오라클'), LENGTHB('오라클')
FROM DUAL; -- DUMMY TABLE(가상 테이블)

-- DUAL 테이블이란?
-- SYS 사용자가 소유하는 DUMMY(가상) 테이블
-- 한 행으로 결과를 출력하기 위한 테이블
-- 산술 연산의 결과나 가상 컬럼등의 값을 한번만 출력하려고 할 때 사용
-- SQL Function 을 테스트해보기 위해 사용

SELECT LENGTH(EMAIL), LENGTHB(EMAIL)
FROM EMPLOYEE;

-- *** INSTR ***
--> INSTR('문자열' | 컬럼명, '문자', 찾을 위치의 시작값, [순번])

SELECT INSTR('AABAACAABBAA', 'B') FROM DUAL;
-- 1번 인덱스부터 찾아라
SELECT INSTR('AABAACAABBAA', 'B', 1) FROM DUAL;
-- 음수의 절대값만큼 왼쪽으로 이동 후 왼쪽으로 검색을 시작하라
SELECT INSTR('AABAACAABBAA', 'B', -1) FROM DUAL;
-- 1번 인덱스부터 두번째 위치의 B를 찾아라
SELECT INSTR('AABAACAABBAA', 'B', 1, 2) FROM DUAL;
-- 맨끝 인덱스부터 왼쪽으로 이동하며 두번째 B를 찾아라
SELECT INSTR('AABAACAABBAA', 'B', -1, 2) FROM DUAL;

SELECT EMAIL, INSTR(EMAIL, '@', -1, 1) "@ 위치"
FROM EMPLOYEE;

SELECT EMAIL, INSTR(EMAIL, 's', 1, 2) "두번째 s 위치"
FROM EMPLOYEE;
--------------------------------------------------------------------------------------------
-- ** SUBSTR ***
-- 컬럼이나 문자열에서 지정한 위치부터 지정한 개수의 문자열을 잘라내어 반환
-- (자바의 String.subString()과 같은 동작)
--> SUBSTR(STRING, POSITION, [LENGTH])
/*
STRING : 문자 타입 컬럼 또는 문자열
POSITION : 문자열을 잘라낼 위치로 양수면 시작 방향에서 지정한 수만큼,
           음수면 끝 방향에서 지정한 수만큼의 위치 의미
LENGTH : 반환할 문자 개수(생략 시 문자열의 끝까지 의미, 음수면 NULL 리턴)
*/

SELECT SUBSTR('SHOWMETHEMONEY', 5, 2) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', 7) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', 1, 6) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', -8, 3) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', -10, 2) FROM DUAL;
SELECT SUBSTR('쇼우 미 더 머니', 2, 5) FROM DUAL;

-- EMPLOYEE 테이블의 이름, 이메일, @이후를 제외한 아이디 조회
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')-1)
FROM EMPLOYEE;

-- 주민등록번호를 이용하여 남/녀 판단
-- 주민번호에서 성별을 나타내는 부분만 잘라보기
SELECT EMP_NAME, SUBSTR(EMP_NO, 8, 1)
FROM EMPLOYEE;

SELECT EMP_NAME, '남' 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) = 1;

SELECT EMP_NAME, '여' 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) = 2;

-- EMPLOYEE 테이블에서 직원들의 주민번호를 조회하여
-- 생년, 생월, 생일을 각각 분리하여 조회하시오
-- SELECT 사원명, 생년, 생월, 생일로 조회
SELECT EMP_NAME 사원명,
      SUBSTR(EMP_NO, 1, 2) 생년,
      SUBSTR(EMP_NO, 3, 2) 생월,
      SUBSTR(EMP_NO, 5, 2) 생일
FROM EMPLOYEE;
-------------------------------------------------------------------------------------------
-- *** LPAD / RPAD ***
--> ('문자열' | 컬럼명, 반환할 문자의 길이(바이트), [덧붙이려는 문자열])
-- 주어진 컬럼이나 문자열에 임의의 문자열을 왼쪽 / 오른쪽에 덧붙여 길이 N의 문자열을 반환
--> 통일감 있게, 보기 좋게 하기 위해 자주 사용
SELECT LPAD(EMAIL, 20)
FROM EMPLOYEE;
-- 덧붙일 문자열 생략 시 공백으로 처리

SELECT LPAD(EMAIL, 20, '#')
FROM EMPLOYEE;

SELECT RPAD(EMAIL, 20, '#')
FROM EMPLOYEE;

-- 함수는 중첩 사용 가능함 : 함수 안에서 함수를 사용할 수 있음
-- EMPLOYEE 테이블에서 사원명, 주민번호 조회
-- 단, 주민번호는 생년월일만 보이게 하고, '-' 다음 값은 '*'로 바꿔라
SELECT EMP_NAME 사원명,
       RPAD(SUBSTR(EMP_NO,1,7), 14, '*') 주민번호
FROM EMPLOYEE;
-------------------------------------------------------------------------------------
-- *** LTRIM / RTRIM ***
--> ('문자열' | 컬럼명, [제거하려는 문자열])
-- 주어진 컬럼이나 문자열의 왼쪽 혹은 오른쪽에서 지정한 STR에 포함된 모든 문자를 제거한 나머지를 반환
SELECT EMP_NAME, LTRIM(PHONE, '010'), RTRIM(EMAIL, '@kh.or.kr')
FROM EMPLOYEE;

-- 주의!! STR에 포함된 문자 하나하나 읽음!!
SELECT LTRIM('   KH') FROM DUAL; -- 문자열 생략시 공백으로 인식
SELECT LTRIM('ACABACCKHABC', 'ABC') FROM DUAL;
SELECT LTRIM('5782KH5782', '0123456789') FROM DUAL;

SELECT RTRIM('   KH') FROM DUAL; -- 문자열 생략시 공백으로 인식
SELECT RTRIM('ACABACCKHABC', 'ABC') FROM DUAL;
SELECT RTRIM('5782KH5782', '0123456789') FROM DUAL;

-- *** TRIM ***
-- 주어진 컬럼이나 문자열의 앞/뒤/양쪽에 있는 지정한 문자를 제거
SELECT TRIM('   KH   ') FROM DUAL;
SELECT TRIM('Z' FROM 'ZZZKHZZZ') FROM DUAL;

-- TRIM할 CHAR의 위치 지정, 앞(LEADING)/뒤(TRAILING)/양쪽(BOTH) 지정 가능(기본 값 양쪽)
SELECT TRIM (LEADING '1' FROM '111KH111') FROM DUAL;
SELECT TRIM (TRAILING '1' FROM '111KH111') FROM DUAL;
SELECT TRIM (BOTH '1' FROM '111KH111') FROM DUAL;
----------------------------------------------------------------------------------------------
-- *** LOWER / UPPER / INITCAP ***
-- LOWER(문자열 | 컬럼) : 소문자로 변경해주는 함수
SELECT LOWER('Welcome To My World') FROM DUAL;
-- UPPER(문자열 | 컬럼) : 대문자로 변경해주는 함수
SELECT UPPER('Welcome To My World') FROM DUAL;
-- INITCAP(문자열 | 컬럼) : 앞글자만 대문자로 변경해주는 함수
SELECT INITCAP('welcome to my world') FROM DUAL;

------------------------------------------------------------------------------------------------
-- *** CONCAT ***
-- 컬럼의 문자 혹은 문자열을 두개 전달 받아 하나로 합친 후 반환
-- CONCAT(STRING, STRING)
SELECT CONCAT('가나다라', 'ABCD') FROM DUAL;

-- ||와 같은 동작
SELECT '가나다라' || 'ABCD' FROM DUAL;
-----------------------------------------------------------------------------
-- *** REPLACE ***
-- 컬럼의 문자 혹은 문자열에서 특정 문자(열)을 지정한 문자(열)로 바꾼 후 반환
-- REPLACE(STRING, STR1, STR2)
SELECT REPLACE('서울시 강남구 역삼동', '역삼동', '삼성동')
FROM DUAL;

SELECT REPLACE('sun_di@kh.or.kr', '@kh.or.kr', '@gmail.com') FROM DUAL;
------------------------------------------------------------------------------------------------
-- 2. 숫자 처리 함수
-- *** ABS ***
-- (숫자 | 숫자로 된 컬럼명) : 절대값을 구하여 리턴하는 함수
SELECT ABS(-10) FROM DUAL;
SELECT ABS(-10.9) FROM DUAL;

-- *** MOD ***
-- (숫자 | 숫자로 된 컬럼명, 숫자 | 숫자로 된 컬럼명) : 두 수를 나누어서 나머지를 구하는 함수
-- 처음 인자는 나누어지는 수, 두번째 인자는 나눌 수
SELECT MOD(10, 3) FROM DUAL;
SELECT MOD(10.9, 3) FROM DUAL;
-------------------------------------------------------------------------------------
-- *** ROUND ***
-- (숫자 | 숫자로 된 컬럼명, [위치]) : 반올림하여 리턴하는 함수
SELECT ROUND(123.456) FROM DUAL;
SELECT ROUND(123.456, 0) FROM DUAL;
SELECT ROUND(123.456, 1) FROM DUAL;
SELECT ROUND(123.456, 2) FROM DUAL;
SELECT ROUND(123.456, -2) FROM DUAL;

-- *** FLOOR ***
-- (숫자 | 숫자로 된 컬럼명) : 내림처리 하는 함수
SELECT FLOOR(123.456) FROM DUAL;
SELECT FLOOR(123.678) FROM DUAL;

-- *** TRUNC ***
-- (숫자 | 숫자로 된 컬럼명, [위치]) : 내림처리 하는 함수
SELECT TRUNC(123.456) FROM DUAL;
SELECT TRUNC(123.678) FROM DUAL;
SELECT TRUNC(123.456, 1) FROM DUAL;
SELECT TRUNC(123.456, 2) FROM DUAL;
SELECT TRUNC(123.456, -2) FROM DUAL;

-- *** CEIL ***
-- (숫자 | 숫자로 된 컬럼명) : 올림처리하는 함수
SELECT CEIL(123.456) FROM DUAL;
SELECT CEIL(123.678) FROM DUAL;

SELECT ROUND(123.456),
       FLOOR(123.456),
       TRUNC(123.456),
       CEIL(123.456)
FROM DUAL;
---------------------------------------------------------------------------------------
-- 3. 날짜 처리 함수
-- SYSDATE : 시스템에 저장되어 있는 날짜를 반환하는 함수
SELECT SYSDATE FROM DUAL;

-- MONTHS_BETWEEN(날짜, 날짜) : 개월 수의 차이를 숫자로 리턴하는 함수
-- EMPLOYEE 테이블에서 사원의 이름, 입사일, 근무 개월 수를 조회
SELECT EMP_NAME, HIRE_DATE, MONTHS_BETWEEN(SYSDATE, HIRE_DATE)
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) || '개월차'
FROM EMPLOYEE;

-- ADD_MONTHS(날짜, 숫자) : 날짜에 숫자만큼 개월수를 더하여 날짜를 리턴
SELECT ADD_MONTHS(SYSDATE, 5) FROM DUAL;

-- EMPLOYEE 테이블에서 사원의 이름, 입사일, 입사 후 6개월이 된 날짜 조회
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 6)
FROM EMPLOYEE;

-- NEXT_DAY(기준 날짜, 요일(문자 | 숫자)) --> 숫자의 경우 1 = 일요일, ..., 7 = 토요일
-- 기준 날짜에서 구하려는 요일의 가장 가까운 날짜를 리턴하는 함수
SELECT SYSDATE, NEXT_DAY(SYSDATE, '목요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 5) FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '목') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'THURSDAY') FROM DUAL; -- 에러

ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'THURSDAY') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '목요일') FROM DUAL; -- 에러
ALTER SESSION SET NLS_LANGUAGE = KOREAN;

-- LAST_DAY(날짜) : 해당 월의 마지막 날짜를 구하여 리턴
SELECT SYSDATE, LAST_DAY(SYSDATE) FROM DUAL;

------------------------------------- 실습 문제 ------------------------------------------
-- 1. EMPLOYEE 테이블에서 사원명, 입사일-오늘, 오늘-입사일 조회
-- 단, 별칭은 근무일수1, 근무일수2로 하고
-- 모두 정수처리, 양수가 되도록 처리
SELECT EMP_NAME, 
       FLOOR(ABS(HIRE_DATE - SYSDATE)) "근무일수1", 
       FLOOR(ABS(SYSDATE - HIRE_DATE)) "근무일수2"
FROM EMPLOYEE;
-- 2. EMPLOYEE 테이블에서 사번이 홀수인 직원들의 정보 모두 조회
SELECT *
FROM EMPLOYEE
WHERE MOD(EMP_ID, 2) = 1;
-- 3. EMPLOYEE 테이블에서 근무 년수가 20년 이상인 직원 정보 조회
SELECT *
FROM EMPLOYEE
-- WHERE MONTHS_BETWEEN(SYSDATE, HIRE_DATE) >= 240;
WHERE ADD_MONTHS(HIRE_DATE, 240) <= SYSDATE;

-- 4. EMPLOYEE 테이블에서 사원명, 입사일, 입사한 월의 근무 일수(주말 포함)를 조회
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE) - HIRE_DATE + 1 "입사월의 근무일수"
FROM EMPLOYEE;

------------------------------------------------------------------------------------------
-- EXTRACT : 년, 월, 일 정보를 추출하여 리턴
-- EXTRACT(YEAR FROM 날짜) : 년도만 추출
-- EXTRACT(MONTH FROM 날짜) : 월만 추출
-- EXTRACT(DAY FROM 날짜) : 일만 추출

-- EMPLOYEE 테이블에서 사원의 이름, 입사 년, 입사 월, 입사 일 조회
SELECT EMP_NAME 사원이름,
       EXTRACT(YEAR FROM HIRE_DATE) 입사년도,
       EXTRACT(MONTH FROM HIRE_DATE) 입사월,
       EXTRACT(DAY FROM HIRE_DATE) 입사일
FROM EMPLOYEE
--ORDER BY EMP_NAME ASC;
--ORDER BY EMP_NAME DESC;
--ORDER BY 사원이름;
--ORDER BY 1;
ORDER BY 입사년도, 사원이름 DESC;

-- EMPLOYEE 테이블에서 사원의 이름, 입사일, 근무년수를 조회
-- 1) (현재년도 - 입사년도)로 조회
SELECT EMP_NAME, HIRE_DATE,
       EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) "근무년수"
FROM EMPLOYEE;
-- 2) MONTHS_BETWEEN으로 근무년수 조회
SELECT EMP_NAME, HIRE_DATE,
       FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12) 근무년수
FROM EMPLOYEE;

-- 날짜 포맷 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'RR-MM-DD';
ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';
-----------------------------------------------------------------------------------------------
-- 4. 형변환 함수
-- TO_CHAR(날짜, [포맷]) : 날짜형 데이터를 문자형 데이터로 변경
-- TO_CHAR(숫자, [포맷]) : 숫자형 데이터를 문자형 데이터로 변경
SELECT TO_CHAR(1234) FROM DUAL;
SELECT TO_CHAR(1234, '99999') FROM DUAL; -- 5칸, 오른쪽 정렬, 빈칸 공백
SELECT TO_CHAR(1234, '00000') FROM DUAL; -- 5칸, 오른쪽 정렬, 빈칸 0
SELECT TO_CHAR(1234, 'L99999') FROM DUAL; -- 현재 설정된 나라의 화폐 단위
SELECT TO_CHAR(1234, '$99999') FROM DUAL;
SELECT TO_CHAR(1234, '99,999') FROM DUAL; -- 자릿수 구분 콤마
SELECT TO_CHAR(1234, '00,000') FROM DUAL;
SELECT TO_CHAR(1234, '999') FROM DUAL; --자리수가 부족하면 표현X

-- EMPLOYEE 테이블에서 사원명, 급여 조회
-- 급여는 원화 형식으로 표시
SELECT EMP_NAME, TO_CHAR(SALARY, 'L999,999,999')
FROM EMPLOYEE;

-- 날짜 데이터 포맷 적용시에도 TO_CHAR 함수 사용
SELECT TO_CHAR(SYSDATE, 'PM HH24:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'AM HH:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MON, DY, YYYY')FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY-fmMM-DD DAY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-fmDD DAY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YEAR, Q') || '분기' FROM DUAL;

SELECT EMP_NAME, TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일"') 입사일
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE 기존입사일,
       TO_CHAR(HIRE_DATE, 'YYYY/MM/DD HH24:MI:SS') 상세입사일
FROM EMPLOYEE;

-- 년도에 대한 포맷 문자는 'Y', 'R'이 있음
SELECT TO_CHAR(SYSDATE, 'YYYY'), TO_CHAR(SYSDATE, 'RRRR'),
       TO_CHAR(SYSDATE, 'YY'), TO_CHAR(SYSDATE, 'RR')
FROM DUAL;
-- RR은 두자리 년도를 네자리로 바꿀 때
-- 바꿀 년도가 50미만이면 2000년을 적용, 50 이상이면 1900년을 적용

-- 오늘 날짜에서 월만 출력 처리
SELECT TO_CHAR(SYSDATE, 'MM'),
       TO_CHAR(SYSDATE, 'MONTH'),
       TO_CHAR(SYSDATE, 'MON'),
       TO_CHAR(SYSDATE, 'RM')
FROM DUAL;

-- 오늘 날짜에서 일만 출력
SELECT TO_CHAR(SYSDATE, '"1년기준" DDD "일째"'),
       TO_CHAR(SYSDATE, '"달 기준" DD "일째"'),
       TO_CHAR(SYSDATE, '"주 기준" D "일째"')
FROM DUAL;

-- EMPLOYEE 테이블에서 이름, 입사일 조회
-- 입사일은 포맷 적용함 '2019년 09월 17일 (화)' 형식으로 출력
SELECT EMP_NAME, TO_CHAR(HIRE_DATE,'YYYY"년" MM"월" DD"일" "("DY")"')
FROM EMPLOYEE;

-- TO_DATE
-- TO_DATE(문자형 데이터, [포맷]) : 문자형 데이터를 날짜로 변경
-- TO_DATE(숫자형 데이터, [포맷]) : 숫자형 데이터를 날짜로 변경
SELECT TO_DATE('20100101', 'YYYYMMDD') FROM DUAL;
SELECT TO_DATE(20100101, 'YYYYMMDD') FROM DUAL;
SELECT TO_CHAR(TO_DATE('20100101', 'YYYYMMDD'), 'YYYY, MON') FROM DUAL;

SELECT TO_CHAR(TO_DATE('980630', 'YYMMDD'), 'YYYYMMDD') FROM DUAL;
SELECT TO_CHAR(TO_DATE('140918', 'YYMMDD'), 'YYYYMMDD') FROM DUAL;

SELECT TO_CHAR(TO_DATE('980630', 'RRMMDD'), 'RRRRMMDD') FROM DUAL;
SELECT TO_CHAR(TO_DATE('140918', 'RRMMDD'), 'RRRRMMDD') FROM DUAL;

-- TO_NUMBER(문자데이터, [포맷]) : 문자형데이터를 숫자 데이터로
SELECT TO_NUMBER('123456789') FROM DUAL;

SELECT '123' + '456' FROM DUAL; -- 숫자로 자동 형변환, 문자 입력시 에러 발생

SELECT '1,000,000' + '550,000' FROM DUAL; -- 에러 발생

-- TO_NUMBER로 숫자로 만든 뒤 해결
SELECT TO_NUMBER('1,000,000', '9,999,999') + TO_NUMBER('550,000', '999,999') FROM DUAL; 
----------------------------------------------------------------------------------------------
-- 5. NULL 처리 함수
-- NVL(컬럼명, 컬럼값이 NULL일때 바꿀 값)
SELECT EMP_NAME, BONUS, NVL(BONUS, 0)
FROM EMPLOYEE;

SELECT EMP_NAME, DEPT_CODE, NVL(DEPT_CODE, '00')
FROM EMPLOYEE;

-- NVL2(컬럼명, 바꿀값1, 바꿀값2)
-- 해당 컬럼의 값이 있으면 바꿀값1로 변경,
-- 해당 컬럼이 NULL이면 바꿀값2로 변경

-- EMPLOYEE 테이블에서 보너스가 NULL인 직원은 0.5로, NULL이 아닌 경우 0.7로 변경
SELECT EMP_NAME, BONUS, NVL2(BONUS, 0.7, 0.5)
FROM EMPLOYEE;

-- NULLIF(비교대상1, 비교대상2)
-- 두개의 값이 동일하면 NULL, 그렇지 않으면 비교대상1을 리턴
SELECT NULLIF('123', '123') FROM DUAL;
SELECT NULLIF('123', '1234') FROM DUAL;
--------------------------------------------------------------------------------------------
-- 6. 선택함수
-- 여러가지 경우에 선택을 할 수 있는 기능을 제공한다

-- DECODE(계산식 | 컬럼명, 조건값1, 선택값1, 조건값2, 선택값2 ...)
-- 비교하고자 하는 값 또는 컬럼이 조건식과 같으면 결과 값 반환
-- 일치하는 값을 확인(자바의 SWITCH와 비슷함)
SELECT EMP_ID, EMP_NAME, EMP_NO,
       DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여')
FROM EMPLOYEE;

-- 마지막 인자로 조건값 없이 선택값을 작성하면
-- 아무것도 해당하지 않을 때 마지막에 작성한 선택 값을 무조건 선택한다

-- 직원의 급여를 인상
-- 직급코드가 J7이면 10%인상
-- 직급코드가 J6이면 15%인상
-- 직급코드가 J5이면 20%인상
-- 그 외 직급의 직원은 5%만 인상
-- 직원명, 직급코드, 급여, 인상급여 조회
SELECT EMP_NAME, JOB_CODE, SALARY, 
       DECODE(JOB_CODE, 'J7', SALARY * 1.1,
                        'J6', SALARY * 1.15,
                        'J5', SALARY * 1.2,
                        SALARY * 1.05) 인상급여
FROM EMPLOYEE;
-- 해당하는 값이 없으면 NULL 리턴!!!

-- CASE WHEN 조건식 THEN 결과값
--      WHEN 조건식 THEN 결과값
--      ELSE 결과값
-- END
-- 비교하고자 하는 값 또는 컬럼이 조건식과 같으면 결과 값 반환
-- 조건은 범위 값 가능

SELECT EMP_ID, EMP_NAME, EMP_NO,
       CASE WHEN SUBSTR(EMP_NO, 8, 1) = 1 THEN '남'
            ELSE '여'
       END 성별
FROM EMPLOYEE;

SELECT EMP_NAME, SALARY,
       CASE WHEN SALARY > 5000000 THEN '1등급'
            WHEN SALARY > 3500000 THEN '2등급'
            WHEN SALARY > 2000000 THEN '3등급'
            ELSE '4등급'
       END 등급
FROM EMPLOYEE;

-- 직원 급여 인상 CASE WHEN 구문으로 변경하기
SELECT EMP_NAME, JOB_CODE, SALARY,
       CASE WHEN JOB_CODE = 'J7' THEN SALARY * 1.1
            WHEN JOB_CODE = 'J6' THEN SALARY * 1.15
            WHEN JOB_CODE = 'J5' THEN SALARY * 1.2
            ELSE SALARY * 1.05
       END 인상급여
FROM EMPLOYEE;
----------------------------------------------------------------------------------------------

-- < 그룹 함수 >
-- 하나 이상의 행을 그룹으로 묶어 연산하며 총합, 평균 등의 하나의 결과를 반환하는 함수

-- SUM(숫자가 기록된 컬럼명) : 합계를 구하여 리턴
-- EMPLOYEE 테이블에서 전 사원의 급여 총합 조회
SELECT SUM(SALARY)
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 남자 사원의 급여 총합 조회
SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = 1;

-- EMPLOYEE 테이블에서 부서 코드가 D5인 직원의 보너스 포함 연봉 조회
SELECT SUM((SALARY + (SALARY * NVL(BONUS,0))) *12)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- AVG(숫자가 기록된 컬럼명) : 평균을 구하여 리턴

-- EMPLOYEE 테이블에서 전 사원의 급여 평균 조회
SELECT AVG(SALARY)
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 전 사원의 보너스 평균을 소수 셋째자리에서 반올림 한 것 조회
-- BONUS가 NULL인 사원은 0으로 처리
SELECT ROUND(AVG(NVL(BONUS, 0)), 2)
FROM EMPLOYEE;
-- *NVL을 하지 않을 시 NULL 값을 가진 행은 평균 계산에서 제외되어 계산

SELECT AVG(BONUS) 기본평균,
       AVG(DISTINCT BONUS) 중복제거평균,
       AVG(NVL(BONUS, 0)) NULL포함평균
FROM EMPLOYEE;

-- MIN(컬럼명) : 컬럼에서 가장 작은 값 리턴
-- 취급하는 자료형은 ANY TYPE임

-- EMPLOYEE 테이블에서 알파벳 순위가 가장 빠른 이메일, 가장 빠른 입사일, 가장 낮은 급여 조회
SELECT MIN(EMAIL), MIN(HIRE_DATE), MIN(SALARY)
FROM EMPLOYEE;

-- MAX(컬럼명) : 컬럼에서 가장 큰 값 리턴
-- 취급하는 자료형은 ANY TYPE

-- EMPLOYEE 테이블에서 사번 200번 제외하고
-- 알파벳 순위가 가장 늦는 이메일, 가장 최근 입사일, 가장 높은 급여 조회
SELECT MAX(EMAIL), MAX(HIRE_DATE), MAX(SALARY)
FROM EMPLOYEE
WHERE EMP_ID <> 200;

-- COUNT(* | 컬럼명) : 행 개수를 헤아려서 리턴
-- COUNT([DISTINCT] 컬럼명) : 중복을 제거한 행 개수를 헤아려서 리턴
-- COUNT(*) : NULL을 포함한 전체 행 개수를 리턴
-- COUNT(컬럼명) : NULL을 제외한 실제 값이 기록 된 행 개수를 리턴

-- EMPLOYEE 테이블에서 전체 사원 수, 부서코드가 있는 사원 수, 사원들이 속해있는 부서의 수 조회
SELECT COUNT(*), COUNT(DEPT_CODE), COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;

---------------------------------------------------------------------------------------
-- 함수 연습 문제
--1. 직원명과 주민번호를 조회함
--  단, 주민번호 9번째 자리부터 끝까지는 '*'문자로 채움
--  예 : 홍길동 771120-1******
SELECT EMP_NAME, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*')
FROM EMPLOYEE;

--2. 직원명, 직급코드, 연봉(원) 조회
--  단, 연봉은 ￦57,000,000 으로 표시되게 함
--     연봉은 보너스포인트가 적용된 1년치 급여임
SELECT EMP_NAME 직원명, JOB_CODE 직급코드, TO_CHAR((SALARY + (1+(SALARY * NVL(BONUS, 0))) * 12), 'L999,999,999') 연뵹
FROM EMPLOYEE;


--3. 부서코드가 D5, D9인 직원들 중에서 2004년도에 입사한 직원의 
--	사번 사원명 부서코드 입사일
SELECT EMP_ID 사번, EMP_NAME, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE = 'D5' OR DEPT_CODE = 'D9') AND EXTRACT(YEAR FROM HIRE_DATE) = 2004;

-- 4. 직원명, 입사일, 입사한 달의 근무일수 조회
-- 단, 주말도 포함함
SELECT EMP_NAME AS 직원명, 
    HIRE_DATE AS 입사일, 
    EXTRACT(DAY FROM LAST_DAY(HIRE_DATE) - SUBSTR(HIRE_DATE, 7, 2)) + 1 AS "첫달 근무일수"
FROM EMPLOYEE;

-- 5. 직원명, 부서코드, 생년월일, 나이(한국식) 조회
-- 단, 생년월일은 주민번호에서 추출해서, 
-- ㅇㅇ년 ㅇㅇ월 ㅇㅇ일로 출력되게 함.
-- 현재 년도 - 태어난 년도 + 1
SELECT EMP_NAME 직원명, 
    DEPT_CODE 부서코드,  
    TO_CHAR(TO_DATE(SUBSTR(EMP_NO, 1, 6), 'YYMMDD'), 'YY"년"MM"월"DD"일') 생년월일,
    (119 - SUBSTR(EMP_NO, 1, 2)) + 1 AS 나이
FROM EMPLOYEE;

-- 6. 직원들의 입사일로 부터 년도만 가지고, 각 년도별 입사인원수를 구하시오.
--  아래의 년도에 입사한 인원수를 조회하시오.
--  => TO_CHAR, DECODE, COUNT 사용
--	-------------------------------------------------------------
--	전체직원수   2001년   2002년   2003년   2004년
--	-------------------------------------------------------------
-- ?
SELECT COUNT(HIRE_DATE) AS 전체직원수,
    COUNT(DECODE(TO_CHAR(HIRE_DATE, 'RRRR'), '2001', 1)) "2001년", -- 2001년에는 1이 들어가고, 나머지 것들에는 NULL이 들어가기 때문에 2001만 유효한 값이 되어 셀 수 있다
    COUNT(DECODE(TO_CHAR(HIRE_DATE, 'RRRR'), '2002', 1)) "2002년", -- DECODE에 조건이 맞지 않으면 NULL이나 내가 매개변수 마지막에 넣은 값이 들어간다.
    COUNT(DECODE(TO_CHAR(HIRE_DATE, 'RRRR'), '2003', 1)) "2003년", -- DECODE는 CHAR만 검사할 수 있는듯
    COUNT(DECODE(TO_CHAR(HIRE_DATE, 'RRRR'), '2004', 1)) "2004년"
FROM EMPLOYEE;
--    COUNT(SUBSTR(HIRE_DATE, 1, 2) = '2000'),
--    COUNT(SUBSTR(HIRE_DATE, 1, 2) = '2001'),
--    COUNT(SUBSTR(HIRE_DATE, 1, 2) = '2002'),
--    COUNT(SUBSTR(HIRE_DATE, 1, 2) = '2003')  내가 틀린 코드


--7.  부서코드가 D5이면 총무부, D6이면 기획부, D9이면 영업부로 처리하시오.
--   단, 부서코드가 D5, D6, D9 인 직원의 정보만 조회함
--  => case 사용
SELECT EMP_NAME, DEPT_CODE, CASE WHEN DEPT_CODE = 'D5' THEN '총무부'
    WHEN DEPT_CODE = 'D6' THEN '기획부'
    WHEN DEPT_CODE = 'D9' THEN '영업부'
    END 부서
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' OR DEPT_CODE = 'D6' OR DEPT_CODE = 'D9';
-- WHERE DEPT_CODE IN('D5', 'D6', 'D9'); 와 같다




