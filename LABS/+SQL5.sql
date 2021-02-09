--Программирование T-SQL.
--1.	Разработать T-SQL-скрипт  следующего содержания: 
--1.1.	объявить переменные типа: char, varchar, datetime, time, int, smallint,  tinint, numeric(12, 5).
DECLARE @MyChar char(8),
  @MyVarchar varchar,
  @MyDateTime datetime,
  @MyTime time,
  @MyInt int,
  @MySmallInt smallint,
  @MyTinyInt tinyint,
  @MyNumeric numeric(12, 5);
--1.2.	первые две переменные проинициализировать в операторе объявления.
DECLARE @IsChar char(8) = 'Char',
  @IsVarchar varchar = 'How are you'
--1.3.	присвоить  произвольные значения следующим двум переменным с помощью оператора SET, одной из  этих переменных  присвоить значение, 
--полученное в результате запроса SELECT.
DECLARE @IsDateTime datetime,
		@IsTime time;
SET @IsTime = '23:59:59';
SELECT @IsDateTime = (cast(@IsTime as datetime)) + '31/12/2020';
print 'IsTime' + @IsTime
--1.4.	одну из переменных оставить без инициализации и не присваивать ей значения, оставшимся переменным присвоить некоторые значения с помощью 
--оператора SELECT;
DECLARE @QTY INT = (SELECT SUM(QTY) AS INT FROM ORDERS),
		@AMOUNT NUMERIC (12,2) = (SELECT CAST(AVG(AMOUNT) AS NUMERIC(12,2)) FROM ORDERS),
		@MAX TINYINT = (SELECT MAX(QTY) AS TINYINT FROM ORDERS);
--1.5.	значения половины переменных вывести с помощью оператора SELECT, значения другой половины переменных распечатать с помощью оператора PRINT. 
SELECT @IsChar 'Char', @IsVarchar 'How are you', @IsDateTime 'datetime';
PRINT CAST(@QTY AS VARCHAR(5)) + ' ' + CAST(@AMOUNT AS VARCHAR(10)) + ' ' + CAST(@MAX AS VARCHAR(3));

--SET @MyDateTime = getdate();
--SET @MyTime = getdate();
--SELECT @MySmallInt = 12;
--SELECT @MyTinyInt = 3;
--SELECT @MyNumeric;
--declare @mychar char(10) ='Welcome'

--2.	Разработать скрипт, в котором определяется средняя стоимость продукта. 
--Если средняя стоимость продукта превышает 10, то вывести количество продуктов, среднюю стоимость продукта, максимальную стоимость продукта. 
--Если средняя стоимость продукта меньше 10, то вывести минимальную стоимость продукта.
declare @maxprice int, @minprice int, @avgprice int
SET @maxprice = (select cast(max(price) as decimal (9, 2)) from products);
set @minprice = (select cast(min(price) as decimal (9, 2)) from products);
if @avgprice = 10 print 'Количество продуктов = ' + cast(@amount as varchar(5)) +
'/ средняя стоимость продукта = ' + cast(@avgprice as varchar(10)) + 
'/ максимальная стоимость продукта = ' + cast(@maxprice as varchar(10))
else if @avgprice < 10 print 'Минимальная стоимость продукта = ' + cast(@minprice as varchar(10))
else print 'Средняя стоимость продукта = 10';
go
print @maxprice
--3.	Подсчитать количество заказов сотрудника в определенный период. 
select rep, count(order_num) as orders_qty 
from orders 
where year(order_date)=2008 
group by rep;

--4.	Разработать T-SQL-скрипты, выполняющие: 
--4.1.	преобразование имени сотрудника в инициалы.
select 
	substring(name, 1, 1) + '. ' + substring(name, charindex(' ', name)
	+ 1, len(name) + charindex(' ', name)) as salesreps 
from salesreps;

--4.2.	поиск сотрудников, у которых дата найма в следующем месяце.
select 
	name,
	hire_date
from salesreps
where month(hire_date) = month(dateadd(month, 12, getdate()));

--4.3.	поиск сотрудников, которые проработали более 10 лет.
select
	name,
	hire_date,
	datediff (year, hire_date, getdate()) as more_than_10_years
from salesreps
where datediff (year, hire_date, getdate()) = 15

--4.4.	поиск дня недели, в который делались заказы.
select 
	order_num,
	order_date,
	DATEPART(day, order_date) as day_order
from orders

--5.	Продемонстрировать применение оператора IF… ELSE.
declare @x int = 350,
		@y int = 200
if @x > @y print 'TRUE'
else print 'FALSE'
go

--6.	Продемонстрировать применение оператора CASE.
declare @x int = 27
print 
(case
	when @x = 20 then 'Your 20 year old'
	when @x = 23 then 'Your 23 year old'
	when @x = 27 then 'Your 27 year old'
else 'no suit'
end)
go

--7.	Продемонстрировать применение оператора RETURN. 
declare @x int = 27,
		@y int = 23,
		@z int = 45,
		@price int
select @price = @x + @y + @z
print @price
return
go

--8.	Разработать скрипт с ошибками, в котором используются для обработки ошибок блоки TRY и CATCH. 
--Применить функции ERROR_NUMBER (код последней ошибки), ERROR_ES-SAGE (сообщение об ошибке), 
--ERROR_LINE(код последней ошибки), ERROR_PROCEDURE (имя  процедуры или NULL), 
--ERROR_SEVERITY (уровень серьезности ошибки), ERROR_ STATE (метка ошибки). 
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

--9.	Создать локальную временную таблицу из трех столбцов. 
--Добавить данные (10 строк) с использованием оператора WHILE. Вывести ее содержимое.
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