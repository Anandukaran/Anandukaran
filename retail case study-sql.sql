--SQL Advance Case Study


--Q1--BEGIN 
	
	select count(*) from Transactions
select count(*) from Customer
select count(*) from prod_cat_info




--Q1--END

--Q2--BEGIN
	
	select count(distinct transaction_id)[no of transaction] from transactions
where qty <0








--Q2--END

--Q3--BEGIN      
	
	Alter table Transactions alter column tran_date date









--Q3--END

--Q4--BEGIN

select datediff(day,min(tran_date),max(tran_date))[day] from Transactions
select datediff(month,min(tran_date),max(tran_date))[month] from Transactions
select datediff(year,min(tran_date),max(tran_date))[year] from Transactions





--Q4--END

--Q5--BEGIN

SELECT prod_cat from prod_cat_info
where prod_subcat='DIY'













--Q5--END
--data analysis
--Q1--BEGIN

select top 1 store_type from transactions
group by store_type
order by count(store_type) desc

--Q1--END
	
--Q2--BEGIN  
	select count(gender)[female] from Customer

where gender='F' 

select count(gender)[male] from Customer

where gender='M'
	

--Q2--END

--Q3--BEGIN
select top 1 city_code from Customer
group by city_code
order by count(customer_id) desc


--Q3--END

--Q4--BEGIN
select count(prod_subcat)[number of sub-categories] from prod_cat_info
where prod_cat='books'
	

--Q4--END

--Q5--BEGIN
select max(qty) from transactions	

--Q5--END

--Q6--BEGIN	
select sum(total_amt)[net revenue] from transactions t 
inner join prod_cat_info p on t.prod_cat_code=p.prod_cat_code and t.prod_subcat_code=p.prod_sub_cat_code
where prod_cat in('electronics','books')

--Q6--END

--Q7--BEGIN	
select count(cust_id)[Number of customers] from ((select  cust_id,count(transaction_id)[transactions],sum(qty)[quantity] from transactions t 
where (qty)>0 
group by cust_id
having count(transaction_id )>10 )) t

--Q7--END

--Q8--BEGIN	

select sum(amt)[total revenue] from (
select sum(total_amt)[amt],
prod_cat,Store_type
from Transactions t inner join prod_cat_info p on t.prod_cat_code=p.prod_cat_code and t.prod_subcat_code=p.prod_sub_cat_code
where prod_cat in ('electronics','clothing') 
group by prod_cat,Store_type
having
Store_type='flagship store')r

--Q8--END


--Q9--BEGIN	

select sum(total_amt)[amt],
prod_subcat,Gender
from Transactions t inner join prod_cat_info p on t.prod_subcat_code=p.prod_sub_cat_code
inner join Customer c on c.customer_Id=t.cust_id
where prod_cat = 'Electronics' 
group by gender,prod_subcat
having
gender='M'

--Q9--END

--Q10--BEGIN	
 Select t1.prod_subcat,[Percentage sales],[Percentage returns] from
 (Select top 5 prod_subcat,sum(total_amt) /(select sum(total_amt) from Transactions)*100[Percentage sales] 
 from Transactions t
 inner join prod_cat_info p on t.prod_cat_code = p.prod_cat_code and t.prod_subcat_code=p.prod_sub_cat_code
 group by prod_sub_cat_code, prod_subcat
 order by sum(total_amt) desc)t1
 inner join
 (Select prod_subcat,sum(qty)/(Select sum(qty)*0.01 from Transactions where qty<0)[Percentage returns]
 from Transactions t2 inner join  prod_cat_info p on t2.prod_subcat_code = p.prod_sub_cat_code
 where Qty<0
 group by  prod_subcat
)t on t1.prod_subcat=t.prod_subcat
order by [Percentage sales] desc,[Percentage returns] desc
--Q10--END

--Q11--BEGIN	

with cte5 as(
select 
total_amt,
customer_Id,datediff(year,DOB,getdate())[age],dob
from Customer c inner join Transactions t on c.customer_Id=t.cust_id
where datediff(year,DOB,getdate()) between 25 and 35 and tran_Date =(dateadd(day,-30,(select max(tran_date) from Transactions))))
select sum(total_amt)[net revenue] from cte5

--Q11--END


--Q12--BEGIN	
select top 1 prod_cat from Transactions t inner join prod_cat_info p on p.prod_cat_code=t.prod_cat_code
where tran_date between dateadd(month,-3,(select max(tran_date) from transactions)) and (select max(tran_date) from transactions)
and qty<0
group by prod_cat
order by sum(qty) desc

--Q12--END


--Q13--BEGIN
select top 1 store_type from transactions
where qty>0
group by store_type
order by sum(total_amt) desc,sum(qty) desc

--Q13--END

--Q14--BEGIN

select prod_cat from Transactions t inner join prod_cat_info p on t.prod_cat_code=p.prod_cat_code
group by prod_cat
having avg(total_amt)>(select avg(total_amt) from Transactions)

--Q14--END

--Q15--BEGIN
with cte8 as (
select top 5 prod_cat from transactions t inner join prod_cat_info p on t.prod_cat_code=p.prod_cat_code
group by prod_cat
order by sum(qty) desc)

select prod_subcat, avg(total_amt)[average revenue],sum(total_amt)[total revenue] from Transactions t inner join prod_cat_info p on t.prod_subcat_code=p.prod_sub_cat_code
where prod_cat in (select * from cte8)
group by prod_subcat


--Q15--END



