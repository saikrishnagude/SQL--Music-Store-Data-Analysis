create database music_store;

use music_store;

/* --------------------------   Who is the senior most employee based on job title?--------------------------------- */

select *  from employee order by levels desc limit 1;

/*------------------------------  Which countries have the most invoices-------------------------------------------- */

select count(*) as c,billing_country from invoice group by billing_country order by c desc;

/*-------------------------------What are top 3 values of total invoices--------------------------------------------*/

select total from invoice order by total desc limit 3; 

/*------------------------------- Which city has the best customers--------------------------------------------------*/

select sum(total) as invoice_total ,billing_city from invoice group by billing_city order by invoice_total desc;

/*------------------------------- Who is the best customer and spent more money -------------------------------------*/

select customer.customer_id, customer.first_name, customer.last_name, sum(invoice.total) as total from customer 
join invoice on customer.customer_id = invoice.customer_id group by customer.customer_id,customer.first_name, 
customer.last_name order by total desc limit 1;

/*-----------------Write a query to return the email, first name, last name & Genre of all rock music listeners-------
------------------------ Return your list ordered alphabetically by email -------------------------------------------*/

select distinct email, first_name, last_name from customer 
join invoice on customer.customer_id = invoice.customer_id 
join invoice_line on invoice.invoice_id = invoice_line.invoice_id 
where track_id in (select track_id from track
join genre on track.genre_id = genre.genre_id where genre.name like "Rock") order by email;

/*------------------- Write a query that returns the artist name and total track count of top 10 rock bands----------*/

select artist.artist_id, artist.name, count(artist.artist_id) as number_of_songs from track
join album on album.album_id = track.album_id join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre.id where genre.name like "Rock"
group by artist.artist_id order by number_of_songs desc limit 10;

/*----------------- Return the name and millisecond for each track order by the song lenght with the longest song ---*/

select name, milliseconds from track 
where milliseconds > (select avg(milliseconds) as avg_track_lenght from track)
order by  milliseconds desc;

/*------------------ Write a query that returns the country along with the top customer and how much they spent -----*/
WITH Customer_country as 
(select customer.customer_id, first_name, last_name,billing_country,sum(total) as total_spending,
row_number() over(partition by billing_country order by sum(total) desc) as RowNo
from invoice
join customer on customer.customer_id = invoice.customer_id
group by 1,2,3,4 order by 4 asc, 5 desc)
select * from customer_with_country where RowNo <=1 ;

/*-------------------------------------------------------------------------------------------------------------------*/



