Q1: Who is the senior most employee based on job title?
Select * from employee
order by levels desc 
limit 1
Ans: Senior employee is Mohan Madan.

Q2: Which counrty have the most invoices?
Select count(*) as c, billing_country
from invoice
group by billing_country
order by c desc
Ans: USA and Canada have the most billing country.

Q3: What are top three values of total invoice?
Select total from invoice 
order by total desc
limit 3
Ans: 23.7599, 19.8 and 19.8 are the tope three.

Q4: Which city has the best customers? We would like to throw a promotional music fastival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals.
Select sum(total) as invoice_total, billing_city
from invoice
group by billing_city
order by invoice_total desc 
Ans: Prague has the best customers.

Q5: Who is the best customer? The customer who has spent most money will be declread the best customer. Write a query that returns the person who spent the most money.
 select customer.customer_id , customer.first_name, customer.last_name, sum(invoice.total) as total
 from customer
 join invoice on customer.customer_id = invoice.customer_id
 group by customer.customer_id
 order by total desc 
 limit 1
  Ans: The best customer is R Madhav.
 
 Q6: Write query to return the email, first name, last name, and Gener of all Rock music listners. Return your list orderd alphabetically by email starting with A.  
 Select Distinct email, first_name, last_name
 From customer 
 Join invoice on customer.customer_id = invoice.customer_id
 Join invoice_line on invoice.invoice_id = invoice_line.invoice_id
 Where track_id in(
    Select track_id from track
    join genre on track.genre_id = genre.genre_id
    Where genre.name Like 'Rock'
 )
 Order by email;
 ANS: Aaron Mitchell and email id is aaronmitchell@yahoo.ca
 
 Q7: Lets invite the artist who have written the most of the Rock Music in our dataset. Write a query that returns the Artists name and total track account of the top 10 Rock bands.
 Select artist.artist_id, artist.name, Count (artist.artist_id) as number_of_songs
 From track
 Join album on album.album_id = track.album_id
 Join artist on artist.artist_id = album.artist_id
 Join genre on genre.genre_id = track.genre_id
 Where genre.name Like 'Rock'
 Group by artist.artist_id
 Order by number_of_songs Desc
 limit 10;
 Ans: The number one artist is Led Zappelin.
 
 Q8: Return all the tracks names that have a song lenght longer than the average song lenght. Return the name and Milliseconds for each track. Order by the song lenght with the longest songs list first.
 Select name, milliseconds 
 from track 
 Where milliseconds > (
      select avg (milliseconds) as avg_track_lenght
      from track )
 Order by milliseconds desc 	  
 Ans: Occupation/Precipice
 
 Q9: How much amount spent by each customer on artists? Write a query to return the customer name, artist name, and total spent.
 With best_selleing_artist as (
   select artist.artist_id as artist_id, artist.name as artist_name, 
	sum(invoice_line.unit_price* invoice_line.quantity) as total_sales
    from invoice_line
    join track on track.track_id = invoice_line.track_id
    Join album on album.album_id = track.album_id
    join artist on artist.artist_id = album.artist_id
    group by 1
    order by 3 desc
 )
 select c.customer_id, c.first_name, c.last_name, bsa.artist_name, 
 sum (il.unit_price*il.quantity) as amount_spent
 from invoice i
 join customer c on c.customer_id = i.customer_id
 join invoice_line il on il.invoice_id = i.invoice_id
 join track t on t.track_id = il.track_id
 join album alb on alb.album_id = t.album_id
 join best_selleing_artist bsa on bsa.artist_id = alb.artist_id
 group by 1,2,3,4
 order by 5 desc;
Ans: With the help of this query we are able to see the list of the customers and how much they spend on each artist.
 
 Q10: We want to find out the most popular gener for each country. We determine the most popular gener as the gener with highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Geners.
 With popular_genre as 
 (
     Select count(invoice_line.quantity) As purchases, customer.country, genre.name, genre.genre_id,
     Row_Number() Over(Partition By customer.country Order By Count(invoice_line.quantity) desc)As RowNO
     From invoice_line
     Join invoice on invoice.invoice_id = invoice_line.invoice_id
     Join customer on customer.customer_id = invoice.customer_id
     Join track on track.track_id = invoice_line.track_id
     Join genre on genre.genre_id = track.genre_id
     Group by 2,3,4
     Order by 2 ASC, 1 Desc 
 )
 Select * From popular_genre Where RowNo <= 1
 
 Ans: All the countries favorite Genre is Rock except Argentina where the popular genre is Alternative and punk. 
 
 
Q11: Write a query that determines the customer that has spent the most on music in each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all cutomers who spent this amount.
With  Recursive
     customer_with_country as (
	 Select customer.customer_id, first_name, last_name, billing_country, sum (total) as total_spending
	 From invoice
	 Join customer on customer.customer_id = invoice.customer_id
	 Group by 1,2,3,4
	 Order by 1,5 Desc), 
	 
 country_max_spending as(
     Select billing_country, Max(total_spending) as Max_spending
     From customer_with_country 
     Group by Billing_country)
	 
Select cc.billing_country, cc.total_spending, cc.first_name, cc.last_name, cc.customer_id
From customer_with_country cc
join country_max_spending ms
On cc.billing_country = ms.billing_country
Where cc.total_spending = ms.max_spending
order by 1;
	 
Ans: Throughout this query help we are able to see the top customers list who have spent the most money in their country.
