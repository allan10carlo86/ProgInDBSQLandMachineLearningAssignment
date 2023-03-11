/*
 SQL For Machine Learning: Allan Carlo T. Ramos
 Description: Shows the solution for the question in the Machine Learning
 Date Created: March 7, 2023
 Log Changes:
 -  March 7 2023   | Allan Carlo T. Ramos |    Initial Draft
 -  March 9 2023.  | Allan Carlo T. Ramos |    Updated SQL to include UNION statement
 */

use fillians_toy_shop;
SELECT total_completed_orders_2003_table.cust_name AS CUST_NAME,
       total_completed_orders_2003_table.order_no_count,
       total_completed_orders_2004_table.order_no_count,
       total_completed_orders_2005_table.order_no_count
FROM (SELECT customers.customer_no AS cust_no,
             customers.name           cust_name,
             COUNT(orders.order_no)       AS order_no_count
      FROM customers
               JOIN orders
                    ON customers.customer_no = orders.customer_no
      WHERE orders.order_date >= '2003-01-01'
        AND orders.order_date <= '2003-12-31'
        AND orders.status = "Shipped"
      GROUP BY customers.customer_no
      ORDER BY customers.customer_no ASC) total_completed_orders_2003_table
         left join
     (SELECT customers.customer_no cust_no,
             customers.name        cust_name,
             COUNT(orders.order_no)       AS order_no_count
      FROM customers
               JOIN orders
                    ON customers.customer_no = orders.customer_no
      WHERE orders.order_date >= '2004-01-01'
        AND orders.order_date <= '2004-12-31'
        AND orders.status = "Shipped"
      GROUP BY customers.customer_no
      ORDER BY customers.customer_no ASC) total_completed_orders_2004_table
     ON total_completed_orders_2003_table.cust_no = total_completed_orders_2004_table.cust_no
         LEFT JOIN
     (SELECT customers.customer_no cust_no,
             customers.name        cust_name,
             COUNT(orders.order_no)       AS order_no_count
      FROM customers
               JOIN orders
                    ON customers.customer_no = orders.customer_no
      WHERE orders.order_date >= '2005-01-01'
        AND orders.order_date <= '2005-12-31'
        AND orders.status = "Shipped"
      GROUP BY customers.customer_no
      ORDER BY customers.customer_no ASC) total_completed_orders_2005_table
     ON total_completed_orders_2003_table.cust_no = total_completed_orders_2005_table.cust_no
WHERE NOT (total_completed_orders_2004_table.order_no_count IS NULL
  AND total_completed_orders_2005_table.order_no_count IS NULL)
UNION
SELECT total_completed_orders_2004_table.cust_name,
       total_completed_orders_2003_table.order_no_count,
       total_completed_orders_2004_table.order_no_count,
       total_completed_orders_2005_table.order_no_count
FROM (SELECT customers.customer_no AS cust_no,
             customers.name           cust_name,
             COUNT(orders.order_no)       AS order_no_count
      FROM customers
               JOIN orders
                    ON customers.customer_no = orders.customer_no
      WHERE orders.order_date >= '2003-01-01'
        AND orders.order_date <= '2003-12-31'
        AND orders.status = "Shipped"
      GROUP BY customers.customer_no
      ORDER BY customers.customer_no ASC) total_completed_orders_2003_table
         RIGHT JOIN
     (SELECT customers.customer_no cust_no,
             customers.name        cust_name,
             COUNT(orders.order_no)       AS order_no_count
      FROM customers
               JOIN orders
                    ON customers.customer_no = orders.customer_no
      WHERE orders.order_date >= '2004-01-01'
        AND orders.order_date <= '2004-12-31'
        AND orders.status = "Shipped"
      GROUP BY customers.customer_no
      ORDER BY customers.customer_no ASC) total_completed_orders_2004_table
     ON total_completed_orders_2003_table.cust_no = total_completed_orders_2004_table.cust_no
         LEFT JOIN
     (SELECT customers.customer_no cust_no,
             customers.name        cust_name,
             COUNT(orders.order_no)       AS order_no_count
      FROM customers
               JOIN orders
                    ON customers.customer_no = orders.customer_no
      WHERE orders.order_date >= '2005-01-01'
        AND orders.order_date <= '2005-12-31'
        AND orders.status = "Shipped"
      GROUP BY customers.customer_no
      ORDER BY customers.customer_no ASC) total_completed_orders_2005_table
     ON total_completed_orders_2004_table.cust_no = total_completed_orders_2005_table.cust_no
WHERE total_completed_orders_2003_table.order_no_count IS NULL AND NOT total_completed_orders_2005_table.order_no_count IS NULL ;
# Based on Recency

