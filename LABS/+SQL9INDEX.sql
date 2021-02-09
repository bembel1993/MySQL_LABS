--1.	������� ��� ������� ��� ������ ���� ������.
EXEC SP_HELPINDEX 'CUSTOMERS';
EXEC SP_HELPINDEX 'OFFICES';
EXEC SP_HELPINDEX 'ORDERS';
EXEC SP_HELPINDEX 'PRODUCTS';
EXEC SP_HELPINDEX 'SALESREPS';

--2.	�������� ������ ��� ������� ��� ������ ������� � ����������������� ��� ����������.
CREATE INDEX #MANAGER ON [DBO].[OFFICES]([MGR]);
SELECT COUNT(*) FROM [DBO].[OFFICES] WHERE [OFFICE] BETWEEN 11 AND 13 AND [MGR]=104; --���������� �������� 1
select * from offices
--3.	�������� ������ ��� ������� ��� ���������� �������� � ����������������� ��� ����������.
CREATE INDEX #INFO ON [DBO].[SALESREPS]([NAME],[AGE]);
SELECT [AGE] FROM [DBO].[SALESREPS];
SELECT * FROM [DBO].[SALESREPS] WHERE AGE<33;

--4.	�������� ����������� ������ ��� ������� � ����������������� ��� ����������.
--CREATE INDEX #AMOUNT ON [DBO].[ORDERS]([AMOUNT]) WHERE [AMOUNT]>3978.00; --������ ������������ ��� ����������� �����
--SELECT [ORDER_NUM], [AMOUNT] FROM [ORDERS] WHERE [AMOUNT] = 1896;
--SELECT * FROM ORDERS WHERE AMOUNT = 1896

--DROP INDEX #AMOUNT ON [DBO].[ORDERS];

/*CREATE [UNIQUE] [CLUSTERED | NONCLUSTERED] INDEX index_name
    ON table_name (column1 [ASC | DESC] ,...)
        [ INCLUDE ( column_name [ ,... ] ) ]
        
[WITH
    [FILLFACTOR=n]
    [[, ] PAD_INDEX = {ON | OFF}]*/
	--index_name ������ ��� ������������ �������.
	--������ ����� ������� ��� ������ ��� ������ �������� ����� �������, ������������ ���������� table_name.
	--�������, ��� �������� ��������� ������, ����������� ���������� column1.

CREATE NONCLUSTERED INDEX #FILTERINDEX 
    ON [DBO].[ORDERS] ([AMOUNT], [ORDER_DATE])  
    WHERE [AMOUNT] > 22500;

GO  
SELECT [AMOUNT], [ORDER_DATE]   
FROM [DBO].[ORDERS] 
WHERE [AMOUNT] = 45000      
    AND [ORDER_DATE] > '2008-01-30' ;  
GO  

