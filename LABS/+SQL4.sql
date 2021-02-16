--1.1.	Выбрать все заказы, выполненные определенным покупателем.
select 
	ord.rep,
	ord.mfr,
	ord.product,
	ord.amount,
	ord.order_date,
	cus.cust_num,
	cus.company
from orders ord join customers cus
on ord.cust = cus.cust_num
where company = 'Chen Associates';

SELECT *
FROM ORDERS
WHERE CUST = 
		(SELECT CUST_NUM FROM CUSTOMERS WHERE COMPANY = 'Chen Associates');

--1.2.	Выбрать всех покупателей в порядке уменьшения обшей стоимости заказов.
select
	c.cust_num,
	c.company,
	o.amount,
	SumAmount=(select sum(amount) from orders o where o.cust=c.cust_num)
from orders o join customers c
on o.cust = c.cust_num
order by amount desc; 

--1.3.	Выбрать все заказы, которые оформлялись менеджерами из восточного региона.
select 
	--o.rep,
	o.order_num
	--o.mfr,
	--o.product,
	--s.manager
	--offi.region
from orders o join salesreps s
on o.rep = s.empl_num
join offices offi
on s.rep_office = offi.office
where offi.region like 'Eastern'
--order by manager;

select order_num
from orders
where rep in (select empl_num from salesreps where rep_office in 
(select office from offices where region = 'Eastern'))

--1.4.	Найти описания товаров, приобретенные покупателем First Corp.
select
	c.company,
	--s.manager,
	--o.mfr,
	--o.product,
	--o.rep,
	p.description
from customers c join salesreps s
on c.cust_rep = s.manager
join orders o
on s.empl_num = o.rep
join products p
on o.mfr = p.mfr_id
where company = 'First Corp.'

select description 
from products
where product_id in (select product from orders where cust =
		(select cust_num from customers where company = 'First Corp.'))

--1.5.	Выбрать всех сотрудников из Восточного региона и отсортировать по параметру Quota.
select
	s.name,
	s.quota,
	o.region
from salesreps s join offices o
on s.empl_num = o.mgr
where region like 'Eastern'
order by quota

select 
	s.name,
	s.quota,
	o.region
from salesreps s join offices o
on s.empl_num=o.mgr
where rep_office in (select office from offices where region='Eastern')
order by quota

--1.6.	Выбрать заказы, сумма которых больше среднего значения.
--select
	--mfr,
	--AMOUNT,
	--product,
	--avg(amount) as avg_amount
--from orders
--group by mfr, product, AMOUNT
--order by mfr
--------------------------------
select *
from orders
where amount > (select avg(amount) as avg_amount from orders);

--select avg(price) as avg_price
--from products
--group by product_id
--------------------------------
--select 
	--product, count(qty) as qty_product,
	--avg(amount) as avg_amount
--from orders
--group by product
--having avg(amount) > 8256;
---------------------------------
--select sum(price) as sum_price
--from products 
--group by product_id

--1.7.	Выбрать менеджеров, которые обслуживали одних и тех же покупателей.
select
	--c.company,
	c.cust_rep,
	o.rep,
	o.cust
	--s.manager,
	--s.name
from customers c join orders o
on c.cust_rep = o.rep
order by cust_rep

select 
	first.rep,
	second.rep,
	first.cust
from orders first, orders second
where first.cust = second.cust and first.rep > second.rep
---------------------------------
--select *
--from orders
--where rep =
--(select rep
--from orders)

--1.8.	Выбрать покупателей с одинаковым кредитным лимитом.
	
select
	first.cust_num as firstCust_num,
	second.cust_num as secondCust_num,
	first.credit_limit,
	first.company
from customers first, customers second
where first.credit_limit = second.credit_limit and first.cust_num = second.cust_num
order by credit_limit desc

--1.9.	Выбрать покупателей, сделавших заказы в один день.
select
	o.cust,
	o.order_num,
	o.order_date,
	c.company
from orders o join customers c
on o.cust = c.cust_num
order by order_date asc

select
	first.cust as firstCust,
	second.cust as secondCust,
	first.order_date,
	c.company
from orders first, orders second 
join customers c
on second.cust=c.cust_num 
where first.order_date = second.order_date
and first.cust = second.cust
order by order_date asc

