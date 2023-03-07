/*
 SQL For Machine Learning: Allan Carlo T. Ramos
 Description: Shows the solution for the question in the Machine Learning
 Date Created: March 7, 2023
 Log Changes:
 -  March 7 2023   | Allan Carlo T. Ramos |    Initial Draft
 */

use fillians_toy_shop;

SELECT total_completed_orders_2003_table.cust_no,
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
     ON total_completed_orders_2003_table.cust_no = total_completed_orders_2005_table.cust_no;

SELECT total_completed_orders_2004_table.cust_no,
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
     ON total_completed_orders_2004_table.cust_no = total_completed_orders_2005_table.cust_no;