GO  
SELECT * FROM [DBO].[ORDERS]  
    WITH ( INDEX ( #FILTERINDEX ) )   
WHERE [AMOUNT] IN (45000);   
GO 
--������ ��������� ������ �������� ������ � ����� ��� ���������� ������� ��� ������

--5.	�������� ������ �������� ��� ������� � ����������������� ��� ����������.
CREATE INDEX #ALLCOLLUMN 
      ON [DBO].[CUSTOMERS]([CUST_NUM], [COMPANY], [CUST_REP], [CREDIT_LIMIT]);
SELECT * FROM [DBO].[CUSTOMERS]; --������ �������� - ��� ������ , ���������� ��� �������, ���������� �� �������.

--6.	�������� ������ ��� ������� � ����������� ������ � ����������������� ��� ����������.
SELECT DISTINCT [DBO].[SALESREPS].[NAME], [DBO].[CUSTOMERS].[COMPANY]
	FROM [DBO].[ORDERS],[DBO].[CUSTOMERS],[DBO].[SALESREPS]
WHERE [DBO].[ORDERS].[REP]=[DBO].[SALESREPS].[EMPL_NUM] 
    AND [DBO].[ORDERS].[CUST]=[DBO].[CUSTOMERS].[CUST_NUM]
SELECT * FROM ORDERS;
EXEC SP_HELPINDEX 'ORDERS'; --������� ��� ������� �������� �������� � SQL ���������� � ���� ��������� �����.
CREATE INDEX #SAME ON [DBO].[ORDERS]([ORDER_DATE], ORDER_NUM);
------------------------------------------------------
-----������� ����������, ������� ����������� ����� � ��� �� �����������.
SELECT DISTINCT 
	OR1.CUST, OR1.REP
FROM ORDERS OR1
JOIN ORDERS OR2 ON OR1.CUST=OR2.CUST
WHERE OR1.REP != OR2.REP
ORDER BY CUST ASC

SELECT * FROM ORDERS;
SELECT * FROM CUSTOMERS;
exec sp_helpindex 'ORDERS';

CREATE INDEX #SAME ON ORDERS(CUST,REP);

-------������� ���� ����������� �� ���������� ������� � ������������� �� ��������� Quota.
--Select name, empl_num, rep_office, region, quota 
--from salesreps s 
--left join offices ofi on rep_office=office
--where region='Eastern' order by Quota desc;

--SELECT * FROM OFFICES;
--SELECT * FROM SALESREPS;
--exec sp_helpindex 'OFFICES';
--exec sp_helpindex 'SALESREPS';
----SELECT  * FROM SYS.dm_db_index_physical_stats(DB_iD('BEMBEL_LAB3'), OBJECT_ID('OFFICES'), NULL,NULL,NULL);
----SELECT  * FROM SYS.dm_db_index_physical_stats(DB_iD('BEMBEL_LAB3'), OBJECT_ID('SALESREPS'), NULL,NULL,NULL);

--CREATE INDEX #region ON OFFICES(OFFICE) where REGION='EASTERN';
--CREATE INDEX #QUOTA ON SALESREPS(QUOTA, REP_OFFICE);

--DROP INDEX ix_empid ON Employee;

--7.	�������� ��������� �������� ��� ������� � ����������������� �� ����������� � �������������.
CREATE TABLE #OFFIC
(	OF_1 int IDENTITY(1,1),
	CITY_1 VARCHAR(100),
	REG_1 varchar(100),
	MGR_1 INT,
	TARG_1 DECIMAL(5, 2),
	SAL_1 DECIMAL(5, 2));

CREATE NONCLUSTERED INDEX #TMP_TBL_3 ON #OFFIC(MGR_1)
SELECT * FROM CUSTOMERS

SELECT * FROM SYS.dm_db_index_physical_stats(DB_iD('BEMBEL_LAB7'), OBJECT_ID('OFFICES'), NULL,NULL,NULL)

ALTER INDEX #TMP_TBL_3 ON #OFFIC REORGANIZE
SELECT  * FROM SYS.dm_db_index_physical_stats(DB_iD('BEMBEL_LAB7'), OBJECT_ID('SALESREPS'), NULL,NULL,NULL)

--ALTER INDEX #TMP_TBL_3 ON #OFFIC REBUILD WITH (ONLINE=OFF)
--SELECT  * FROM SYS.dm_db_index_physical_stats(DB_iD('tempdb'), OBJECT_ID('#OFFIC'), NULL,NULL,NULL)

--8.	��� ��������, ������������� � ������������ ������ � 3, �������� � ��������������� ����� ��������.
GO
CREATE VIEW VIEWCUST3
    AS SELECT CUST_NUM, COMPANY, CUST_REP, CREDIT_LIMIT
    FROM CUSTOMERS
	WHERE COMPANY = 'FIRST CORP.'   ----�� ��� ������
GO

--9.	�������� ������� ��� ����������� �������� �� ������������ ������ � 3.
--10.	�������� ����������� ������� ��� ���� ������ ������ ��������.
SELECT * FROM ���_��

SELECT DISTINCT
	ID_����, ���_��������, ID_��� 
FROM ���_��
WHERE ���_�������� != ID_���

exec SP_HELPINDEX '���_��';

CREATE INDEX #TRAINING ON ���_��(���_��������);
