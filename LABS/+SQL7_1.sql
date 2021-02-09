--1.����������� ������, ��������������� ������ � ������ ������� ����������.
BEGIN TRY 
	BEGIN TRANSACTION
		insert into CUSTOMERS values(2100, 'Apple', 106,70000.00);
		--insert into CUSTOMERS values(2100, 'Apple', 106,70000.00);
    COMMIT TRANSACTION
    PRINT '���������� ���������'
END TRY
BEGIN CATCH
    ROLLBACK
        PRINT '������ ����������';
    THROW
END CATCH
----------------------------------------------------
BEGIN TRANSACTION
    UPDATE Salesreps
        SET manager = 131
        WHERE manager = 104
    IF (@@error <> 0) --@@error-���������� ����������
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
--2.����������� ������, ��������������� �������� ACID ����� ����������. � ����� CATCH ������������� ������ ��������������� ��������� �� �������. 
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
        ERROR_NUMBER() AS ErrorNumber		--���������� ����� ������
        ,ERROR_SEVERITY() AS ErrorSeverity  --���������� �������� ����������� ������
        ,ERROR_STATE() AS ErrorState		--���������� ����� ��������� ��� ������
        ,ERROR_PROCEDURE() AS ErrorProcedure--���������� ��� �������� ��������� ��� ��������  
        ,ERROR_LINE() AS ErrorLine			--���������� ����� ������, � ������� ��������� ������,
        ,ERROR_MESSAGE() AS ErrorMessage;	--���������� ����� ��������� �� ������
  
    IF @@TRANCOUNT > 0						--���������� ���������� ���������� BEGIN TRANSACTION, ������� ��������� � ������� ����������.
        ROLLBACK TRANSACTION;  
END CATCH;  
  
IF @@TRANCOUNT > 0  
    COMMIT TRANSACTION;  
	SELECT * FROM OFFICES
--3.����������� ������, ��������������� ���������� ��������� SAVETRAN. � ����� CATCH ������������� ������ ��������������� ��������� �� �������. 
SELECT * FROM CUSTOMERS
BEGIN TRY
BEGIN TRAN FIRST_ONE
	INSERT INTO CUSTOMERS
		VALUES (3333, 'NOKIA', 107, 100000.00)
	SAVE TRAN FIRSTCUST --������������� ����� ���������� ������ ����������.
	UPDATE CUSTOMERS
	SET COMPANY = 'APPLE'
	WHERE CUST_NUM = 3333
	ROLLBACK TRAN FIRSTCUST
COMMIT TRAN FIRST_ONE
END TRY
BEGIN CATCH
	SELECT 'ERROR'
END CATCH

--4.����������� ��� ������� A � B. ������������������ ����������������, ��������������� � 
--��������� ������. �������� �������� ������� ���������������. -������� �������� ������ ������������ ������ � ����������
-- ��������������� ������ - ��� ����� ���� ������� ��������� ������ ��������� ���, � ������ ������� 
							--�������� ��� ������ ����� ����� ���������� ������ ������� ��������
--��������� ������ - ���������������� �������� ������ ����� ���������� ������ ��������
					--���������� ������� ����� ����� ��� ������ ������
					--��������� �������������� ��������� ������, ������� ����������� ������� ������������
					--�������� ���� ������ ����� �������
--���������������� ������
INSERT INTO CUSTOMERS VALUES (1111, 'MEGAHIGH', 110, 72000.00);
--1
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRAN
SELECT COUNT(*) FROM CUSTOMERS -- QTY ROWS
--2
BEGIN TRAN  -- ��������� ������������ ���������� - ��� ������������ ���������� �������� ���� �� �����
DELETE FROM CUSTOMERS WHERE CUST_NUM = 3333 -- ������� ������ �� �������
--3
SELECT COUNT(*) FROM CUSTOMERS -- ���������: , ���������������� ������
--4
ROLLBACK TRAN -- ���������� ����������
--5
SELECT COUNT(*) FROM CUSTOMERS -- ���������: , ����� ������ ���������� �
COMMIT TRAN
----- �������, ��� ������� ��������������� READ COMMITTED �� ��������� ���������������� ������

-- 6
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
SELECT COUNT(*) FROM CUSTOMERS -- ��������� ����������, ���������: 
 
--  8
SELECT COUNT(*) FROM CUSTOMERS -- ���������: ��������, ����������������� ������ ���
 
-- 10
SELECT COUNT(*) FROM CUSTOMERS -- ����� ����� ������ ���������� 
COMMIT TRAN
--- 7
BEGIN TRAN  -- ��������� ������������ ����������
DELETE FROM CUSTOMERS WHERE CUST_NUM=1111 -- ������� ������ �� �������

--- 9
ROLLBACK TRAN -- ���������� ����������
-------------------------------------------------------
--��������������� ������
--11
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
SELECT COUNT(*) FROM OFFICES
-- 12
BEGIN TRAN  -- ��������� ������������ ����������
DELETE FROM OFFICES WHERE OFFICE = 26 -- ������� ������ �� �������
COMMIT TRAN
-- 13
SELECT COUNT(*) FROM OFFICES -- ���������: 
-- ���� ������ ���������� ������� ������, ������ ������ ����������� ��-�������.
COMMIT TRAN
----- �������, ��� ������� ��������������� REPEATABLE READ �� ��������� ��������������� ������
INSERT INTO OFFICES VALUES (26, 'Warsaw', 'Eastern', 108, 72000.00, 81000.00); -- ������ ������
-- 14
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRAN
SELECT COUNT(*) FROM OFFICES -- ���������: 17
--- 15
BEGIN TRAN  -- ��������� ������������ ����������
DELETE FROM OFFICES WHERE OFFICE = 26 -- ������� ������ �� �������, ��������� - ��������
-- 16
COMMIT TRAN -- ����� ����� �������� ���������� � � ���� � 
--- ����� ����������:1 - ������ ���������� ��������� ��������
--- 17
COMMIT TRAN -- ��������� ����������
-----------------------------
SELECT * FROM CUSTOMERS


/*SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
SELECT * FROM OFFICES -- A: 
 
SELECT * FROM OFFICES -- B: 
COMMIT TRAN*/

--5.	����������� ������, ��������������� �������� ��������� ����������. 
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
