
--1
select APP.FirstName, APP.LastName, AHE.HireDate, dept.Name
from [AdventureWorks2019].[HumanResources].[Employee] as AHE, [AdventureWorks2019].[Person].[Person] as APP, 
(select max(HireDate) as highest from [AdventureWorks2019].[HumanResources].[Employee] as AHE) as t,
[AdventureWorks2019].[HumanResources].[Department] as dept, [AdventureWorks2019].[HumanResources].[EmployeeDepartmentHistory] as empdept 
where DATEDIFF(DAY,AHE.HireDate, t.highest) <=365 and AHE.BusinessEntityID =APP.BusinessEntityID and APP.BusinessEntityID = empdept.BusinessEntityID 
and empdept.DepartmentID = dept.DepartmentID

--2

select FirstName, Lastname, dept.Name,
Case when emppay.ratechangedate >= (Select DATEADD(DAY,-365, max(HireDate)) from [AdventureWorks2019].[HumanResources].[Employee])
then 'Raise' else 'No Raise'
end as Hike
from Person.Person as person,  HumanResources.Employee as emp, HumanResources.Department as dept,
HumanResources.EmployeeDepartmentHistory as depthist, HumanResources.EmployeePayHistory as emppay
where person.BusinessEntityID = emp.BusinessEntityID and dept.DepartmentID = depthist.DepartmentID and
depthist.BusinessEntityID = emp.BusinessEntityID
and emppay.BusinessEntityID = emp.BusinessEntityID


--3

select person.FirstName, person.LastName, count(salesheader.SalesOrderID) as No_Of_Orders, sum(salesheader.TotalDue) as Total_Of_Orders
from [AdventureWorks2019].[Person].[Person] as person,[AdventureWorks2019].[Sales].[SalesOrderHeader] as salesheader, [AdventureWorks2019].[Sales].[Customer] as cust
where person.BusinessEntityID = cust.PersonID and salesheader.CustomerID = cust.CustomerID
group by person.FirstName, person.LastName
order by No_Of_Orders,Total_Of_Orders

--4

SELECT * FROM Sales.CreditCard;

CREATE USER CreditCardMask WITHOUT LOGIN; 
GRANT SELECT ON Sales.CreditCard  TO CreditCardMask;

DROP INDEX AK_CreditCard_CardNumber ON Sales.CreditCard;

ALTER TABLE Sales.CreditCard  
ALTER COLUMN CardNumber VARCHAR(20) MASKED WITH (FUNCTION = 'partial(0,"****",2)');

EXECUTE AS USER = 'CreditCardMask'
SELECT * FROM Sales.CreditCard  
REVERT
GO