use online_food;
show tables;

select * from swiggy;

#count total rows in a table
select count(ID)
from swiggy; #op 8680

desc swiggy; #there is no primary key

#adding primary key
alter table swiggy add primary key(ID);
desc swiggy;

#total number of restaurants
select sum(Restaurant)
from swiggy; #this op will give count of repeated restaurants too

select count(distinct(Restaurant))
from swiggy; #7865. this will give all count of unique restaurants

#find restaurants which appeared more than once
#8680-7865=815. there are 815 repeated restaurants
select count(ID) - count(distinct(Restaurant)) as repeated_rest
from swiggy;
#or by using 'group by'
select Restaurant, count(Restaurant)
from swiggy
group by Restaurant
having count(Restaurant)>1;

#find total cities in the data
select count(distinct(City))
from swiggy; #9

#sort orders coming from each city in desc order
select City, count(City)
from swiggy
group by City
order by count(City) desc;

 #sort number of restaurants from each city in desc order
 select City, count(distinct(Restaurant)) as distinct_rest
 from swiggy
 group by City
 order by distinct_rest desc;

#find total orders made from each restaurant from Bangalore
select Restaurant, count(ID) as orders
from swiggy
where City='Bangalore'
group by Restaurant
order by orders desc;

#find the restaurant name with maximum orders
select Restaurant, City, count(ID) as orders
from swiggy
group by Restaurant, City
order by orders desc
limit 5;
#or
select Restaurant, City, total_orders
from (select Restaurant, City, count(ID) as total_orders,
dense_rank() over(order by count(ID) desc) as rankk
from swiggy
group by Restaurant, City) as rankings
where rankk=1;


#find top 3 restaurant names with max orders
select Restaurant, City, count(ID) as orders
from swiggy
group by Restaurant, City
order by orders desc
limit 3;


#find restaurants from Koramangala area of Bangalore who serve Chinese food
select * from swiggy;
select Restaurant, Area, City, Food_type
from swiggy
where City='Bangalore' and Area='Koramangala' and Food_type='Chinese'
group by Restaurant, Area, City, Food_type;


#find average delivery time taken by swiggy
select *from swiggy;
select avg(Delivery_time) as avg_time
from swiggy;


#find average delivery time taken by swiggy in each city
select City, avg(Delivery_time) as avg_time
from swiggy
group by City;


#find all restaurants from Mumbai, Delhi and Kolkata who serve North Indian and South Indian dishes
select * from swiggy;
select ID, City, Restaurant, Food_type
from swiggy
where City in ('Mumbai','Delhi','Kolkata') and Food_type in ('South Indian','North Indian')
group by ID, City, Restaurant, Food_type; #this query is right but incomplete becoz it gives records of Food_type which have only one single record
#but in reality there are other many records where the desired single word is present with other bunch of words in a single record.
#example Chinese. there are records with just one word chinese and also records of chinese word along with other bunch of words in a single record.
#so in this query only single word record of chinese will show in result.

#hence the right query will be
select ID, Restaurant, City, Food_type
from swiggy
where Food_type like 'South Indian''North Indian' #or 'Sou__ ____an'
having City in ('Mumbai','Delhi','Kolkata'); #40

select ID, Restaurant, City, Food_type
from swiggy
where Food_type like '%Sou__ ____an%' '%No___ ____an%'
having City in ('Mumbai','Delhi','Kolkata'); #18

select ID, Restaurant, City, Food_type
from swiggy
where Food_type like 'Chinese'
having City in ('Mumbai','Delhi','Kolkata'); #133

select ID, Restaurant, City, Food_type
from swiggy
where Food_type like '%Chi__se%'
having City in ('Mumbai','Delhi','Kolkata'); #1000

select ID, Restaurant, City, Food_type
from swiggy
where Food_type like '%Chinese%'
having City in ('Mumbai','Delhi','Kolkata'); #1000