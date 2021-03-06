
/* LAB 2 A Which line item description was recorded most often for each month?
We need to get the month from a table and the description from a table.
Then we need to count the unique line item description and display the max of those for each month
SELECT month,description, max description
	FROM table with month JOIN with table which has description
	GROUP BY month to see totals for each month*/
SELECT mm,descriptions,MAX(times_purchased) FROM (SELECT DATE_FORMAT(invoices.invoice_date,'%m') AS 'mm',
          invoice_line_items.line_item_description AS descriptions,
     COUNT(invoice_line_items.line_item_description) AS times_purchased
   FROM invoices INNER JOIN invoice_line_items
   ON invoices.invoice_id=invoice_line_items.invoice_id
   GROUP BY MM,descriptions ORDER BY MM, times_purchased DESC) AS query
   GROUP BY MM;
/*Query month, descriptions and the max times purchased from the subquery of getting the month, and count of descriptions joint on ID. 
Then group all by month*/
/* 
+------+------------------+----------------------+
| mm   | descriptions     | MAX(times_purchased) |
+------+------------------+----------------------+
| 04   | Freight          |                    8 |
| 05   | Freight          |                   11 |
| 06   | Freight          |                   15 |
| 07   | Freight          |                   16 |
| 08   | Health Insurance |                    1 |
+------+------------------+----------------------+*/
 
CREATE TEMPORARY TABLE lab2a SELECT DATE_FORMAT(invoices.invoice_date,'%m') AS 'mm',
          invoice_line_items.line_item_description AS descriptions,
     COUNT(invoice_line_items.line_item_description) AS times_purchased
   FROM invoices INNER JOIN invoice_line_items
   ON invoices.invoice_id=invoice_line_items.invoice_id
   GROUP BY mm,descriptions ORDER BY mm, times_purchased DESC;
/* Create a temp table from the select of invoices and line items and join them on ID. 
Group by month then descriptions then order by month and times purchased descinding */
 
SELECT mm,descriptions,MAX(times_purchased) FROM lab2a GROUP BY mm;
/* Select the month, descriptions and then get the max of the count of the descriptions from the temp table. 
Group by month to show each months max.*/
/*
+------+------------------+----------------------+
| mm   | descriptions     | MAX(times_purchased) |
+------+------------------+----------------------+
| 04   | Freight          |                    8 |
| 05   | Freight          |                   11 |
| 06   | Freight          |                   15 |
| 07   | Freight          |                   16 |
| 08   | Health Insurance |                    1 |
+------+------------------+----------------------+
*/

/* LAB 2 B  Which vendor had the lowest sales for the entire time? 
We need to get the payment for the vendors and then add it all together. Then limit it to the lowest 5.

CREATE TEMP TABLE SELECT vendor, vendor id, sum of payment totals
	From table with vendor names and id JOIN with table that has payment totals and joint on ID
	Group by id to get it in order of id
SELECT all columns then group by totals and limit to 5 to get the lowest 5*/

CREATE TEMPORARY TABLE lab2b SELECT vendors.vendor_name,
       vendors.vendor_id,
       SUM(invoices.payment_total) AS payment_totals 
FROM invoices INNER JOIN vendors 
	ON invoices.vendor_id=vendors.vendor_id 
GROUP BY vendors.vendor_id;
/* Create temp table from select of vendor name, id and sum of payment_total joint on id from table invoices and vendors. 
Group by vendors vendor id so each ID has a total. */

SELECT * FROM lab2b GROUP BY payment_totals LIMIT 5;
/* Select all columns from the temp table group by the total paid then limit to the least 5*/
/*
+---------------------------+-----------+----------------+
| vendor_name               | vendor_id | payment_totals |
+---------------------------+-----------+----------------+
| Ford Motor Credit Company |       106 |           0.00 |
| Suburban Propane          |       117 |          16.62 |
| Abbey Office Furnishings  |        94 |          17.50 |
| Compuserve                |        97 |          19.90 |
| Coffee Break Service      |       102 |          41.80 |
+---------------------------+-----------+----------------+
*/

/* LAB 2 C  Which month was closest to the average monthly sales?
We need to get the average of monthly sales by getting the total of each month and averaging it. Then compare the months sale to the average and find the closest

CREATE TEMP TABLE SELECT month,sum of payment totals
FROM table with invoices
GROUP BY month to get total for each month

Create variable to hold average of month totals

SELECT month, payment total, difference of month sales to average, average
FROM temp table created
ORDER by difference and limit to 1 to get the closest*/

CREATE TEMPORARY TABLE lab2c SELECT DATE_FORMAT(invoices.invoice_date,'%m') AS 'mm',
		SUM(invoices.payment_total) AS payment_totals
FROM invoices
GROUP BY mm;
/* Create a temp table with columns month, and sum of payment total. Group by month to get total for each month*/

SELECT @average_total:= ROUND(AVG(payment_totals),2) FROM lab2c;
/*Create a run time variable that gets an average of the payment totals and rounds to the 2nd decimal */
/*
+-----------------------------------------------+
| @average_total:= ROUND(AVG(payment_totals),2) |
+-----------------------------------------------+
|                                      35714.83 |
+-----------------------------------------------+
*/

SELECT mm AS month, 
	payment_totals,
	ROUND(ABS(@average_total-payment_totals),2) AS diffFromAvg,
	@average_total AS Average 
FROM lab2c 
ORDER BY diffFromAvg LIMIT 1;
/*Select month,payment total, difference of total and average, then average. 
Order by the difference and limit it to 1 so we get the smallest difference. */
/*
+-------+----------------+-------------+----------+
| month | payment_totals | diffFromAvg | Average  |
+-------+----------------+-------------+----------+
| 06    |       54217.73 |    18502.90 | 35714.83 |
+-------+----------------+-------------+----------+
*/

	