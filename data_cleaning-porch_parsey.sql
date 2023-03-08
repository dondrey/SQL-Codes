SELECT RIGHT(website, 3) AS extension, COUNT(id) AS count
FROM accounts
GROUP BY 1;

SELECT LEFT(UPPER(name), 1) AS first_letter, COUNT(id) AS count
FROM accounts
GROUP BY 1;

SELECT CASE 
	WHEN first_xter = 'number' THEN 'number' 
	ELSE 'letter' END AS first_xter,
COUNT(*)
FROM (
    SELECT name, CASE 
        WHEN LEFT(UPPER(name), 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') THEN 'number' ELSE 'letter'
        END AS first_xter
    FROM accounts
    ORDER BY 2 DESC) sub
GROUP BY 1;

SELECT CASE
	WHEN LEFT(UPPER(name), 1) IN ('A', 'E', 'I', 'O', 'U') THEN 'vowel'
    ELSE 'non-vowel' END AS cat,
(COUNT(*)/((SELECT COUNT(company) AS count FROM (
  SELECT name AS company, 
  CASE WHEN LEFT(UPPER(name), 1) IN ('A', 'E', 'I', 'O', 'U') THEN 'vowel'
      ELSE 'non-vowel' END AS cat
  FROM accounts
  ORDER BY 2 DESC) sub))*100) AS counter
FROM accounts
GROUP BY 1;

WITH table1 AS (
  SELECT CASE
        WHEN LEFT(UPPER(name), 1) IN ('A', 'E', 'I', 'O', 'U') THEN 'vowel'
        ELSE 'non_vowel' END AS category,
  COUNT(*) AS count
  FROM accounts
  GROUP BY 1)

SELECT category, (count / 351) AS porportion
FROM table1;

SELECT *, LEFT(primary_poc, POSITION(' ' IN primary_poc)) AS first_name, RIGHT(primary_poc, (LENGTH(primary_poc) - STRPOS(primary_poc, ' '))) AS last_name
FROM accounts
LIMIT 20;
                                                                                                                          
SELECT *                                                                                                                  FROM sales_reps                                                                                                                  LIMIT 10;
                                                                                                                          
                                                                                                                          SELECT *,
LEFT(name, POSITION(' ' IN name)) AS first,
RIGHT(name, LENGTH(name) - POSITION(' ' IN name)) AS last
FROM sales_reps;