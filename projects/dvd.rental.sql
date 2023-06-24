--Identify the top 10 customers and their email so we can reward them
SELECT concat ('first_name', ' ', 'last_name') AS full_name, email, SUM (amount) AS total_amount_paid
FROM customer c
INNER JOIN payment p ON p.customer_id = c.customer_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10;

--Identify the bottom 10 customers and their emails
SELECT concat ('first_name', ' ', 'last_name') AS full_name, email, SUM (amount) AS total_amount_paid
FROM customer c
INNER JOIN payment p ON p.customer_id = c.customer_id
GROUP BY 1,2
ORDER BY 3 ASC
LIMIT 10;

--What are the most profitable movie genres (ratings)?
SELECT category.name AS genre, COUNT (rental.customer_id) AS total_demanded,
SUM (payment.amount)AS total_sales
FROM category
INNER JOIN film_category ON category.category_id = film_category.category_id
INNER JOIN inventory ON film.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY 1
ORDER BY 2 DESC;

--How many rented movies were returned late, early, and on time?
SELECT CASE
WHEN rental_duration > date_part('day',return_date - rental_date)
THEN 'Returned Early'
WHEN rental_duration = date_part('day',return_date - rental_date)
THEN 'Returned On time'
ELSE 'Returned Late'
END AS status_of_return,
COUNT (rental.rental_id) AS total_of_rental
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY 1
ORDER BY 2 DESC;

--What is the customer base in the countries where we have a presence?
SELECT country, COUNT(customer_id) AS total_customers
FROM country
INNER JOIN city ON country.country_id = city.country_id
INNER JOIN address ON city.city_id = address.city_id
INNER JOIN customer ON address.address_id = customer.address_id
GROUP BY 1
ORDER BY 2 DESC;

--Which country is the most profitable for the business?
SELECT	country.country	AS	country_name	,	COUNT (payment.customer_id) AS total_demanded,
SUM (payment.amount)AS total_sales
FROM country
INNER JOIN city ON country.country_id = city.country_id
INNER JOIN address ON city.city_id = address.city_id
INNER JOIN customer ON address.address_id = customer.address_id
INNER JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

--What is the average rental rate per movie genre (rating)?
SELECT category.name AS genre,
AVG (rental_rate)AS average_rental_rate
FROM category
INNER	JOIN	film_category	ON	category.category_id	= film_category.category_id
INNER JOIN film ON film_category.film_id = film.film_id
GROUP BY 1