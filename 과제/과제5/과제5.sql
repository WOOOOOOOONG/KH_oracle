-- 2번
SELECT C1.TABLE_NAME, COLUMN_NAME, C3.DATA_TYPE, C3.DATA_DEFAULT, C3.NULLABLE, CONSTRAINT_NAME, C1.CONSTRAINT_TYPE, C1.R_CONSTRAINT_NAME
FROM USER_CONSTRAINTS C1
LEFT JOIN USER_CONS_COLUMNS C2 USING(CONSTRAINT_NAME)
LEFT JOIN USER_TAB_COLS C3 USING(COLUMN_NAME);

-- user_constraints , user_cons_columns

SELECT * FROM USER_CONSTRAINTS;
SELECT * FROM USER_CONS_COLUMNS;
SELECT * FROM USER_TAB_COLS;
-- 3번
SELECT BOOK_NM
FROM TB_BOOK
WHERE LENGTH(BOOK_NM) > 25;

-- 4번
SELECT WRITER_NM, OFFICE_TELNO, HOME_TELNO, MOBILE_NO
FROM (SELECT WRITER_NM, OFFICE_TELNO, HOME_TELNO, MOBILE_NO    
                 FROM TB_WRITER
                 WHERE WRITER_NM LIKE '김%'
                 AND SUBSTR(MOBILE_NO, 1, 3) = '019')
WHERE ROWNUM = 1;

-- 5번
SELECT COUNT(WRITER_NO) || '명' AS "작가(명)"
FROM TB_BOOK_AUTHOR
WHERE COMPOSE_TYPE = '옮김';

-- 6번
SELECT COMPOSE_TYPE, SUM(STOCK_QTY)
FROM TB_BOOK
JOIN TB_BOOK_AUTHOR USING(BOOK_NO)
GROUP BY COMPOSE_TYPE
HAVING COUNT(COMPOSE_TYPE) >= 300;

-- 7번
SELECT BOOK_NM, ISSUE_DATE, PUBLISHER_NM
FROM TB_BOOK
WHERE ISSUE_DATE = (SELECT MAX(ISSUE_DATE)
                    FROM TB_BOOK);
                    
-- 8번
SELECT "작가 이름", "권 수"
FROM (SELECT WRITER_NM "작가 이름", COUNT(BOOK_NO) "권 수"
      FROM TB_BOOK
      JOIN TB_BOOK_AUTHOR USING(BOOK_NO)
      LEFT JOIN TB_WRITER USING(WRITER_NO)
      GROUP BY WRITER_NM
      ORDER BY 2 DESC)
WHERE ROWNUM <= 3;

-- 9번
COMMIT;

UPDATE TB_WRITER W
SET REGIST_DATE = (SELECT MIN(ISSUE_DATE)
                   FROM TB_BOOK
                   JOIN TB_BOOK_AUTHOR USING(BOOK_NO)
                   JOIN TB_WRITER E USING(WRITER_NO)
                   GROUP BY WRITER_NM
                   HAVING W.WRITER_NM = E.WRITER_NM);
ROLLBACK;            

SELECT * FROM TB_WRITER;        


-- 10번
CREATE TABLE TB_BOOK_TRANSLATOR(
    BOOK_NO VARCHAR2(20) CONSTRAINT PH_BOOK_TRANLATOR PRIMARY KEY,
    WRITER_NO VARCHAR2(10) NOT NULL CONSTRAINT FK_BOOK_TRANSLATOR_02 REFERENCES TB_WRITER,
    TRANS_LANG VARCHAR2(60),
    CONSTRAINT FK_BOOK_TRANSLATOR_01 FOREIGN KEY (BOOK_NO) REFERENCES TB_BOOK
);

-- 11번
INSERT INTO TB_BOOK_TRANSLATOR (
    SELECT BOOK_NO, WRITER_NO, NULL
    FROM TB_BOOK_AUTHOR
    WHERE COMPOSE_TYPE IN ('옮김', '역주', '편역', '공역')
);

DELETE FROM TB_BOOK_AUTHOR
WHERE COMPOSE_TYPE IN ('옮김', '역주', '편역', '공역');

SELECT * FROM TB_BOOK_AUTHOR;
SELECT * FROM TB_BOOK_TRANSLATOR;

-- 12번
SELECT BOOK_NM, PUBLISHER_NM
FROM TB_BOOK
WHERE EXTRACT(YEAR FROM ISSUE_DATE) = 2007;

-- 13번
CREATE OR REPLACE VIEW VW_BOOK_TRANSLATOR
AS SELECT BOOK_NM, PUBLISHER_NM, ISSUE_DATE
   FROM TB_BOOK
   WHERE ISSUE_DATE IS NOT NULL WITH CHECK OPTION;
   
SELECT * FROM VW_BOOK_TRANSLATOR;

-- 14번
COMMIT;

INSERT INTO TB_PUBLISHER
VALUES('춘 출판사', '02-6710-3737', DEFAULT);

ROLLBACK;

-- 15번
SELECT WRITER_NM, COUNT(WRITER_NM)
FROM TB_WRITER
GROUP BY WRITER_NM
HAVING COUNT(WRITER_NM) >= 2;

-- 16번
COMMIT;

UPDATE TB_BOOK_AUTHOR
SET COMPOSE_TYPE = '지음'
WHERE COMPOSE_TYPE IS NULL;

SELECT * FROM TB_BOOK_AUTHOR;

ROLLBACK;

-- 17번
SELECT WRITER_NM, OFFICE_TELNO
FROM TB_WRITER
WHERE OFFICE_TELNO LIKE '02-___-%';

-- 18번
SELECT WRITER_NM
FROM TB_WRITER
WHERE EXTRACT(YEAR FROM TO_DATE(20060101)) - EXTRACT(YEAR FROM REGIST_DATE) >= 31
ORDER BY 1;

-- 19번
SELECT BOOK_NM, PRICE, CASE WHEN STOCK_QTY < 5 THEN '추가주문필요' ELSE '소량보유' END
FROM TB_BOOK
JOIN TB_PUBLISHER USING(PUBLISHER_NM)
WHERE PUBLISHER_NM = '황금가지'
AND STOCK_QTY < 10
ORDER BY STOCK_QTY DESC, 1 ASC;

-- 20번
SELECT BOOK_NM 도서명, WRITER_NM 저자, PUBLISHER_NM 역자
FROM TB_BOOK
JOIN TB_PUBLISHER USING(PUBLISHER_NM)
JOIN TB_BOOK_AUTHOR USING(BOOK_NO)
JOIN TB_WRITER USING(WRITER_NO)
WHERE BOOK_NM = '아타트롤';

-- 21번 
SELECT BOOK_NM 도서명, STOCK_QTY 재고수량, PRICE "가격(Org)", FLOOR(PRICE * 0.8) "가격(New)"
FROM TB_BOOK
WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM ISSUE_DATE) >= 30
AND STOCK_QTY >= 90
ORDER BY 2 DESC, 4 DESC, 1 ASC;