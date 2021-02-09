--1.Разработать скрипт, демонстрирующий работу в режиме неявной транзакции.
BEGIN TRY 
	BEGIN TRANSACTION
		insert into CUSTOMERS values(2100, 'Apple', 106,70000.00);
		--insert into CUSTOMERS values(2100, 'Apple', 106,70000.00);
    COMMIT TRANSACTION
    PRINT 'Транзакция выполнена'
END TRY
BEGIN CATCH
    ROLLBACK
        PRINT 'Отмена транзакции';
    THROW
END CATCH
----------------------------------------------------
BEGIN TRANSACTION
    UPDATE Salesreps
        SET manager = 131
        WHERE manager = 104
    IF (@@error <> 0) --@@error-глобальная переменная
        ROLLBACK
    UPDATE Orders
        SET rep = 131
        WHERE rep = 104
	IF (@@error <> 0)
        ROLLBACK
	UPDATE Customers
		SET cust_rep = 131
		WHERE cust_rep = 104
    IF (@@error <> 0)
        ROLLBACK
COMMIT
select * from salesreps
--2.Разработать скрипт, демонстрирующий свойства ACID явной транзакции. В блоке CATCH предусмотреть выдачу соответствующих сообщений об ошибках. 
select * from CUSTOMERS
BEGIN TRAN
DELETE FROM CUSTOMERS WHERE CUST_NUM = 2101
ROLLBACK TRAN
BEGIN TRAN
INSERT INTO CUSTOMERS VALUES (2133, 'ASUS', 107, 72000.00);
COMMIT TRAN

BEGIN TRANSACTION;  
  
BEGIN TRY  
    -- Generate a constraint violation error.  
    DELETE FROM OFFICES  
    WHERE OFFICE = 11;  
END TRY  
BEGIN CATCH  
    SELECT   
        ERROR_NUMBER() AS ErrorNumber		--Возвращает номер ошибки
        ,ERROR_SEVERITY() AS ErrorSeverity  --Возвращает значение серьезности ошибки
        ,ERROR_STATE() AS ErrorState		--Возвращает номер состояния для ошибки
        ,ERROR_PROCEDURE() AS ErrorProcedure--Возвращает имя хранимой процедуры или триггера  
        ,ERROR_LINE() AS ErrorLine			--Возвращает номер строки, в которой произошла ошибка,
        ,ERROR_MESSAGE() AS ErrorMessage;	--Возвращает текст сообщения об ошибке
  
    IF @@TRANCOUNT > 0						--Возвращает количество операторов BEGIN TRANSACTION, которые произошли в текущем соединении.
        ROLLBACK TRANSACTION;  
END CATCH;  
  
IF @@TRANCOUNT > 0  
    COMMIT TRANSACTION;  
	SELECT * FROM OFFICES
--3.Разработать скрипт, демонстрирующий применение оператора SAVETRAN. В блоке CATCH предусмотреть выдачу соответствующих сообщений об ошибках. 
SELECT * FROM CUSTOMERS
BEGIN TRY
BEGIN TRAN FIRST_ONE
	INSERT INTO CUSTOMERS
		VALUES (3333, 'NOKIA', 107, 100000.00)
	SAVE TRAN FIRSTCUST --Устанавливает точку сохранения внутри транзакции.
	UPDATE CUSTOMERS
	SET COMPANY = 'APPLE'
	WHERE CUST_NUM = 3333
	ROLLBACK TRAN FIRSTCUST
COMMIT TRAN FIRST_ONE
END TRY
BEGIN CATCH
	SELECT 'ERROR'
END CATCH

--4.Разработать два скрипта A и B. Продемонстрировать неподтвержденное, неповторяющееся и 
--фантомное чтение. Показать усиление уровней изолированности. -УРОВЕНЬ ИЗОЛЯЦИИ ЗАДАЕТ ЗАЩИЩЕННОСТЬ ДАННЫХ В ТРАНЗАКЦИИ
-- НЕПОВТОРЯЮЩЕЕСЯ ЧТЕНИЕ - ЭТО КОГДА Один процесс считывает данные несколько раз, а другой процесс 
							--изменяет эти данные между двумя операциями чтения первого процесса