--1.10.	Подсчитать, на какую сумму каждый офис выполнил заказы, и отсортировать их в порядке убывания.
select a.rep_office, sum(b.amount) as sum_amount
from orders b join salesreps a
on a.empl_num=b.rep
--where rep in 
--(select empl_num from salesreps where rep_office = 21 )
group by a.rep_office
--order by rep
------------------------------------
select a.rep_office, sum(b.amount) as sum_amount
from orders b join salesreps a
on a.empl_num=b.rep
group by a.rep_office
order by sum_amount desc

--1.11.	Выбрать сотрудников, которые являются начальниками (у которых есть подчиненные).
select manager, name
from salesreps
where manager is null

select o.mgr, s.manager, s.name  
from offices o join salesreps s
on o.mgr = s.empl_num
where o.mgr in (select s.manager from salesreps s where s.empl_num is not null)

--1.12.	Выбрать сотрудников, которые не являются начальниками (у которых нет подчиненных).
select manager, name
from salesreps
where manager is not null

--1.13.	Выбрать все продукты, продаваемые менеджерами из восточного региона.
select o.product,
		s.manager,
		offi.region
from orders o join salesreps s
on o.rep = s.manager 
join offices offi
on s.manager = offi.mgr
where rep in (
	select mgr from offices where region like 'eastern' 
)
-----------------------------------------------------

--1.14.	Выбрать фамилии и даты найма всех сотрудников и отсортировать по сумме заказов, которые они выполнили.
select 
	s.name, 
	s.hire_date,
	amount
from salesreps s join orders o
on s.manager = o.rep
order by amount asc

--where manager in (
	--select sum(amount) as sum_amount
	--from orders
	--order by amount asc
	--)

--1.15.	Выбрать заказы, выполненные менеджерами из  восточного региона и отсортировать по количеству заказанного по возрастанию.
select o.cust,
		o.product,
		s.manager,
		s.name,
		o.qty,
		offi.region
from orders o join salesreps s
on o.rep = s.manager 
join offices offi
on s.manager = offi.mgr
where rep in (
	select mgr from offices where region like 'eastern' 
)
order by o.qty asc

--1.16.	Выбрать товары, которые дороже товаров, заказанных компанией First Corp.
select 
	p.product_id,
	o.cust,
	--c.cust_num,
	--o.cust
	c.company,
	p.price
from CUSTOMERS c join ORDERS o
on c.CUST_NUM = o.CUST
join PRODUCTS p
on o.PRODUCT = p.PRODUCT_ID

where cust_num in(
	select price from PRODUCTS where price > 'First Corp' 
)

select 
	product_id,
	price
from products
where product_id in (select product from orders where amount > (select amount from orders
where cust = (select cust_num from customers where company = 'First Corp.')))

1.17.	Выбрать товары, которые не входят в товары, заказанные компанией First Corp.


--1.18.	Выбрать товары, которые по стоимости ниже среднего значения стоимости заказа по покупателю.
select
	cust,
	amount
from orders first
where amount < (select 
					avg(amount)
				from orders second
				where second.cust = first.cust)
order by cust

--1.19.	Найти сотрудников, кто выполнял заказы в 2008, но не выполнял в 2007 (как минимум 2-мя разными способами).
------------------1 METHOD--------------------------------------
SELECT	S.EMPL_NUM,
		S.NAME,
		YEAR(O.ORDER_DATE) AS Fin_Year
FROM ORDERS O JOIN SALESREPS S
ON   O.REP = S.EMPL_NUM
WHERE YEAR(O.ORDER_DATE) = 2008 OR YEAR(O.ORDER_DATE) IS NULL

UNION

SELECT	S.EMPL_NUM,
		S.NAME,
		YEAR(O.ORDER_DATE) AS Fin_Year
FROM ORDERS O JOIN SALESREPS S
ON   O.REP = S.EMPL_NUM
WHERE YEAR(O.ORDER_DATE) = 2007 OR YEAR(O.ORDER_DATE) IS NULL
ORDER BY YEAR(O.ORDER_DATE) DESC

---------------2 METHOD-------------------------------------------------
SELECT	S.EMPL_NUM,
		S.NAME,
		O.ORDER_DATE
FROM SALESREPS S join ORDERS O
on O.REP = S.EMPL_NUM
WHERE 
EXISTS (SELECT O.REP FROM ORDERS O WHERE O.REP=S.EMPL_NUM AND 
			YEAR(O.ORDER_DATE) = 2008)
