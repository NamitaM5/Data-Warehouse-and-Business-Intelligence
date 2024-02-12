
--Problem 1
select u.Name, t.inventorysum, sum(ASS.OrderQty) as ordersum
from [AdventureWorks2019].[Sales].[SalesOrderDetail] as ASS, (select AP.ProductID, AP.Name from [AdventureWorks2019].[Production].[Product] as AP) as u, 
(select APP.ProductID, sum(APP.Quantity) as inventorysum from [AdventureWorks2019].[Production].[ProductInventory] as APP group by APP.ProductID) as t
where u.ProductID = ASS.ProductID and ASS.ProductID = t.ProductID
group by u.Name, t.inventorysum
order by ordersum DESC

--Problem 2
select u.Name, t.inventorysum, sum(ASS.OrderQty) as ordersum into production_product_details
from [AdventureWorks2019].[Sales].[SalesOrderDetail] as ASS, (select distinct AP.ProductID, AP.Name from [AdventureWorks2019].[Production].[Product] as AP) as u, 
(select APP.ProductID, sum(APP.Quantity) as inventorysum from [AdventureWorks2019].[Production].[ProductInventory] as APP group by APP.ProductID) as t
where u.ProductID = ASS.ProductID and ASS.ProductID = t.ProductID
group by u.Name, t.inventorysum
order by ordersum DESC

Select * from production_product_details

--Problem 3
select * from production_product
where inventorysum < 100

--Problem 4
select name from Production.Product
where ProductNumber like 'FR%'

select ProductID,
name,
SUBSTRING(name,1,3) as Prefix, 
SUBSTRING(name, PATINDEX('% %',name)+1 , PATINDEX('%-%',name)-PATINDEX('% %', name)-1) as Type, 
CASE 
	WHEN name like '%W%' then 'F'
	ELSE 'M'
END as Gender, 
SUBSTRING(name,len(name)-1,3) as Size, 
SUBSTRING(name, PATINDEX('%-%',name)+1 , PATINDEX('%,%',name)- PATINDEX('%-%', name)-1) as Color 
INTO Product_Number 
from production.product 
where ProductNumber like 'FR%'; 

select * from Product_Number;
