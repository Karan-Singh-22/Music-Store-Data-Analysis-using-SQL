
/* Q1: Who is the senior most employee based on job title? */

select first_name, last_name, title
from employee
order by levels desc
limit 1

/* Q2: Which countries have the most Invoices? */

select count(invoice_id) as no_of_invoices, billing_country from invoice
group by billing_country 
order by no_of_invoices desc
limit 1

/* Q3: What are top 3 values of total invoice? */

select total from invoice
order by total desc 
limit 3

/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals */

select billing_city, sum(total) 
as invoice_total from invoice
group by billing_city
order by invoice_total desc
limit 1

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money. */

select customer.first_name, customer.last_name, 
customer.customer_id, sum(invoice.total) as total
from customer join invoice 
on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total desc
Limit 1

/* Q6: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

select distinct customer.first_name, customer.last_name, customer.email from 
customer join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
join track on invoice_line.track_id = track.track_id
join genre on track.genre_id = genre.genre_id
where genre.name = 'Rock'
order by customer.email

/* Q7: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

select artist.artist_id, artist.name, count(album.artist_id) as track_count
from artist 
join album on artist.artist_id = album.artist_id
join track on album.album_id = track.album_id
join genre on track.genre_id = genre.genre_id
where genre.name = 'Rock'
group by artist.artist_id
order by track_count desc
limit 10

/* Q8: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

select name, milliseconds from track
where milliseconds > (select avg(milliseconds) from track)
order by milliseconds desc

/* Q9: Find how much amount spent by each customer on artists? 
Write a query to return customer name, artist name and total spent */

select customer.first_name, customer.last_name, artist.artist_id, artist.name, 
sum(invoice_line.unit_price * invoice_line.quantity) as total_spent 
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
join track on invoice_line.track_id = track.track_id
join album on track.album_id = album.album_id
join artist on album.artist_id = artist.artist_id
group by customer.first_name, customer.last_name, artist.artist_id, artist.name
order by total_spent desc

/* Q10: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. 
Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres. */

with popular_genre as(
select customer.country, genre.name as genre,
count(invoice_line.quantity) as purchases, 
row_number() over(partition by customer.country order by count(invoice_line.quantity) desc) as row_no
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
join track on invoice_line.track_id = track.track_id
join genre on track.genre_id = genre.genre_id
group by 1, 2
order by 1 asc ,3 desc
)
select * from popular_genre where row_no = 1

/* Q11: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

with top_customers as(
select customer.customer_id, customer.first_name, customer.last_name, customer.country,
sum(invoice.total) as total_spent,
row_number() over(partition by customer.country order by sum(invoice.total) desc) as row_no
from customer
join invoice on customer.customer_id = invoice.customer_id
group by 1, 2, 3, 4
order by 4 asc ,5 desc
)
select * from top_customers where row_no = 1




