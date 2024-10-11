USE sakila;

#Creating a Customer Summary Report

# In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, 
# including their rental history and payment details. 
# The report will be generated using a combination of views, CTEs, and temporary tables.

#### Task 1: Create a View

# First, create a view that summarizes rental information for each customer.
# The view should include the customer's ID, name, email address, and total number of rentals (rental_count).


SELECT customer_id, first_name, last_name, email, COUNT(rental_id) AS rental_count
FROM customer
INNER JOIN rental
USING (customer_id)
GROUP BY customer_id;

CREATE VIEW customer_rental AS SELECT customer_id, first_name, last_name, email, COUNT(rental_id) AS rental_count
								FROM customer
								INNER JOIN rental
								USING (customer_id)
								GROUP BY customer_id
;

#### Task 2: Create Temporary Table

# Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid).
# The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

SELECT customer_id, SUM(amount) as total_paid
FROM payment
GROUP BY customer_id;

SELECT *
FROM customer_rental;

SELECT customer_id, SUM(amount) as total_paid
FROM payment AS p
INNER JOIN customer_rental AS cr
USING (customer_id)
GROUP BY customer_id;

CREATE TEMPORARY TABLE total_paid_customer AS (SELECT customer_id, SUM(amount) as total_paid
												FROM payment AS p
												INNER JOIN customer_rental AS cr
												USING (customer_id)
												GROUP BY customer_id
);

#### Task 3: Create a CTE and the Customer Summary Report

# Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2.
# The CTE should include the customer's name, email address, rental count, and total amount paid.

# Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental,
# this last column is a derived column from total_paid and rental_count.

SELECT *
FROM customer_rental
INNER JOIN total_paid_customer
USING (customer_id);

WITH cool_cte AS (SELECT *
					FROM customer_rental
					INNER JOIN total_paid_customer
					USING (customer_id)
                    )
SELECT first_name, last_name, rental_count, total_paid, ROUND((total_paid / rental_count),2) AS average_payment_per_rental
FROM cool_cte;