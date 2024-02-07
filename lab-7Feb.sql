USE sakila;
SELECT 
    title, 
    DATEDIFF(return_date, rental_date) AS rental_duration, 
    AVG(DATEDIFF(return_date, rental_date)) AS avg_rental_duration
FROM 
    rental
JOIN 
    inventory ON rental.inventory_id = inventory.inventory_id
JOIN 
    film ON inventory.film_id = film.film_id
GROUP BY 
    title, DATEDIFF(return_date, rental_date);

SELECT title, rental_duration,
avg(rental_duration) over (partition by title) as average_rental_duration  -- window funciton for average
from film;

SELECT 
    title, 
    rental_duration,
    AVG(rental_duration) OVER () AS average_rental_duration
FROM 
    film;
select * from payment;
-- 2 Calculate the average payment amount for each staff member:¶

select staff_id, 
avg(amount) over (partition by staff_id) as avg_payment_amount
from payment;

select avg(amount), staff_id
from payment 
group by staff_id;


-- 3 Calculate the total revenue for each customer, showing the running total within each customer's rental history:
SELECT 
    r.rental_id, 
    r.rental_date, 
    p.amount, 
    SUM(p.amount) OVER (PARTITION BY p.customer_id ORDER BY r.rental_date) AS running_total
FROM 
    rental r
JOIN 
    payment p ON r.rental_id = p.rental_id;
    
-- 4 Determine the quartile for the rental rates of films:
SELECT
    title,
    rental_rate,
    NTILE(4) OVER (ORDER BY rental_rate) AS quartile
FROM
    film;

-- 5 Determine the first and last rental date for each customer:
SELECT 
    customer_id,
    MIN(rental_date) AS first_rental_date,
    MAX(rental_date) AS last_rental_date
FROM 
    rental
GROUP BY 
    customer_id;
    
-- 6 Calculate the rank of customers based on their rental counts:¶

select customer_id,
    RANK() OVER (ORDER BY count(customer_id) DESC) AS RankByAmount
FROM
    rental
    group by customer_id;

-- 7. Calculate the running total of revenue per day for the 'G' film category:
SELECT
	title,
  payment_date,
  amount,
  SUM(amount) OVER (ORDER BY payment_date) AS daily_revenue
FROM
  payment
JOIN
  rental ON payment.rental_id = rental.rental_id
JOIN
  inventory ON rental.inventory_id = inventory.inventory_id
JOIN
  film ON inventory.film_id = film.film_id
WHERE
  film.rating = 'G'
ORDER BY
  payment_date;

-- 8 Assign a unique ID to each payment within each customer's payment history:¶
    select customer_id, payment_id, 
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY payment_date) AS payment_sequence_id 
    from payment;

-- 9 Calculate the difference in days between each rental and the previous rental for each customer:
SELECT 
    customer_id,
    rental_date,
    LAG(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date) AS previous_rental_date,
    DATEDIFF(rental_date, LAG(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date)) AS days_between_rentals
FROM 
    rental
ORDER BY 
    customer_id, rental_date;



