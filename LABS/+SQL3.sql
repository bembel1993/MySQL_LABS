--3.1.	������� ������� � ���� ����� ���� �����������.
select name, hire_date 
from salesreps;

--3.2.	������� ��� ������, ����������� ����� ���������� ����.
select * from orders
where order_date > '2008-01-12';

--3.3.	������� ��� ����� �� ������������� ������� � ����������� ������������ �����������.
select office,
		region		
from offices; 

--3.4.	������� ������, ����� ������� ������ ������������� ��������.
select DESCRIPTION, price
from products
where price > '1875.00';

--3.5.	������� ������ ������������� ����������.
select cust,
		mfr
from orders
where cust = 2111;

--3.6.	������� ������, ��������� � ������������ ������.
select order_date = '2008-03-02',
		product
from orders;

--3.7.	������� ����� �� 12, 13 � 21 �������.
select office,
		region
from offices
where office = 12;

--3.8.	������� ����������, � �������� ��� ��������� (������ ��������).
select name
from salesreps
where manager is null;

--3.9.	������� ����� �� �������, ������� ���������� �� East.
select office, region
from offices
where region like 'East%';

--3.10.	������� ���� �������� � ����� ������ ������������� �������� � ������������� � ������� �������� ����.
select description, price
from products
where price > 2500
order by price desc;

--3.11.	������� ������� � ���� ����� ���� ����������� � ������������� �� ��������.
select name, age, hire_date
from salesreps
order by age asc;

--3.12.	������� ��� ������ � ������������� ������� �� ��������� �� ��������, � ����� �� ���������� ����������� �� �����������.
SELECT order_num, AMOUNT, qty 
FROM orders 
ORDER BY amount desc, qty asc;

--3.13.	������� 5 ����� ������� �������.
select top 5 description, price
from products
order by price desc;

--3.14.	������� 3 ����� ������� �����������.
select top 3 name, age
from salesreps
order by age asc;

--3.15.	������� 20% ����� ������� �������.
select top 20 percent amount, product
from orders;

--3.16.	������� 11 ����������� � ����� ������� ��������� �������.
select top 11 cust_num, credit_limit
from customers
order by credit_limit desc;

--3.17.	������� ����������� � 4 �� 7, ��������������� �� ���� �����.
SELECT name, hire_date
FROM   salesreps
order by hire_date desc
OFFSET 3 ROWS 
FETCH NEXT 4 ROWS ONLY;

--3.18.	������� ����������� � 4 �� 7, ��������������� �� �������� � ���, ��� � ���� ������ ��������.
SELECT name, age
FROM   salesreps
order by age asc
OFFSET 3 ROWS 
FETCH NEXT 4 ROWS ONLY;

select name, rep_office from (
	select top 5 with ties *
	from salesreps
	order by rep_office) x
except
select name, rep_office from(
	select top 2 * 
	from salesreps
	order by rep_office) y;

select * from offices where region = 'Eastern'
union
select * from offices where region = 'Western';

select * from offices where region = 'Eastern'
except
select * from offices where region = 'Western';

select * from offices where region = 'Eastern'
intersect
select * from offices where region = 'Western';

--3.19.	������� ���������� ������ � �������.
select distinct product 
from orders;

--3.20.	���������� ���������� ������� ��� ������� ����������.
select cust, sum(QTY) as sum_QTY
from orders 
group by cust;
--having count(*) > 1;

--3.21.	���������� �������� ����� ������ ��� ������� ����������.
select cust, sum(amount) as sum_amount
from orders 
group by cust;

--3.22.	���������� ������� ���� ������ ��� ������� ����������.
select cust, avg(amount) as sum_amount
from orders 
group by cust;

--3.23.	����� �����������, � ������� ���� ����� ��������� ���� ������������� ��������.
select cust, amount
from orders
where amount > 22500;

--3.24.	����� ���������� ��������� ��� ������� �������������.
select mfr, sum(qty) as sum_qty
from orders
group by mfr;

--3.25.	����� ����� ������� ����� ������� �������������.
select max(price) as high_price
from products

--3.26.	����� ����������� � �� ������ 
--(� �������������� ������ ������ ����: 
--������������ ����������, ������������ ������, �������������, ���������� � �������� �����).
select * from orders;
select * from customers;

select
	c.company, 
	o.product,
	o.mfr,
	o.qty,
	o.amount
from orders o join customers c
on o.cust = c.cust_num;

--3.27.	����� ���� ����������� � �� ������.
select
	c.company, 
	o.product,
	o.mfr,
	o.qty,
	o.amount
from customers c left join orders o
on o.cust = c.cust_num;

--3.28.	����� �����������, � ������� ��� �������.
select
	c.company, 
	o.product,
	o.mfr,
	o.qty,
	o.amount
from customers c left join orders o
on o.cust = c.cust_num
where o.order_num is null;

--3.29.	����� �����������, � ������� ���� ������ � ������������ ������.
 select
	c.company, 
	o.product,
	o.mfr,
	o.qty,
	o.amount,
	o.order_date
from customers c left join orders o
on o.cust = c.cust_num
where o.order_date = '2007-10-12';

--3.30.	����� �����������, � ������� ���� ������ ���� ������������ �����.
select
	c.company, 
	o.product,
	o.mfr,
	o.qty,
	o.amount,
	o.order_date
from customers c left join orders o
on o.cust = c.cust_num
where o.amount > 22500;

--3.31.	����� ������, ������� ��������� ��������� �� ������� EAST.
select
	o.mfr,
	o.product,
	s.manager,
	s.name,
	offi.region
from orders o join salesreps s
on o.rep = s.manager
join offices offi
on s.manager = offi.mgr
where offi.region like 'east%'

--3.32.	����� ������, ������� ������ ���������� � ��������� ������� ������ 40000.
select
	c.company,
	c.CREDIT_LIMIT,
	o.product,
	o.mfr,
	o.qty
from customers c left join orders o
on o.cust = c.cust_num
where CREDIT_LIMIT > 40000; 

-----------------------------------------------------------------------
--3.33.	����� ���� ����������� �� ������� EAST � ��� �� ������.
select 
	s.name,
	s.empl_num, 
	ord.product,
	ord.amount,
	ord.qty
from salesreps s left join orders ord
on s.empl_num = ord.cust
where region like 'East%';

select 
	s.name,
	s.empl_num,
	o.region,
	od.order_num,
	od.order_date,
	od.amount
from salesreps s join offices o
on s.rep_office = o.office
left join orders od 
on s.empl_num = od.rep
where o.region like 'east%'
order by od.amount;
-----------------------------------------------------------------------

--3.34.	����� �����������, ������� �� �������� �� ������ ������.
select *
from salesreps
where quota is null;

--3.35.	����� ����������� ������ ��������.
SELECT distinct age, name 
FROM  salesreps 
WHERE  age = 45;
-------------------------------------------------------------------------
select 
	top 3
	sum(od.qty) as sum_qty,
	
	p.description,
	p.PRODUCT_ID
from products p join orders od
on p.QTY_ON_HAND = od.qty
group by p.DESCRIPTION, p.PRODUCT_ID
order by sum(od.qty) desc;

select *
from products
order by description asc  -- ����������� �� ��������