SELECT c.name AS customer_name, DATEDIFF('2005-06-01',MAX(o.order_date)) AS days_since_last_order
FROM customers c
    LEFT JOIN orders o ON c.customer_no = o.customer_no
    INNER JOIN (
        SELECT total_completed_orders_2003_table.cust_name AS customer_name,
                 total_completed_orders_2003_table.order_no_count as order_no_count_2003,
                 total_completed_orders_2004_table.order_no_count as order_no_count_2024,
                 total_completed_orders_2005_table.order_no_count as order_no_count_2025
          FROM (SELECT customers.customer_no  AS cust_no,
                       customers.name            cust_name,
                       COUNT(orders.order_no) AS order_no_count
                FROM customers
                         JOIN orders
                              ON customers.customer_no = orders.customer_no
                WHERE orders.order_date >= '2003-01-01'
                  AND orders.order_date <= '2003-12-31'
                  AND orders.status = "Shipped"
                GROUP BY customers.customer_no
                ORDER BY customers.customer_no ASC) total_completed_orders_2003_table
                   left join
               (SELECT customers.customer_no     cust_no,
                       customers.name            cust_name,
                       COUNT(orders.order_no) AS order_no_count
                FROM customers
                         JOIN orders
                              ON customers.customer_no = orders.customer_no
                WHERE orders.order_date >= '2004-01-01'
                  AND orders.order_date <= '2004-12-31'
                  AND orders.status = "Shipped"
                GROUP BY customers.customer_no
                ORDER BY customers.customer_no ASC) total_completed_orders_2004_table
               ON total_completed_orders_2003_table.cust_no = total_completed_orders_2004_table.cust_no
                   LEFT JOIN
               (SELECT customers.customer_no     cust_no,
                       customers.name            cust_name,
                       COUNT(orders.order_no) AS order_no_count
                FROM customers
                         JOIN orders
                              ON customers.customer_no = orders.customer_no
                WHERE orders.order_date >= '2005-01-01'
                  AND orders.order_date <= '2005-12-31'
                  AND orders.status = "Shipped"
                GROUP BY customers.customer_no
                ORDER BY customers.customer_no ASC) total_completed_orders_2005_table
               ON total_completed_orders_2003_table.cust_no = total_completed_orders_2005_table.cust_no
          WHERE NOT (total_completed_orders_2004_table.order_no_count IS NULL
              AND total_completed_orders_2005_table.order_no_count IS NULL)
          UNION
          SELECT total_completed_orders_2004_table.cust_name,
                 total_completed_orders_2003_table.order_no_count,
                 total_completed_orders_2004_table.order_no_count,
                 total_completed_orders_2005_table.order_no_count
          FROM (SELECT customers.customer_no  AS cust_no,
                       customers.name            cust_name,
                       COUNT(orders.order_no) AS order_no_count
                FROM customers
                         JOIN orders
                              ON customers.customer_no = orders.customer_no
                WHERE orders.order_date >= '2003-01-01'
                  AND orders.order_date <= '2003-12-31'
                  AND orders.status = "Shipped"
                GROUP BY customers.customer_no
                ORDER BY customers.customer_no ASC) total_completed_orders_2003_table
                   RIGHT JOIN
               (SELECT customers.customer_no     cust_no,
                       customers.name            cust_name,
                       COUNT(orders.order_no) AS order_no_count
                FROM customers
                         JOIN orders
                              ON customers.customer_no = orders.customer_no
                WHERE orders.order_date >= '2004-01-01'
                  AND orders.order_date <= '2004-12-31'
                  AND orders.status = "Shipped"
                GROUP BY customers.customer_no
                ORDER BY customers.customer_no ASC) total_completed_orders_2004_table
               ON total_completed_orders_2003_table.cust_no = total_completed_orders_2004_table.cust_no
                   LEFT JOIN
               (SELECT customers.customer_no     cust_no,
                       customers.name            cust_name,
                       COUNT(orders.order_no) AS order_no_count
                FROM customers
                         JOIN orders
                              ON customers.customer_no = orders.customer_no
                WHERE orders.order_date >= '2005-01-01'
                  AND orders.order_date <= '2005-12-31'
                  AND orders.status = "Shipped"
                GROUP BY customers.customer_no
                ORDER BY customers.customer_no ASC) total_completed_orders_2005_table
               ON total_completed_orders_2004_table.cust_no = total_completed_orders_2005_table.cust_no
          WHERE total_completed_orders_2003_table.order_no_count IS NULL
            AND NOT total_completed_orders_2005_table.order_no_count IS NULL
        ) table_of_returning_customers ON table_of_returning_customers.customer_name = c.name
WHERE o.status = 'Shipped'
GROUP BY c.name
ORDER BY days_since_last_order DESC;


### Frequency


