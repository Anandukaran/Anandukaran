--SQL Advance Case Study


--Q1--BEGIN 

select distinct State from FACT_TRANSACTIONS f inner join DIM_LOCATION dl on f.IDLocation=dl.IDLocation
where date between  '01-01-2005' and getdate()



--Q1--END

select * from DIM_MANUFACTURER
--Q2--BEGIN
	
select top 1 state,sum(quantity)[quantity] from dim_manufacturer dm 
inner join dim_model dmo on dm.idmanufacturer=dmo.IDManufacturer
inner join FACT_TRANSACTIONS ft on dmo.IDModel=ft.IDModel
inner join DIM_LOCATION dl on ft.IDLocation=dl.IDLocation
where Manufacturer_Name='samsung' and Country='US'
group by state
order by sum(quantity) desc


--Q2--END

--Q3--BEGIN      

select count(idcustomer)[Number of transactios],Model_Name from DIM_MODEL dm 
inner join FACT_TRANSACTIONS ft on dm.IDModel=ft.IDModel
inner join DIM_LOCATION dl on ft.IDLocation=dl.IDLocation
group by Model_Name,ZipCode,State
	

--Q3--END

--Q4--BEGIN

select top 1 Manufacturer_Name, Model_Name, Unit_price from  DIM_MODEL dl 
inner join FACT_TRANSACTIONS ft on dl.IDModel=ft.IDModel 
inner join DIM_MANUFACTURER dm on dm.IDManufacturer=dl.IDManufacturer
order by Unit_price

--Q4--END

--Q5--BEGIN
--Find out the average price for each model in the top5 manufacturers in 
--terms of sales quantity and order by average price.

select avg(TotalPrice)[avg price],Model_Name,Manufacturer_Name from FACT_TRANSACTIONS ft 
inner join DIM_MODEL dm on ft.IDModel=dm.IDModel
inner join DIM_MANUFACTURER dma on dma.IDManufacturer=dm.IDManufacturer 
where Manufacturer_Name in (select top 5 Manufacturer_Name from FACT_TRANSACTIONS ft 
inner join DIM_MODEL dm on ft.IDModel=dm.IDModel
inner join DIM_MANUFACTURER dma on dma.IDManufacturer=dm.IDManufacturer 
group by Manufacturer_Name
order by sum(Quantity) desc) 
group by Model_Name,Manufacturer_Name
order by [avg price] desc





--Q5--END

--Q6--BEGIN

--List the names of the customers and the average amount spent in 2009, 
--where the average is higher than 500
select Customer_Name,avg(totalprice)[avg amount] from DIM_CUSTOMER dc inner join FACT_TRANSACTIONS ft on dc.IDCustomer=ft.IDCustomer
where year(date) = '2009'
group by Customer_Name
having avg(totalprice) >500


--Q6--END
	
--Q7--BEGIN  
	
--	List if there is any model that was in the top 5 in terms of quantity, 
--simultaneously in 2008, 2009 and 2010 

select model_name from FACT_TRANSACTIONS ft inner join DIM_MODEL dm on ft.IDModel=dm.IDModel where year(date)='2008'
group by Model_Name
having sum(quantity) in (select top 5 sum(quantity) from FACT_TRANSACTIONS where year(date)='2008' group by IDModel order by sum(quantity) desc)
intersect
select model_name from FACT_TRANSACTIONS ft inner join DIM_MODEL dm on ft.IDModel=dm.IDModel where year(date)='2009'
group by Model_Name
having sum(quantity) in (select top 5 sum(quantity) from FACT_TRANSACTIONS where year(date)='2009' group by IDModel order by sum(quantity) desc)
intersect
select model_name from FACT_TRANSACTIONS ft inner join DIM_MODEL dm on ft.IDModel=dm.IDModel where year(date)='2010'
group by Model_Name
having sum(quantity) in (select top 5 sum(quantity) from FACT_TRANSACTIONS where year(date)='2010' group by IDModel order by sum(quantity) desc)





--Q7--END	
--Q8--BEGIN
--. Show the manufacturer with the 2nd top sales in the year of 2009 and the 
--manufacturer with the 2nd top sales in the year of 2010. 
with cte1 as (select Manufacturer_Name, rank() over ( order by sum(totalprice) desc)[RANK] from FACT_TRANSACTIONS ft
inner join DIM_MODEL dm on ft.IDModel=dm.IDModel 
inner join DIM_MANUFACTURER dma on dm.IDManufacturer=dma.IDManufacturer 
inner join dim_date dd on dd.date=ft.Date
where [year]='2009' 
group by dma.Manufacturer_Name
union all
select Manufacturer_Name, rank() over ( order by sum(totalprice) desc)[RANK] from FACT_TRANSACTIONS ft
inner join DIM_MODEL dm on ft.IDModel=dm.IDModel 
inner join DIM_MANUFACTURER dma on dm.IDManufacturer=dma.IDManufacturer 
inner join dim_date dd on dd.date=ft.Date
where [year]='2010' 
group by dma.Manufacturer_Name)
select manufacturer_name from cte1
where [rank]=2

 
















--Q8--END
--Q9--BEGIN
--9. Show the manufacturers that sold cellphones in 2010 but did not in 2009. 

 select Manufacturer_Name from  DIM_MANUFACTURER dm 
 inner join DIM_MODEL dml on dm.IDManufacturer=dml.IDManufacturer
 inner join FACT_TRANSACTIONS ft on dml.IDModel=ft.IDModel
 inner join DIM_DATE dd on ft.Date=dd.DATE
 where year in ('2009','2010')
except 
select Manufacturer_Name from  DIM_MANUFACTURER dm 
 inner join DIM_MODEL dml on dm.IDManufacturer=dml.IDManufacturer
 inner join FACT_TRANSACTIONS ft on dml.IDModel=ft.IDModel
 inner join DIM_DATE dd on ft.Date=dd.DATE
 where year in ('2009')













--Q9--END

--Q10--BEGIN
--Find top 100 customers and their average spend, average quantity by each 
--year. Also find the percentage of change in their spend.	


 create view q as
 (Select top 100 f.IDCustomer, Customer_Name from DIM_CUSTOMER c inner join FACT_TRANSACTIONS f on c.IDCustomer=f.IDCustomer
 group by f.IDCustomer,Customer_Name
 order by sum(TotalPrice) desc)

 create view q1 as
 (Select Customer_Name,avg(TotalPrice)[Average spend],avg(Quantity)[Average quantity], sum(TotalPrice)[Total Spend],
 lag(sum (TotalPrice)) over(Partition by q.Customer_Name order by year(date))[lag]from FACT_TRANSACTIONS f inner join q
 on f.IDCustomer=q.IDCustomer
 Group by q.Customer_Name,year([date]))

 Select q.Customer_Name, [Average spend],[Average quantity],([Total Spend] - [lag])*100/[lag]
 [Percent change of spend] from q inner join q1 on   q.Customer_Name=q1.Customer_Name  

 























--Q10--END
	