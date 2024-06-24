use pulkit;
select * from superstore;


# Q1) What percentage of total orders were shipped on the same date?

select round(count( distinct Order_ID)/(select count(Order_ID) from superstore) *100,2)as Same_ship
FROM superstore
WHERE Order_Date = Ship_Date;


# Q2) Name top 3 customers with highest total value of orders?

select Customer_Name, sum(sales) as t_sales
from superstore
group by Customer_Name
order by sum(sales) desc
limit 3;


# Q3) Find the top 5 items with the highest average sales per day?

select Sub_Category, round(avg(Sales),2) as avg_sales
from superstore
group by Sub_Category
order by avg(Sales) desc
limit 5;

# Q4) Write a query to find the average order value for each customer, and rank the customers by their average order value?

select Customer_Name, round(avg(sales),2) as "average", dense_rank() over(order by avg(sales)) as "Rank"
from superstore
group by Customer_Name;


# Q5) Give the name of customers who ordered highest and lowest order value from each city?

with table3 as (
select City,max(Sales) as max_sales,min(Sales) as min_sales
from superstore
group by City),

highestvalue as (
select Customer_Name,max(Sales) as max_sales
from superstore
group by Customer_Name),

lowestvalue as (
select Customer_Name,min(Sales) as min_sales
from superstore
group by Customer_Name),

merge1 as (
select h.Customer_Name, h.max_sales, t.City
from highestvalue as h
inner join table3 as t
on h.max_sales = t.max_sales),

merge2 as (
select l.Customer_Name, l.min_sales, t.City
from lowestvalue as l
inner join table3 as t
on l.min_sales = t.min_sales),

final as
(
select m1.City as city ,m2.min_sales as mini_sales,m2.Customer_Name as low_cust, m1.Customer_Name as high_cust, m1.max_sales as maxi_sales
from merge1 as m1 
inner join merge2 as m2
on m1.city = m2. city
)

select city, low_cust,mini_sales,high_cust,maxi_sales
from final
order by city
;


# Q6) What is the most demanded sub-category in the west region?

select Sub_Category,sum(Sales) as cat_sales
from superstore
where Region = "West"
group by Sub_Category
order by sum(Sales) desc
limit 1;


# Q7) Which order has the highest number of items? 

select Order_Id,count(Order_Id) as order_count
from superstore
group by Order_Id
order by sum(Order_Id) desc
limit 1;


# Q8) Which order has the highest cumulative value?

select Order_Id,sum(Sales) as order_sum
from superstore
group by Order_Id
order by sum(Sales) desc
limit 1;

# Q9) Which segment’s order is more likely to be shipped via first class?

select Ship_Mode, Segment, count(Ship_Mode) as counting
from superstore
where Ship_Mode = "First Class"
group by Segment
order by count(Ship_mode) desc;


# Q10) Which city is least contributing to total revenue?

select City, sum(Sales)as total_rev
from superstore
group by City
order by sum(Sales)
limit 1;

# Q11) What is the average time for orders to get shipped after order is placed?

select round(avg(Ship_date-Order_Date),4) as avg_time
from superstore;
#select avg(datediff(Ship_date,Order_Date)) as avg_time
#from superstore ;

# Q12) Which segment places the highest number of orders from each state and which segment places the largest individual orders from each state?

with table1 as
(
select State, Segment,count(Segment) as counting, rank() over(partition by State order by count(Order_Id) desc) as ranking
from superstore
group by State, Segment
)
select State, Segment, counting
from table1
where ranking = 1;



