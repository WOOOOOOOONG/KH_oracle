-- 문제 1
SELECT DEPARTMENT_NAME "학교 명", CATEGORY 계열
FROM TB_DEPARTMENT;

-- 문제 2
SELECT DEPARTMENT_NAME || '의 정원은 ' || CAPACITY || ' 명 입니다.' "학과별 정원"
FROM TB_DEPARTMENT;

-- 문제 3
SELECT STUDENT_NAME
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE ABSENCE_YN = 'Y'
AND SUBSTR(STUDENT_SSN, 8, 1) = '2'
AND DEPARTMENT_NO IN (SELECT DEPARTMENT_NO
                    FROM TB_STUDENT
                    WHERE DEPARTMENT_NAME = '국어국문학과');

-- 문제 4
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO IN ('A513079', 'A513090', 'A513091', 'A513110', 'A513119')
ORDER BY STUDENT_NAME DESC;

-- 문제 5
SELECT DEPARTMENT_NAME, CATEGORY
FROM TB_DEPARTMENT
WHERE CAPACITY BETWEEN '20' AND '30';

-- 문제 6
SELECT PROFESSOR_NAME
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO IS NULL;

-- 문제 7
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE DEPARTMENT_NO IS NULL;

-- 문제 8
SELECT  CLASS_NO
FROM TB_CLASS
WHERE PREATTENDING_CLASS_NO IS NOT NULL;

-- 문제 9
SELECT DISTINCT CATEGORY
FROM TB_DEPARTMENT;

-- 문제 10
SELECT STUDENT_NO, STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE SUBSTR(TO_CHAR(ENTRANCE_DATE), 1, 2) = '02'
AND ABSENCE_YN = 'N'
AND SUBSTR(STUDENT_ADDRESS, 1, 3) = '전주시';