--ФАНТОМНОЕ ЧТЕНИЕ - Последовательные операции чтения могут возвратить разные значения
					--Считывание разного числа строк при каждом чтении
					--Возникают дополнительные фантомные строки, которые вставляются другими транзакциями
					--Значения двух чтений будут разными
--НЕПОДТВЕРЖДЕННОЕ ЧТЕНИЕ
INSERT INTO CUSTOMERS VALUES (1111, 'MEGAHIGH', 110, 72000.00);
--1
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRAN
SELECT COUNT(*) FROM CUSTOMERS -- QTY ROWS
--2
BEGIN TRAN  -- открываем параллельную транзакцию - ВСЕ ПАРАЛЛЕЛЬНЫЕ ТРАНЗАКЦИИ ОТДЕЛЕНЫ ДРУГ ОТ ДРУГА
DELETE FROM CUSTOMERS WHERE CUST_NUM = 3333 -- удаляем строку из таблицы
--3
SELECT COUNT(*) FROM CUSTOMERS -- Результат: , неподтвержденное чтение
--4
ROLLBACK TRAN -- откатываем транзакцию
--5
SELECT COUNT(*) FROM CUSTOMERS -- Результат: , после отката транзакции В
COMMIT TRAN
----- Покажем, что уровень изолированности READ COMMITTED не допускает неподтвержденное чтение

-- 6
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
SELECT COUNT(*) FROM CUSTOMERS -- запускаем транзакцию, Результат: 
 
--  8
SELECT COUNT(*) FROM CUSTOMERS -- Результат: ожидание, неподтвержденного чтения нет
 
-- 10
SELECT COUNT(*) FROM CUSTOMERS -- сразу после отката транзакции 
COMMIT TRAN
--- 7
BEGIN TRAN  -- открываем параллельную транзакцию
DELETE FROM CUSTOMERS WHERE CUST_NUM=1111 -- удаляем строку из таблицы

--- 9
ROLLBACK TRAN -- откатываем транзакцию
-------------------------------------------------------
--НЕПОВТОРЯЮЩЕЕСЯ ЧТЕНИЕ
--11
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
SELECT COUNT(*) FROM OFFICES
-- 12
BEGIN TRAN  -- открываем параллельную транзакцию
DELETE FROM OFFICES WHERE OFFICE = 26 -- удаляем строку из таблицы
COMMIT TRAN
-- 13
SELECT COUNT(*) FROM OFFICES -- Результат: 
-- пока вторая транзакция удаляла запись, данные дважды прочитались по-разному.
COMMIT TRAN
----- Покажем, что уровень изолированности REPEATABLE READ не допускает неповторяющееся чтение
INSERT INTO OFFICES VALUES (26, 'Warsaw', 'Eastern', 108, 72000.00, 81000.00); -- вернем запись
-- 14
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRAN
SELECT COUNT(*) FROM OFFICES -- Результат: 17
--- 15
BEGIN TRAN  -- открываем параллельную транзакцию
DELETE FROM OFFICES WHERE OFFICE = 26 -- удаляем строку из таблицы, результат - ожидание
-- 16
COMMIT TRAN -- сразу после фиксации транзакции А в окне В 
--- Строк обработано:1 - прошло выполнение оператора удаления
--- 17
COMMIT TRAN -- завершаем транзакцию
-----------------------------
SELECT * FROM CUSTOMERS


/*SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
SELECT * FROM OFFICES -- A: 
 
SELECT * FROM OFFICES -- B: 
COMMIT TRAN*/

--5.	Разработать скрипт, демонстрирующий свойства вложенных транзакций. 
GO

/* SELECT statement built using a subquery. */
BEGIN TRAN
	SELECT Name, AGE
	FROM SALESREPS
	WHERE AGE <
		(SELECT AGE 
		FROM SALESREPS
		WHERE AGE = 33);
GO
SELECT * FROM SALESREPS