ORDER BY S.EMPL_NUM;
-----------------------------------------------------------------
SELECT	S.EMPL_NUM,
		S.NAME,
		O.ORDER_DATE
FROM SALESREPS S join ORDERS O
on O.REP = S.EMPL_NUM
WHERE 
NOT EXISTS (SELECT O.REP FROM ORDERS O WHERE O.REP=S.EMPL_NUM 
				AND YEAR(O.ORDER_DATE) = 2007)
ORDER BY S.EMPL_NUM;

--1.20.	Найти организации, которые не делали заказы в 2008, но делали в 2007 (как минимум 2-мя разными способами).
------------1 METHOD-------------------------------------------
SELECT  C.CUST_NUM,
		C.COMPANY,
		O.ORDER_DATE
FROM CUSTOMERS C JOIN ORDERS O
ON C.CUST_NUM = O.CUST
WHERE 
YEAR(O.ORDER_DATE) != 2008
ORDER BY C.CUST_NUM;
------------2 METHOD-------------------------------------------
SELECT  C.CUST_NUM,
		C.COMPANY,
		O.ORDER_DATE
FROM CUSTOMERS C JOIN ORDERS O
ON C.CUST_NUM = O.CUST
WHERE 
NOT EXISTS (SELECT O.CUST FROM ORDERS O WHERE O.CUST=C.CUST_NUM
				AND YEAR(O.ORDER_DATE) = 2008)
ORDER BY C.CUST_NUM;
---------------------------------------------------------------
SELECT  C.CUST_NUM,
		C.COMPANY,
		O.ORDER_DATE
FROM CUSTOMERS C JOIN ORDERS O
ON C.CUST_NUM = O.CUST
WHERE 
EXISTS (SELECT O.CUST FROM ORDERS O WHERE O.CUST=C.CUST_NUM
				AND YEAR(O.ORDER_DATE) IN (2007))
ORDER BY O.ORDER_DATE ASC;

--1.21.	Найти организации, которые делали заказы в 2008 и в 2007 (как минимум 2-мя разными способами).
SELECT  C.CUST_NUM,
		C.COMPANY,
		O.ORDER_DATE
FROM CUSTOMERS C JOIN ORDERS O
ON C.CUST_NUM = O.CUST
WHERE 
EXISTS (SELECT O.CUST FROM ORDERS O WHERE O.CUST=C.CUST_NUM
				AND YEAR(O.ORDER_DATE) IN (2008, 2007))
ORDER BY O.ORDER_DATE DESC;
------------------------------------------------------------------------------------------------------------------

--2.	Выполните DML операции:
--2.1.	Создайте таблицу Аудит (дата, операция, производитель, код) – она будет использоваться для контроля записи в таблицу PRODUCTS.
--2.2.	Добавьте во временную таблицу все товары.
--2.3.	Добавьте в эту же временную таблицу запись о товаре, используя ограничения NULL и DEFAULT.
2.4.	Добавьте в эту же временную таблицу запись о товаре, и одновременно добавьте эти же данные в таблицу аудита 
		(в столбце операция укажите INSERT, в столбце даты – текущую дату).
2.5.	Обновите данные о товарах во временной таблице – добавьте 20% к цене.
2.6.	Обновите данные о товарах, которые заказывала First Corp. во временной таблице – добавьте 10% к цене.
2.7.	Обновите данные о товаре во временной таблице, и одновременно добавьте эти же данные в таблицу аудита 
		(в столбце операция укажите UPDATE, в столбце даты – текущую дату).
2.8.	Удалите товары, которые заказывала First Corp. во временной таблице.
2.9.	Удалите данные о каком-либо товаре во временной таблице, и одновременно добавьте эти данные в таблицу аудита 
		(в столбце операция укажите DELETE, в столбце даты – текущую дату).
select *
from products where product_id = '41007'

CREATE TABLE AUDIT (DATE_ID INT, OPERATION VARCHAR(15), MANUFACTURER VARCHAR(15), CODE INT);

INSERT INTO PRODUCTS (MFR_ID, PRODUCT_ID, DESCRIPTION, PRICE, QTY_ON_HAND)
VALUES ('ACI', '41007', 'Test Product', default, null);

ALTER TABLE PRODUCTS ADD CONSTRAINT def_price 
		DEFAULT 100 FOR PRICE;
