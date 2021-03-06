select * from Customer
select * from prod_cat_info
select * from Transactions

alter table customer 
alter column DOB date

ALTer table transactions
alter column total_amt numeric(38) 
ALTer table transactions
alter column Qty numeric(38,0)
ALTer table transactions
alter column Rate numeric(38,0)
ALTer table transactions
alter column tran_date date

select convert(varchar,tran_date,20)
from Transactions

select * from transactions t1 left join prod_cat_info t2 on t1.prod_cat_code = t2.[prod_cat_code]
and t1.prod_subcat_code = t2.[prod_sub_cat_code] 
left join Customer t3 on t1.cust_id = t3.customer_Id
-----1 	
select count(*) as 'number of rows'
from Transactions 
from prod_cat_info
from  customer

----3
select convert (varchar, getdate(),3)
from tansaction_date

--q1	Which channel is most frequently used for transactions?

select top 1 store_type from transactions
group by store_type
order by count (store_type)

--q2 	What is the count of Male and Female customers in the database?

select sum(case when c.gender = 'm' then 1 else 0 end) as 'male', sum(case when c.gender = 'f' then 1 else 0 end) as 'female'
from transactions T left join customer C ON T.cust_id = C.customer_Id

--q3 From which city do we have the maximum number of customers and how many?

select top 1 c.city_code, count(t.cust_id) ' number of customers' from Transactions T left join customer C on  T.cust_id=C.customer_Id


--q4 How many sub-categories are there under the Books category?

select  prod_cat, count(prod_subcat) [subcategories] from prod_cat_info
group by prod_cat
having prod_cat='Books'

 --q5 What is the maximum quantity of products ever ordered?

 select  top 1 prod_cat_code, count(qty) [Quantity of products] from Transactions
 group by prod_cat_code
 order by [Quantity of products] desc



---Q6  What is the net total revenue generated in categories Electronics and Books?

select prod_cat ,sum(t.total_amt)[Total revenue]
from prod_cat_info t2 inner join Transactions t on t2.prod_cat_code=t.prod_cat_code
group by prod_cat
having(prod_cat='electronics' or prod_cat='books')


 --q7 How many customers have >10 transactions with us, excluding returns?


select cust_id, COUNT(transaction_id) AS Count_of_Transactions
from Transactions
where Qty >= 0
group by cust_id
having COUNT(transaction_id) > 10


--q8 	What is the combined revenue earned from the ??Electronics?? & ??Clothing?? categories, from ??Flagship stores???

select sum(t.total_amt) Revenue from Transactions T left join prod_cat_info P  on T.prod_cat_code = P.prod_cat_code and T.prod_subcat_code = P.prod_sub_cat_code
where (prod_cat='clothing' and Store_type='flagship store') or (prod_cat='electronics' and Store_type='flagship store')

--q9 What is the total revenue generated from ??Male?? customers in ??Electronics?? category? Output should display total revenue by prod sub-cat.

select sum(t1.total_amt)[total revenue],t2.prod_subcat 
from Transactions t1 
inner join prod_cat_info t2 on t1.prod_cat_code=t2.prod_cat_code and t1.prod_subcat_code=t2.prod_sub_cat_code
inner join Customer t3 on t1.cust_id=t3.customer_Id
where gender = 'M' and prod_cat = 'electronics'
group by t2.prod_subcat

 --q10 What is percentage of sales and returns by product sub category; display only top 5 sub categories in terms of sales?
 select top 5 P.prod_subcat, sum(total_amt) / (select sum(total_amt) from Transactions)  from Transactions as T
INNER JOIN prod_cat_info as P ON T.prod_subcat_code = P.prod_sub_cat_code
group by P.prod_subcat
order by sum(total_amt) / (select sum(total_amt) from Transactions) desc

 --q11 	For all customers aged between 25 to 35 years find what is the net total revenue generated by these consumers in last 30 days of transactions from max transaction date available in the data?

 SELECT SUM(t.total_amt) as Total_revenue
FROM (SELECT t.*,
             MAX(t.tran_date) OVER () as max_tran_date
      FROM Transactions t
     ) t JOIN
     Customer c
     ON t.cust_id = c.customer_Id
WHERE 30 <= DATEDIFF(day, t.tran_date, t.max_tran_date) AND 
      DATEDIFF(year,dob,GETDATE())  > 25 AND 
			DATEDIFF(year,dob,GETDATE())  <35  
			select convert(varchar,dob,20)
from Customer

--q12 Which product category has seen the max value of returns in the last 3 months of transactions?

SELECT TOP 1 prod_cat_code,SUM(Total_amt) as totalreturns 
FROM transactions
WHERE Tran_date >= DATEADD(day)
    AND Total_amt < 0
GROUP BY prod_cat_code
ORDER BY totalreturns ASC

--q13 Which store-type sells the maximum products; by value of sales amount and by quantity sold?


select store_type, MAX(total_amt) as sales, MAX(Qty) as quantity
from Transactions
group by Store_type
ORDER BY  MAX(total_amt) DESC,  MAX(Qty) DESC 

--q14 What are the categories for which average revenue is above the overall averag

SELECT P.prod_cat, AVG(total_amt) as average  
FROM Transactions T JOIN prod_cat_info P ON T.prod_cat_code = P.prod_cat_code
GROUP BY prod_cat
having avg(total_amt) > (select avg(total_amt) from Transactions)

--q15	Find the average and total revenue by each subcategory for the categories which are among top 5 categories in terms of quantity sold.
 
 select P1.prod_subcat as Product_SubCategory, 
AVG(cast(total_amt as float)) as Average_Revenue,
SUM(cast(total_amt as float)) as Total_Revenue
from Transactions as T1
INNER JOIN prod_Cat_info as P1
ON T1.prod_cat_code = P1.prod_cat_code AND T1.prod_subcat_code = 
P1.prod_sub_cat_code
group by P1.prod_subcat