SELECT c.name AS customer_name, COUNT(DISTINCT order_no) AS total_order_count
FROM customers c
    LEFT JOIN orders o ON c.customer_no = o.customer_no
    INNER JOIN (
        SELECT total_completed_orders_2003_table.cust_name AS customer_name,
                 total_completed_orders_2003_table.order_no_count as order_no_count_2003,
                 total_completed_orders_2004_table.order_no_count as order_no_count_2024,
                 total_completed_orders_2005_table.order_no_count as order_no_count_2025
          FROM (SELECT customers.customer_no  AS cust_no,
                       customers.name            cust_name,
                       COUNT(orders.order_no) AS order_no_count
                FROM customers
                         JOIN orders
                              ON customers.customer_no = orders.customer_no
                WHERE orders.order_date >= '2003-01-01'
                  AND orders.order_date <= '2003-12-31'
                  AND orders.status = "Shipped"
                GROUP BY customers.customer_no
                ORDER BY customers.customer_no ASC) total_completed_orders_2003_table
                   left join
               (SELECT customers.customer_no     cust_no,
                       customers.name            cust_name,
                       COUNT(orders.order_no) AS order_no_count
                FROM customers
                         JOIN orders
                              ON customers.customer_no = orders.customer_no
                WHERE orders.order_date >= '2004-01-01'
                  AND orders.order_date <= '2004-12-31'
                  AND orders.status = "Shipped"
                GROUP BY customers.customer_no
                ORDER BY customers.customer_no ASC) total_completed_orders_2004_table
               ON total_completed_orders_2003_table.cust_no = total_completed_orders_2004_table.cust_no
                   LEFT JOIN
               (SELECT customers.customer_no     cust_no,
                       customers.name            cust_name,
                       COUNT(orders.order_no) AS order_no_count
                FROM customers
                         JOIN orders
                              ON customers.customer_no = orders.customer_no
                WHERE orders.order_date >= '2005-01-01'
                  AND orders.order_date <= '2005-12-31'
                  AND orders.status = "Shipped"
                GROUP BY customers.customer_no
                ORDER BY customers.customer_no ASC) total_completed_orders_2005_table
               ON total_completed_orders_2003_table.cust_no = total_completed_orders_2005_table.cust_no
          WHERE NOT (total_completed_orders_2004_table.order_no_count IS NULL
              AND total_completed_orders_2005_table.order_no_count IS NULL)
          UNION
          SELECT total_completed_orders_2004_table.cust_name,
                 total_completed_orders_2003_table.order_no_count,
                 total_completed_orders_2004_table.order_no_count,
                 total_completed_orders_2005_table.order_no_count
          FROM (SELECT customers.customer_no  AS cust_no,
                       customers.name            cust_name,
                       COUNT(orders.order_no) AS order_no_count
                FROM customers
                         JOIN orders
                              ON customers.customer_no = orders.customer_no
                WHERE orders.order_date >= '2003-01-01'
                  AND orders.order_date <= '2003-12-31'
                  AND orders.status = "Shipped"
                GROUP BY customers.customer_no
                ORDER BY customers.customer_no ASC) total_completed_orders_2003_table
                   RIGHT JOIN
               (SELECT customers.customer_no     cust_no,
                       customers.name            cust_name,
                       COUNT(orders.order_no) AS order_no_count
                FROM customers
                         JOIN orders
                              ON customers.customer_no = orders.customer_no
                WHERE orders.order_date >= '2004-01-01'
                  AND orders.order_date <= '2004-12-31'
                  AND orders.status = "Shipped"
                GROUP BY customers.customer_no
                ORDER BY customers.customer_no ASC) total_completed_orders_2004_table
               ON total_completed_orders_2003_table.cust_no = total_completed_orders_2004_table.cust_no
                   LEFT JOIN
               (SELECT customers.customer_no     cust_no,
                       customers.name            cust_name,
                       COUNT(orders.order_no) AS order_no_count
                FROM customers
                         JOIN orders
                              ON customers.customer_no = orders.customer_no
                WHERE orders.order_date >= '2005-01-01'
                  AND orders.order_date <= '2005-12-31'
                  AND orders.status = "Shipped"
                GROUP BY customers.customer_no
                ORDER BY customers.customer_no ASC) total_completed_orders_2005_table
               ON total_completed_orders_2004_table.cust_no = total_completed_orders_2005_table.cust_no
          WHERE total_completed_orders_2003_table.order_no_count IS NULL
            AND NOT total_completed_orders_2005_table.order_no_count IS NULL
        ) table_of_returning_customers ON table_of_returning_customers.customer_name = c.name
WHERE o.status = 'Shipped'
GROUP BY c.name
ORDER BY total_order_count DESC

