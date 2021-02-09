--1.	Разработать курсор, который выводит все данные о клиенте.
select * from customers

DECLARE CURSOR_CUST CURSOR--1
	FOR SELECT * FROM CUSTOMERS -- КУРСОР СОЗДАЕТСЯ НА ОСНОВЕ ОПЕРАТОРА SELECT--1
OPEN CURSOR_CUST --ДЛЯ ТОГО ЧТОБЫ ЧИТАТЬ СТРОКИ--2

WHILE @@FETCH_STATUS = 0
BEGIN
FETCH NEXT FROM CURSOR_CUST -- ЧТЕНИЕ ОДНОЙ СТРОКИ ИЗ FOR SELECT--3
END

CLOSE CURSOR_CUST -- ЗАКРЫТЬ КУРСОР
DEALLOCATE CURSOR_CUST -- УДАЛИТЬ КУРСОР
------------------------------------------------------
--ПЕРЕМЕННЫЕ ДЛЯ РАБОТЫ
DECLARE @cust_num INT 
DECLARE @company VARCHAR(50) 
DECLARE @cust_rep INT, @credit_limit INT
--СОЗДАЕМ КУРСОР
DECLARE custr CURSOR FOR
	SELECT cust_num, company, cust_rep, credit_limit FROM customers
--ОТКРЫВАЕМ КУРСОР
	OPEN custr
--ОСУЩЕСТВОЯЕМ ВЫБОРКУ
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @cust_num, @company, @cust_rep, @credit_limit
FETCH NEXT FROM custr INTO @cust_num, @company, @cust_rep, @credit_limit 
END
CLOSE custr
DEALLOCATE custr
-------------------------------------------------------------
	SET @CURSOR_CUST = CURSOR	
	FOR SELECT CUST_NUM, COMPANY, CUST_REP, CREDIT_LIMIT FROM CUSTOMERS

OPEN @CURSOR_CUST 

FETCH NEXT FROM @@CURSOR_CUST INTO @CUS, @COMP, @CUST_REP, @CURSOR_CUST

WHILE @@FETCH_STATUS = 0
BEGIN
PRINT 'CUST '
FETCH NEXT FROM @CURSOR_CUST INTO @CUS, @COMP, @CUST_REP, @CURSOR_CUST
END

CLOSE CURSOR_CUST
DEALLOCATE CURSOR_CUST
-------------------------------------------------------
DECLARE @cust_num1 int, @company1 varchar(15),@message varchar(80),  @cust_rep1 int,
    @credit_limit1 decimal(9, 2);
DECLARE customers_cursor CURSOR 
FOR  
SELECT cust_num, company, cust_rep, credit_limit FROM customers;
 
OPEN customers_cursor;--ОТКРЫТЬ КУРСОР

FETCH FROM customers_cursor INTO @cust_num1, @company1, @cust_rep1,
@credit_limit1;
 --fech 
WHILE @@FETCH_STATUS = 0 -- ВОЗВРАЩАЕТ 0, ЕСЛИ ЧТЕНИЕ ИЗ КУРСОРА ПРОИЗОШЛО УДАЧНО
BEGIN 
   SELECT @message = cast(@cust_num1 as varchar(10))+ ' ' + @company1 + ' ' + @cust_rep1+ ' ' +
      cast(@credit_limit1 as varchar(10));
   PRINT @message; 
   FETCH FROM customers_cursor INTO @cust_num1, @company1, @cust_rep1, @credit_limit1;
END ;
CLOSE customers_cursor; 
DEALLOCATE customers_cursor; 

--2.	Разработать курсор, который выводит все данные о сотрудниках офисов и их количество.
select * from salesreps
DECLARE @empl_num int, @name varchar(15),  @message1 varchar(80),
    @age int, @rep_office int, @title varchar(10),  @manager int, @quota decimal(8, 2), @sales decimal(8, 2);
DECLARE salesreps_cursor CURSOR FOR  
SELECT empl_num, name, age, rep_office, title,  manager, quota, sales FROM salesreps;
 
OPEN salesreps_cursor;
 
FETCH FROM salesreps_cursor INTO @empl_num, @name, @age, @rep_office, @title, @manager, @quota, @sales;
 
WHILE @@FETCH_STATUS = 0 
BEGIN 
   SELECT @message1 = cast(@empl_num as varchar(10))+ ' ' + @name + ' ' + @age+ ' ' + ' ' + @rep_office+ ' '+ @title+ ' '+
   +@manager+' '+@quota+ cast(@sales as varchar(10));
   PRINT @message1; 
   FETCH FROM salesreps_cursor INTO @empl_num, @name, @age, @rep_office, @title, @manager, @quota, @sales;
END ;
CLOSE salesreps_cursor; 
DEALLOCATE salesreps_cursor; 

3.	Разработать локальный курсор, который выводит все сведения о товарах и их среднюю цену.
4.	Разработать глобальный курсор, который выводит сведения о заказах, выполненныъ в 2008 году.
--5.	Разработать статический курсор, который выводит сведения о покупателях и их заказах.
DECLARE @cust_num int, @company varchar(15),  @message varchar(80),
    @credit_limit decimal(8, 2);
DECLARE customers_cursor CURSOR --STATIC
FOR  
SELECT cust_num, company, credit_limit FROM customers;
PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10)) -- @@CURSOR_ROWS
OPEN customers_cursor;
PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10))
FETCH FROM customers_cursor INTO @cust_num, @company, @credit_limit;
PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10))
WHILE @@FETCH_STATUS = 0 
BEGIN 
   SELECT @message = cast(@cust_num as varchar(10))+ ' ' + @company + ' '  +
      cast(@credit_limit as varchar(10));
 
   PRINT @message; 
   FETCH FROM customers_cursor INTO @cust_num, @company, @credit_limit;
   PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10))
END ;
CLOSE customers_cursor; 
PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10))
DEALLOCATE customers_cursor;
PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10))

--6.	Разработать динамический курсор, который обновляет данные о сотруднике в зависимости от суммы выполненных заказов (поле SALES).
SELECT * FROM ORDERS
declare @rep int, @sales decimal(9, 2);
declare update_cursor cursor local dynamic for
	select rep, sum(amount) as sales_order from orders
group by rep;
	open update_cursor;
	fetch from update_cursor into @rep, @sales;
	while @@FETCH_STATUS = 0
		begin
			update salesreps set sales = @sales
	where empl_num=@rep
	fetch from update_cursor into @rep, @sales;
	end;
close update_cursor;
deallocate update_cursor;

--7.	Продемонстрировать свойства SCROLL.
declare scroll_c cursor scroll
for
select * from offices;
open scroll_c
	fetch last from scroll_c;
	fetch prior from scroll_c;
	fetch absolute 2 from scroll_c;
	fetch first from scroll_c;
	fetch relative 3 from scroll_c;
close scroll_c;
deallocate scroll_c;