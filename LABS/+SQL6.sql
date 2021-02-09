--1.	Разработать хранимые процедуры: 
--1.1.	Добавления нового клиента; при попытке дублирования данных — 
--вывести сообщение об ошибке.
--------------------VERSION 1-----------------------------------------------------
GO
CREATE PROCEDURE CUST_ADD
		@CUST_NUM INT,
		@COMPANY VARCHAR(20),
		@CUST_REP INT,
		@CREDIT_LIMIT DECIMAL(9, 2)
AS
DECLARE @COUNT INT = 0
BEGIN 
	BEGIN TRY
		INSERT INTO CUSTOMERS (CUST_NUM, COMPANY, CUST_REP, CREDIT_LIMIT)
			VALUES (@CUST_NUM, @COMPANY, @CUST_REP, @CREDIT_LIMIT)
	END TRY
	BEGIN CATCH
		SET @COUNT = -1
		PRINT 'ERROR! THIS CUST IS ADD'
	END CATCH
	RETURN @COUNT;
END
------------------ADD CUST------------------------------
DECLARE @CUST_NUM INT,
		@COMPANY VARCHAR(20),
		@CUST_REP INT,
		@CREDIT_LIMIT DECIMAL(9, 2)
SET @CUST_NUM = 2211
SET @COMPANY = 'HYPERMOOVE'
SET @CUST_REP = 106
SET @CREDIT_LIMIT = 90000

EXEC CUST_ADD @CUST_NUM, @COMPANY, @CUST_REP, @CREDIT_LIMIT
GO
SELECT * FROM CUSTOMERS
------------------------------------------------
/*create procedure SelCust
as
declare @rc int = 0
begin
	select * from CUSTOMERS
	if @@rowcount = 0 set @rc = -1
	return @rc
end

declare @code int = 15;
exec @code = SelCust;
print 'Code = ' + cast(@code as varchar(10));

go*/
----------------VERSION 2-----------------------------------------------------------------
GO
CREATE PROCEDURE SelectCust 
				@cust_num INTEGER, 
				@company varchar(20), 
				@cust_rep integer, 
				@credit_limit decimal(5, 2)
    AS SELECT cust_num, company, cust_rep, credit_limit
    FROM customers

------------------------------------------------------------------------------
BEGIN TRY 
	BEGIN TRANSACTION
		insert into CUSTOMERS values(2100, 'Apple', 106,70000.00);
		insert into CUSTOMERS values(2100, 'Apple', 106,70000.00);
    COMMIT TRANSACTION
    PRINT 'Транзакция выполнена'
END TRY
BEGIN CATCH
    ROLLBACK
        PRINT 'Отмена транзакции';
    THROW
END CATCH	
-------------------------------------------------------------------------------

--1.2.	Поиска клиента по части названия; если такого не нашлось — вывести сообщение.
CREATE PROCEDURE comp 
				@Company nvarchar(30)
AS
SELECT * FROM Customers WHERE Company = @Company
GO

EXEC comp @Company = 'First Corp.';

--1.3.	Обновления данных клиента.
GO
CREATE PROCEDURE UpdateCUSTS_two 
		@CUST_NUM INT = 2000
		/*@COMPANY VARCHAR(20) = 'JET_COMPANY',
		@CUST_REP INT = 106,
		@CREDIT_LIMIT DECIMAL(9, 2) = 100000*/
   AS UPDATE CUSTOMERS
		SET CUST_NUM = @CUST_NUM
        WHERE CUST_NUM = 2101;
	exec UpdateCUSTS_two    ------НЕ ОБНОВЛЯЕТСЯ!

		SELECT * FROM CUSTOMERS
--1.4.	Удаления данных о клиенте; если у клиента есть заказы, и его нельзя удалить — вывести сообщение. 

--2.	Вызвать разработанные процедуры с различными параметрами для демонстрации.

--3.	Разработать пользовательские функции: 
--3.1.	Подсчитать количество заказов сотрудника в определенный период. Если такого сотрудника нет — вернуть -1. 
--Если сотрудник есть, а заказов нет — вернуть 0.

