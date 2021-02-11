--1.	Разработать курсор, который выводит все данные о клиенте.
SELECT * FROM CUSTOMERS
DECLARE  @COMPANY   VARCHAR(50),
         @CREDIT_LIMIT     INT,
         @message VARCHAR(80)
PRINT ' LIST CUSTOMERS'
DECLARE klient_cursor CURSOR LOCAL FOR
    SELECT COMPANY, CREDIT_LIMIT
    FROM CUSTOMERS
    --WHERE COMPANY='First Corp.'
    ORDER BY COMPANY, CREDIT_LIMIT

OPEN klient_cursor
FETCH NEXT FROM klient_cursor INTO @COMPANY, @CREDIT_LIMIT
WHILE @@FETCH_STATUS=0
BEGIN
    SELECT @message='COMPANY '+@COMPANY +' '+ 'CREDIT_LIMIT' +cast(@CREDIT_LIMIT as varchar(80))
                 
    PRINT @message

-- переход к следующему клиенту--

    FETCH NEXT FROM klient_cursor 
      INTO @COMPANY, @CREDIT_LIMIT
END
CLOSE klient_cursor
DEALLOCATE klient_cursor

-------------------------------------------------------------------
select * from customers
GO
DECLARE CURSOR_CUST CURSOR--1
	FOR SELECT * FROM CUSTOMERS -- КУРСОР СОЗДАЕТСЯ НА ОСНОВЕ ОПЕРАТОРА SELECT--1
OPEN CURSOR_CUST --ДЛЯ ТОГО ЧТОБЫ ЧИТАТЬ СТРОКИ--2
GO
WHILE @@FETCH_STATUS = 0
BEGIN
FETCH NEXT FROM CURSOR_CUST -- ЧТЕНИЕ ОДНОЙ СТРОКИ ИЗ FOR SELECT--3
END

CLOSE CURSOR_CUST -- ЗАКРЫТЬ КУРСОР
DEALLOCATE CURSOR_CUST -- УДАЛИТЬ КУРСОР
------------------------------------------------------
--ПЕРЕМЕННЫЕ ДЛЯ РАБОТЫ
GO
DECLARE @cust_num AS INT 
DECLARE @company AS VARCHAR(50) 
DECLARE @cust_rep AS INT 
DECLARE @credit_limit AS INT
GO
--СОЗДАЕМ КУРСОР
DECLARE custr CURSOR FOR
	SELECT cust_num, company, cust_rep, credit_limit FROM customers
--ОТКРЫВАЕМ КУРСОР
	OPEN custr
--ОСУЩЕСТВОЯЕМ ВЫБОРКУ
WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE @cust_num AS INT 
	DECLARE @company AS VARCHAR(50) 
	DECLARE @cust_rep AS INT 
	DECLARE @credit_limit AS INT
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
select * from OFFICES
DECLARE @OFFICE INT,
		@CITY VARCHAR(20),
		@REGION VARCHAR(20),
		@MGR INT,
		@TARGET INT,
		@SALES INT,
		@SEND_TO_DISPLAY VARCHAR(1000);

DECLARE OFFICES_CURSOR CURSOR
FOR SELECT OFFICE, CITY, REGION, COUNT(MGR), TARGET, SALES 
FROM OFFICES 
GROUP BY OFFICE, CITY, REGION, MGR, TARGET, SALES;

OPEN OFFICES_CURSOR;

FETCH FROM OFFICES_CURSOR INTO @OFFICE, @CITY, @REGION, @MGR, @TARGET, @SALES
WHILE @@FETCH_STATUS = 0 
	BEGIN 
		SELECT @SEND_TO_DISPLAY = CAST(@OFFICE AS VARCHAR(20))+'---'+ @CITY+'---'+ @REGION +'---'+ 
		CAST(@MGR AS VARCHAR(20))+'---'+ CAST(@TARGET AS VARCHAR(200))+'---'+CAST(@SALES AS VARCHAR(200));
	PRINT @SEND_TO_DISPLAY
	FETCH FROM OFFICES_CURSOR INTO @OFFICE, @CITY, @REGION, @MGR, @TARGET, @SALES
END
CLOSE OFFICES_CURSOR
DEALLOCATE OFFICES_CURSOR
-----------------------------------------------------------------------------------------------
DECLARE @empl_num int, 
	@name varchar(45),
    --@age int, 
	--@rep_office int, 
	@title varchar(40),
	--@hire_date INT,
	--@manager int, 
	--@quota decimal(9, 2), 
	@sales decimal(9, 2),
	@SUM INT, 
	--@message1 varchar(80),
	@MESSAGE VARCHAR(1000);

DECLARE salesreps_cursor CURSOR 
FOR SELECT empl_num, name, title, sales, COUNT(MANAGER) FROM salesreps GROUP BY EMPL_NUM, NAME, TITLE, SALES;
 
