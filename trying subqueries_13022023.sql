SELECT r.name AS region, s.name AS sales_rep, SUM(o.total_amt_usd) AS total_amt
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
GROUP BY 1, 2
ORDER BY 1, 3 DESC;

SELECT region, MAX(total_amt)
FROM (
  SELECT r.name AS region, s.name AS sales_rep, SUM(o.total_amt_usd) AS total_amt
  FROM orders o
  JOIN accounts a
  ON o.account_id = a.id
  JOIN sales_reps s
  ON s.id = a.sales_rep_id
  JOIN region r
  ON r.id = s.region_id
  GROUP BY 1, 2
  ORDER BY 1, 3 DESC) t1
GROUP BY 1;

SELECT t3.region, t1.sales_rep, t3.total_amt
FROM (
  SELECT r.name AS region, s.name AS sales_rep, SUM(o.total_amt_usd) AS total_amt
  FROM orders o
  JOIN accounts a
  ON o.account_id = a.id
  JOIN sales_reps s
  ON s.id = a.sales_rep_id
  JOIN region r
  ON r.id = s.region_id
  GROUP BY 1, 2
  ORDER BY 1, 3 DESC) t1
JOIN
  (SELECT region, MAX(total_amt) AS total_amt
  FROM (
    SELECT r.name AS region, s.name AS sales_rep, SUM(o.total_amt_usd) AS total_amt
    FROM orders o
    JOIN accounts a
    ON o.account_id = a.id
    JOIN sales_reps s
    ON s.id = a.sales_rep_id
    JOIN region r
    ON r.id = s.region_id
    GROUP BY 1, 2
    ORDER BY 1, 3 DESC) t2
GROUP BY 1) t3
ON t1.region = t3.region AND t1.total_amt = t3.total_amt;

SELECT t2.region, t3.max_sales, t2.order_count
FROM (
  SELECT MAX(total_amt) AS max_sales FROM (
    SELECT r.name AS region, SUM(o.total_amt_usd) AS total_amt, COUNT(o.id) AS order_count
    FROM orders o
    JOIN accounts a
    ON o.account_id = a.id
    JOIN sales_reps s
    ON s.id = a.sales_rep_id
    JOIN region r
    ON r.id = s.region_id
    GROUP BY 1
    ORDER BY 2 DESC) t1) t3
JOIN
(SELECT r.name AS region, SUM(o.total_amt_usd) AS total_amt, COUNT(o.id) AS order_count
    FROM orders o
    JOIN accounts a
    ON o.account_id = a.id
    JOIN sales_reps s
    ON s.id = a.sales_rep_id
    JOIN region r
    ON r.id = s.region_id
    GROUP BY 1
    ORDER BY 2 DESC) t2
ON t3.max_sales = t2.total_amt;

SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (
      SELECT MAX(total_amt)
      FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
              FROM sales_reps s
              JOIN accounts a
              ON a.sales_rep_id = s.id
              JOIN orders o
              ON o.account_id = a.id
              JOIN region r
              ON r.id = s.region_id
              GROUP BY r.name) sub);

SELECT COUNT(*) AS count
FROM (
      SELECT *
      FROM orders
      WHERE total > (
        SELECT MAX(standard_qty) AS stddQty
        FROM orders) 
) sub;

SELECT COUNT(*)
FROM (
    SELECT a.name AS account, SUM(o.total) AS all_sales
  FROM accounts a
  JOIN orders o
  ON o.account_id = a.id
  GROUP BY 1
  HAVING SUM(o.total) > ( 
    SELECT total_sales
    FROM (
      SELECT a.name AS acct_name, SUM(o.standard_qty) AS stdd_qty, SUM(o.total) AS total_sales
      FROM accounts a
      JOIN orders o
      ON o.account_id = a.id
      GROUP BY 1
      ORDER BY 2 DESC
      LIMIT 1) sub))sub2;
    
SELECT channels, COUNT(events) AS events_count
FROM (
  SELECT a.name AS cust, w.id AS events, w.channel AS channels
  FROM accounts a
  JOIN web_events w
  ON w.account_id = a.id
  WHERE a.name = ( 
    SELECT customer
    FROM (
      SELECT a.name AS customer, SUM(o.total_amt_usd) AS total_amt
      FROM accounts a
      JOIN orders o
      ON o.account_id = a.id
      GROUP BY 1
      ORDER BY 2 DESC
      LIMIT 1) sub))sub2
GROUP BY 1
ORDER BY 2 DESC;
    
SELECT AVG(total_amt) AS average
FROM (
  SELECT a.name AS account, SUM(o.total_amt_usd) AS total_amt
  FROM accounts a
  JOIN orders o
  ON a.id = o.account_id
  GROUP BY 1
  ORDER BY 2 DESC
  LIMIT 10
  ) sub ;


SELECT AVG(top_avg) AS total_avg
FROM (
  SELECT a.name AS acct_name, AVG(o.total_amt_usd) AS top_avg
  FROM accounts a
  JOIN orders o
  ON a.id = o.account_id
  GROUP BY acct_name
  HAVING AVG(o.total_amt_usd) > (
    SELECT AVG(total_amt_usd) AS average
    FROM orders)) sub;