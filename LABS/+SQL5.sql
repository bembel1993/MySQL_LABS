--���������������� T-SQL.
--1.	����������� T-SQL-������  ���������� ����������: 
--1.1.	�������� ���������� ����: char, varchar, datetime, time, int, smallint,  tinint, numeric(12, 5).
DECLARE @MyChar char(8),
  @MyVarchar varchar,
  @MyDateTime datetime,
  @MyTime time,
  @MyInt int,
  @MySmallInt smallint,
  @MyTinyInt tinyint,
  @MyNumeric numeric(12, 5);
--1.2.	������ ��� ���������� ������������������� � ��������� ����������.
DECLARE @IsChar char(8) = 'Char',
  @IsVarchar varchar = 'How are you'
--1.3.	���������  ������������ �������� ��������� ���� ���������� � ������� ��������� SET, ����� ��  ���� ����������  ��������� ��������, 
--���������� � ���������� ������� SELECT.
DECLARE @IsDateTime datetime,
		@IsTime time;
SET @IsTime = '23:59:59';
SELECT @IsDateTime = (cast(@IsTime as datetime)) + '31/12/2020';
print 'IsTime' + @IsTime
--1.4.	���� �� ���������� �������� ��� ������������� � �� ����������� �� ��������, ���������� ���������� ��������� ��������� �������� � ������� 
--��������� SELECT;
DECLARE @QTY INT = (SELECT SUM(QTY) AS INT FROM ORDERS),
		@AMOUNT NUMERIC (12,2) = (SELECT CAST(AVG(AMOUNT) AS NUMERIC(12,2)) FROM ORDERS),
		@MAX TINYINT = (SELECT MAX(QTY) AS TINYINT FROM ORDERS);
--1.5.	�������� �������� ���������� ������� � ������� ��������� SELECT, �������� ������ �������� ���������� ����������� � ������� ��������� PRINT. 
SELECT @IsChar 'Char', @IsVarchar 'How are you', @IsDateTime 'datetime';
PRINT CAST(@QTY AS VARCHAR(5)) + ' ' + CAST(@AMOUNT AS VARCHAR(10)) + ' ' + CAST(@MAX AS VARCHAR(3));

--SET @MyDateTime = getdate();
--SET @MyTime = getdate();
--SELECT @MySmallInt = 12;
--SELECT @MyTinyInt = 3;
--SELECT @MyNumeric;
--declare @mychar char(10) ='Welcome'

--2.	����������� ������, � ������� ������������ ������� ��������� ��������. 
--���� ������� ��������� �������� ��������� 10, �� ������� ���������� ���������, ������� ��������� ��������, ������������ ��������� ��������. 
--���� ������� ��������� �������� ������ 10, �� ������� ����������� ��������� ��������.
declare @maxprice int, @minprice int, @avgprice int
SET @maxprice = (select cast(max(price) as decimal (9, 2)) from products);
set @minprice = (select cast(min(price) as decimal (9, 2)) from products);
if @avgprice = 10 print '���������� ��������� = ' + cast(@amount as varchar(5)) +
'/ ������� ��������� �������� = ' + cast(@avgprice as varchar(10)) + 
'/ ������������ ��������� �������� = ' + cast(@maxprice as varchar(10))
else if @avgprice < 10 print '����������� ��������� �������� = ' + cast(@minprice as varchar(10))
else print '������� ��������� �������� = 10';
go
print @maxprice
--3.	���������� ���������� ������� ���������� � ������������ ������. 
select rep, count(order_num) as orders_qty 
from orders 
where year(order_date)=2008 
group by rep;

--4.	����������� T-SQL-�������, �����������: 
--4.1.	�������������� ����� ���������� � ��������.
select 
	substring(name, 1, 1) + '. ' + substring(name, charindex(' ', name)
	+ 1, len(name) + charindex(' ', name)) as salesreps 
from salesreps;

--4.2.	����� �����������, � ������� ���� ����� � ��������� ������.
select 
	name,
	hire_date
from salesreps
where month(hire_date) = month(dateadd(month, 12, getdate()));

--4.3.	����� �����������, ������� ����������� ����� 10 ���.
select
	name,
	hire_date,
	datediff (year, hire_date, getdate()) as more_than_10_years
from salesreps
where datediff (year, hire_date, getdate()) = 15

--4.4.	����� ��� ������, � ������� �������� ������.
select 
	order_num,
	order_date,
	DATEPART(day, order_date) as day_order
from orders

--5.	������������������ ���������� ��������� IF� ELSE.
declare @x int = 350,
		@y int = 200
if @x > @y print 'TRUE'
else print 'FALSE'
go

--6.	������������������ ���������� ��������� CASE.
declare @x int = 27
print 
(case
	when @x = 20 then 'Your 20 year old'
	when @x = 23 then 'Your 23 year old'
	when @x = 27 then 'Your 27 year old'
else 'no suit'
end)
go

--7.	������������������ ���������� ��������� RETURN. 
declare @x int = 27,
		@y int = 23,
		@z int = 45,
		@price int
select @price = @x + @y + @z
print @price
return
go

--8.	����������� ������ � ��������, � ������� ������������ ��� ��������� ������ ����� TRY � CATCH. 
--��������� ������� ERROR_NUMBER (��� ��������� ������), ERROR_ES-SAGE (��������� �� ������), 
--ERROR_LINE(��� ��������� ������), ERROR_PROCEDURE (���  ��������� ��� NULL), 
--ERROR_SEVERITY (������� ����������� ������), ERROR_ STATE (����� ������). 
DECLARE @X int = 34, @Y int = 0, @Z int;
BEGIN TRY
 SET @Z = @X/@Y; -- ERR
END TRY
BEGIN CATCH
 PRINT 'Block CATCH'
 PRINT ERROR_NUMBER()
 PRINT ERROR_MESSAGE()
 PRINT ERROR_LINE()
 PRINT ERROR_PROCEDURE()
 PRINT ERROR_SEVERITY()
 PRINT ERROR_STATE()
END CATCH
GO

--9.	������� ��������� ��������� ������� �� ���� ��������. 
--�������� ������ (10 �����) � �������������� ��������� WHILE. ������� �� ����������.
DECLARE 
	@number INT, 
	@factorial INT
PRINT 'RANGE:'
SET @factorial = 1;
SET @number = 5;
WHILE @number > 0
    BEGIN
        SET @factorial = @factorial * @number
		SET @number = @number - 1
		PRINT @factorial
END;
PRINT 'FACTORIAL EQUAL: '
PRINT @factorial