OPEN salesreps_cursor;
 
FETCH FROM salesreps_cursor INTO @empl_num, @name, @title, @sales, @SUM;
WHILE @@FETCH_STATUS = 0 
BEGIN 
	--FETCH FROM salesreps_cursor INTO @empl_num, @name, @age, @rep_office, @title, @hire_date, @manager, @quota, @sales;
   SELECT @MESSAGE = cast(@empl_num as varchar(100))+ ' ' + @name + ' ' +  @title+ ' '+ cast(@sales as varchar(1000))+' '+ 
   '--QTY CUST-- '+ CAST(@SUM AS VARCHAR(30));
   PRINT @MESSAGE; 
   FETCH FROM salesreps_cursor INTO @empl_num, @name,  @title,  @sales, @SUM;
END ;
CLOSE salesreps_cursor; 
DEALLOCATE salesreps_cursor; 
GO
--3.	Разработать локальный курсор, который выводит все сведения о товарах и их среднюю цену.
SELECT AVG(PRICE) FROM PRODUCTS WHERE MFR_ID = 'ACI'
SELECT * FROM PRODUCTS
DECLARE @MFR_ID VARCHAR(20),
		@PRODUCT_ID VARCHAR(20),
		@PRICE INT,
		@SEND_TO_DISPLAY VARCHAR(1000);

DECLARE PRODUCTS_CURSOR CURSOR
FOR SELECT DISTINCT MFR_ID, PRODUCT_ID, AVG(PRICE)  
FROM PRODUCTS 
GROUP BY MFR_ID, PRODUCT_ID, PRICE;

OPEN PRODUCTS_CURSOR;

FETCH FROM PRODUCTS_CURSOR INTO @MFR_ID, @PRODUCT_ID, @PRICE
WHILE @@FETCH_STATUS = 0 
	BEGIN 
		SELECT @SEND_TO_DISPLAY = @MFR_ID+'---'+ @PRODUCT_ID +'---'+ CAST(AVG(@PRICE) AS VARCHAR(20));
	--PRINT @SEND_TO_DISPLAY
	SET @SEND_TO_DISPLAY = @MFR_ID + '---'+@PRODUCT_ID+'---'+(select cast(AVG(price) as VARCHAR(20)) from products);
	PRINT @SEND_TO_DISPLAY
	--SELECT CAST(AVG(@PRICE) AS VARCHAR(20)) WHERE @MFR_ID = 'ACI'
	--PRINT CAST(AVG(@PRICE) AS VARCHAR(20))
	FETCH FROM PRODUCTS_CURSOR INTO @MFR_ID, @PRODUCT_ID, @PRICE
END

CLOSE PRODUCTS_CURSOR
DEALLOCATE PRODUCTS_CURSOR

4.	Разработать глобальный курсор, который выводит сведения о заказах, выполненныъ в 2008 году.
--5.	Разработать статический курсор, который выводит сведения о покупателях и их заказах.
DECLARE 
	@cust_num int, 
	@company varchar(15),  
	@message varchar(80),
	@cust_rep int,
    @credit_limit decimal(8, 2);

DECLARE customers_cursor CURSOR --STATIC
FOR  
SELECT * FROM customers;
PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10)) -- @@CURSOR_ROWS
OPEN customers_cursor;

PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10))
FETCH FROM customers_cursor INTO @cust_num2, @company2, @cust_rep2, @credit_limit2;
PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10))
WHILE @@FETCH_STATUS = 0 
BEGIN 
DECLARE 
	@message2 varchar(80),
	@cust_num2 int, 
	@company2 varchar(15), 
	@cust_rep2 int,
    @credit_limit2 decimal(8, 2);
   SELECT @message2 = @cust_num2 + ' ' + @company2 + ' ' + @cust_rep2 + ' ' +
      cast(@credit_limit2 as varchar(10));
 
   PRINT @message2; 
   --FETCH FROM customers_cursor INTO @cust_num2, @company2, @cust_rep2, @credit_limit2;
   PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10))
END ;
CLOSE customers_cursor; 
PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10))
DEALLOCATE customers_cursor;
PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10))

--6.	Разработать динамический курсор, который обновляет данные о сотруднике в зависимости от суммы выполненных заказов (поле SALES).
SELECT * FROM ORDERS
SELECT * FROM salesreps
declare 
	@rep int, 
	@sales decimal(9, 2);

declare update_cursor cursor local dynamic for
	select rep, sum(amount) as sales_order from orders
group by rep;
	
open update_cursor;

	--fetch from update_cursor into @rep, @sales;
	while @@FETCH_STATUS = 0		--КОНТРОЛЬ ДОСТИЖЕНИЯ КОНЦА КУРСОРА - ЕСЛИ 0, ТО ВЫБОРКА ПРОШЛА УСПЕШНО
begin
declare 
	@rep int, 
	@sales decimal(9, 2);
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