###Monetary
SELECT c.name AS customer_name, SUM(od.price_each * od.quantity_ordered) AS total_amount_sold
FROM customers c
    LEFT JOIN orders o ON c.customer_no = o.customer_no
    LEFT JOIN order_details od ON od.order_no = o.order_no
   INNER JOIN (
        SELECT total_completed_orders_2003_table.cust_name AS customer_name,
                 total_completed_orders_2003_table.order_no_count as order_no_count_2003,
                 total_completed_orders_2004_table.order_no_count as order_no_count_2024,
                 total_completed_orders_2005_table.order_no_count as order_no_count_2025
          FROM (SELECT customers.customer_no  AS cust_no,
                       customers.name            cust_name,
                       COUNT(orders.order_no) AS order_no_count
                FROM customers
                         JOIN orders
                              ON customers.customer_no = orders.customer_no
                WHERE orders.order_date >= '2003-01-01'
                  AND orders.order_date <= '2003-12-31'
                  AND orders.status = "Shipped"
                GROUP BY customers.customer_no
                ORDER BY customers.customer_no ASC) total_completed_orders_2003_table
                   left join
               (SELECT customers.customer_no     cust_no,
                       customers.name            cust_name,
                       COUNT(orders.order_no) AS order_no_count
                FROM customers
                         JOIN orders
                              ON customers.customer_no = orders.customer_no
                WHERE orders.order_date >= '2004-01-01'
                  AND orders.order_date <= '2004-12-31'
                  AND orders.status = "Shipped"
                GROUP BY customers.customer_no
                ORDER BY customers.customer_no ASC) total_completed_orders_2004_table
               ON total_completed_orders_2003_table.cust_no = total_completed_orders_2004_table.cust_no
                   LEFT JOIN
               (SELECT customers.customer_no     cust_no,
                       customers.name            cust_name,
                       COUNT(orders.order_no) AS order_no_count
                FROM customers
                         JOIN orders
                              ON customers.customer_no = orders.customer_no
                WHERE orders.order_date >= '2005-01-01'
                  AND orders.order_date <= '2005-12-31'
                  AND orders.status = "Shipped"
                GROUP BY customers.customer_no
                ORDER BY customers.customer_no ASC) total_completed_orders_2005_table
               ON total_completed_orders_2003_table.cust_no = total_completed_orders_2005_table.cust_no
          WHERE NOT (total_completed_orders_2004_table.order_no_count IS NULL
              AND total_completed_orders_2005_table.order_no_count IS NULL)
          UNION
          SELECT total_completed_orders_2004_table.cust_name,
                 total_completed_orders_2003_table.order_no_count,
                 total_completed_orders_2004_table.order_no_count,
                 total_completed_orders_2005_table.order_no_count
          FROM (SELECT customers.customer_no  AS cust_no,
                       customers.name            cust_name,
                       COUNT(orders.order_no) AS order_no_count
                FROM customers
                         JOIN orders
                              ON customers.customer_no = orders.customer_no
                WHERE orders.order_date >= '2003-01-01'
                  AND orders.order_date <= '2003-12-31'
                  AND orders.status = "Shipped"
                GROUP BY customers.customer_no
                ORDER BY customers.customer_no ASC) total_completed_orders_2003_table
                   RIGHT JOIN
               (SELECT customers.customer_no     cust_no,
                       customers.name            cust_name,
                       COUNT(orders.order_no) AS order_no_count
                FROM customers
                         JOIN orders
                              ON customers.customer_no = orders.customer_no
                WHERE orders.order_date >= '2004-01-01'
                  AND orders.order_date <= '2004-12-31'
                  AND orders.status = "Shipped"
                GROUP BY customers.customer_no
                ORDER BY customers.customer_no ASC) total_completed_orders_2004_table
               ON total_completed_orders_2003_table.cust_no = total_completed_orders_2004_table.cust_no
                   LEFT JOIN
               (SELECT customers.customer_no     cust_no,
                       customers.name            cust_name,
                       COUNT(orders.order_no) AS order_no_count
                FROM customers
                         JOIN orders
                              ON customers.customer_no = orders.customer_no
                WHERE orders.order_date >= '2005-01-01'
                  AND orders.order_date <= '2005-12-31'
                  AND orders.status = "Shipped"
                GROUP BY customers.customer_no
                ORDER BY customers.customer_no ASC) total_completed_orders_2005_table
               ON total_completed_orders_2004_table.cust_no = total_completed_orders_2005_table.cust_no
          WHERE total_completed_orders_2003_table.order_no_count IS NULL
            AND NOT total_completed_orders_2005_table.order_no_count IS NULL
        ) table_of_returning_customers ON table_of_returning_customers.customer_name = c.name
WHERE o.status = 'Shipped'
GROUP BY c.name
ORDER BY total_amount_sold DESC
