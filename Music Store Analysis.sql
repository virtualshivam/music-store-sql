/* Easy */ 

-- 1. Who is the senior most employee based on job title?
SELECT 
    *
FROM
    employee
WHERE
    RIGHT(levels, 1) = (SELECT 
            MAX(RIGHT(levels, 1))
        FROM
            employee);

SELECT 
    *
FROM
    employee
ORDER BY levels DESC
LIMIT 1;

-- 2. Which countries have the most Invoices?
SELECT 
    billing_country, COUNT(*) as invoice_count
FROM
    invoice
GROUP BY billing_country
ORDER BY 2 DESC
LIMIT 1;


-- 3. What are top 3 values of total invoice?
SELECT 
    *
FROM
    invoice
ORDER BY total DESC
LIMIT 3;


-- 4. Which city has the best customers? We would like to throw a promotional Music
--	Festival in the city we made the most money. Write a query that returns one city that 
--	has the highest sum of invoice totals. Return both the city name & sum of all invoice 
--	totals 
SELECT 
    billing_city, SUM(total) total_spent
FROM
    invoice
GROUP BY billing_city
ORDER BY 2 DESC
LIMIT 1;


-- 5. Who is the best customer? The customer who has spent the most money will be
--	declared the best customer. Write a query that returns the person who has spent the
--	most money
SELECT 
    invoice.customer_id,
    first_name,
    last_name,
    SUM(total) AS total_spent
FROM
    invoice
        JOIN
    customer ON invoice.customer_id = customer.customer_id
GROUP BY 1 , 2 , 3
ORDER BY 2 DESC
LIMIT 1;


/* Moderate */ 

-- 1. Write query to return the email, first name, last name, & Genre of all Rock Music
-- listeners. Return your list ordered alphabetically by email starting with A
SELECT DISTINCT
    customer.email,
    customer.first_name,
    customer.last_name,
    genre.name
FROM
    customer
        JOIN
    invoice ON customer.customer_id = invoice.customer_id
        JOIN
    invoice_line ON invoice.invoice_id = invoice_line.invoice_id
        JOIN
    track ON invoice_line.track_id = track.track_id
        JOIN
    genre ON track.genre_id = genre.genre_id
WHERE
    genre.name = 'Rock'
ORDER BY customer.email;


-- 2. Let's invite the artists who have written the most rock music in our dataset. Write a
-- query that returns the Artist name and total track count of the top 10 rock bands
SELECT 
    artist.name, COUNT(track.track_id) as total_songs
FROM
    artist
        JOIN
    album ON artist.artist_id = album.artist_id
        JOIN
    track ON track.album_id = album.album_id
        JOIN
    genre ON track.genre_id = genre.genre_id
WHERE
    genre.name = 'rock'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- 3. Return all the track names that have a song length longer than the average song length.
-- Return the Name and Milliseconds for each track. Order by the song length with the
-- longest songs listed first
SELECT 
    name, milliseconds song_duration
FROM
    track
WHERE
    milliseconds > (SELECT 
            AVG(milliseconds)
        FROM
            track)
ORDER BY 2 DESC;


/* Advance */ 

-- 1. Find how much amount spent by each customer on artists? Write a query to return
-- customer name, artist name and total spent
SELECT 
    concat(customer.first_name ," ",customer.last_name) as customer_name,
    artist.name as artist_name,
    sum(track.unit_price) amount_spent
FROM
    customer
        JOIN
    invoice ON customer.customer_id = invoice.customer_id
        JOIN
    invoice_line ON invoice.invoice_id = invoice_line.invoice_id
        JOIN
    track ON invoice_line.track_id = track.track_id
        JOIN
    album ON track.album_id = album.album_id
        JOIN
    artist ON artist.artist_id = album.artist_id
group by 1,2
order by 1,3 desc;


-- 2. We want to find out the most popular music Genre for each country. We determine the
-- most popular genre as the genre with the highest amount of purchases. Write a query
-- that returns each country along with the top Genre. For countries where the maximum
-- number of purchases is shared return all Genres
select billing_country as country,name,total from  (select invoice.billing_country,genre.name,sum(invoice_line.quantity*track.unit_price) as total,
rank() over(PARTITION BY invoice.billing_country ORDER BY sum(invoice_line.quantity*track.unit_price) desc) rn from invoice
        JOIN
    invoice_line ON invoice.invoice_id = invoice_line.invoice_id
        JOIN
    track ON invoice_line.track_id = track.track_id
        JOIN genre on genre.genre_id = track.genre_id
	group by invoice.billing_country,genre.name
    order by 1,3 desc) as sub where rn=1;


-- 3. Write a query that determines the customer that has spent the most on music for each
-- country. Write a query that returns the country along with the top customer and how
-- much they spent. For countries where the top amount spent is shared, provide all
-- customers who spent this amount
select country,customer_name,total from (select customer.country, concat(customer.first_name ," ",customer.last_name) as customer_name, sum(invoice.total) as total,
rank() over(partition by customer.country order by sum(invoice.total) desc) rn
 FROM
    customer
        JOIN
    invoice ON customer.customer_id = invoice.customer_id 
    group by 1,2) sub where rn=1