/*GO
CREATE FUNCTION ComputeCosts (@percent INT = 10)
    RETURNS DECIMAL(16, 2)
    BEGIN
        DECLARE @addCosts DEC (14,2), @sumBudget DEC(16,2)
        SELECT @sumBudget = SUM (Budget) FROM Project
        SET @addCosts = @sumBudget * @percent/100
        RETURN @addCosts
    END;*/
-------------------------------------------------------------
SELECT * FROM SALESREPS
SELECT * FROM ORDERS

GO
create function COUNTSALES (@REP INT, @ORDER_DATE_BEFORE DATE, 
							@ORDER_DATE_AFTER DATE) RETURNS INT
begin
	DECLARE @Q INT = -1 
	IF (SELECT EMPL_NUM FROM SALESREPS WHERE EMPL_NUM = @REP) IS NULL
	return @Q;

	SET @Q = (SELECT COUNT(ORDER_NUM) FROM ORDERS WHERE REP = @REP 
		AND ORDER_DATE BETWEEN @ORDER_DATE_BEFORE AND @ORDER_DATE_AFTER);
		RETURN @Q;
end;
go
---------------------------------------------------------------
DECLARE @REP INT;
SET @REP = [DBO].COUNTSALES(101, '2006-01-01', '2008-01-01');
SELECT EMPL_NUM, NAME, DBO.COUNTSALES(EMPL_NUM, '2006-01-01', '2008-01-01') AS COUNT_HIRE_DATE
	FROM SALESREPS
PRINT 'RESULT ' + CAST(@REP AS VARCHAR(10));

---IF NOT SALESREPS IS -1---------------------------------------
DECLARE @REP INT;
SET @REP = [DBO].COUNTSALES(100, '2006-01-01', '2008-01-01');
SELECT EMPL_NUM, NAME, DBO.COUNTSALES(EMPL_NUM, '2006-01-01', '2008-01-01') AS COUNT_HIRE_DATE
	FROM SALESREPS
PRINT 'RESULT ' + CAST(@REP AS VARCHAR(10));

--3.2.	Подсчитать количество товаров различных производителей ценой выше указанной. 

-- Эта функция вычисляет возникающие дополнительные общие затраты,
-- при увеличении бюджетов проектов
GO
CREATE FUNCTION QTY_PROD6 
			(@QTY INT, @PRICE DECIMAL(5, 2))
			RETURNS INT
    BEGIN
        DECLARE @MFR_ID VARCHAR(10), @PRODUCT_QTY INT
        SELECT @PRODUCT_QTY = COUNT(QTY_ON_HAND) FROM PRODUCTS WHERE QTY_ON_HAND = @QTY AND PRICE > @PRICE
        --SET @addCosts = @sumBudget * @percent/100
        RETURN @PRODUCT_QTY
    END;
GO

DECLARE @QTY INT;
SET @QTY = [DBO].QTY_PROD6(300, 250.00);
SELECT MFR_ID, DBO.QTY_PROD6(300, 250.00) AS COUNT_QTY
	FROM PRODUCTS
PRINT 'RESULT ' + CAST(@QTY AS VARCHAR(10));----- РАБОТАЕТ НЕ ВЕРНО!

SELECT MFR_ID, QTY_ON_HAND, PRICE
    FROM PRODUCTS
    WHERE PRICE > dbo.QTY_PROD5(300, 250.00);

	SELECT * FROM PRODUCTS
--3.3.	Подсчитать количество заказанных товаров для определенного производителя.
GO
CREATE FUNCTION ORDERSQTY () RETURNS INT
BEGIN 
	DECLARE @QTYORD INT = (SELECT COUNT(ORDER_NUM) FROM ORDERS WHERE MFR = 'REI')
	return @QTYORD;
END
GO

DECLARE @SHOW_ORDER INT = [DBO].ORDERSQTY();
PRINT 'SHOW ORDER = ' + CAST(@SHOW_ORDER AS VARCHAR(10));
GO
select * from orders
DROP FUNCTION ORDERSQTY;

--4.	Вызвать разработанные функции различными способами с различными параметрами для демонстрации.
