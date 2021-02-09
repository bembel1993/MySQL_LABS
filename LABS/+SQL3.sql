--3.1.	Выбрать фамилии и даты найма всех сотрудников.
select name, hire_date 
from salesreps;

--3.2.	Выбрать все заказы, выполненные после опреденной даты.
select * from orders
where order_date > '2008-01-12';

--3.3.	Выбрать все офисы из определенного региона и управляемые определенным сотрудником.
select office,
		region		
from offices; 

--3.4.	Выбрать заказы, сумма которых больше определенного значения.
select DESCRIPTION, price
from products
where price > '1875.00';

--3.5.	Выбрать заказы определенного покупателя.
select cust,
		mfr
from orders
where cust = 2111;

--3.6.	Выбрать заказы, сделанные в определенный период.
select order_date = '2008-03-02',
		product
from orders;

--3.7.	Выбрать офисы из 12, 13 и 21 региона.
select office,
		region
from offices
where office = 12;

--3.8.	Выбрать сотрудника, у которого нет менеджера (самого главного).
select name
from salesreps
where manager is null;

--3.9.	Выбрать офисы из региона, который начинается на East.
select office, region
from offices
where region like 'East%';

--3.10.	Выбрать всех продукты с ценой больше определенного значения и отсортировать в порядке убывания цены.
select description, price
from products
where price > 2500
order by price desc;

--3.11.	Выбрать фамилии и даты найма всех сотрудников и отсортировать по возрасту.
select name, age, hire_date
from salesreps
order by age asc;

--3.12.	Выбрать все заказы и отсортировать вначале по стоиомсти по убыванию, а затем по количеству заказанного по возрастанию.
SELECT order_num, AMOUNT, qty 
FROM orders 
ORDER BY amount desc, qty asc;

--3.13.	Выбрать 5 самых дорогих товаров.
select top 5 description, price
from products
order by price desc;

--3.14.	Выбрать 3 самых молодых сотрудников.
select top 3 name, age
from salesreps
order by age asc;

--3.15.	Выбрать 20% самых дорогих заказов.
select top 20 percent amount, product
from orders;

--3.16.	Выбрать 11 покупателей с самым высоким кредитным лимитом.
select top 11 cust_num, credit_limit
from customers
order by credit_limit desc;

--3.17.	Выбрать сотрудников с 4 по 7, отсортированных по дате найма.
SELECT name, hire_date
FROM   salesreps
order by hire_date desc
OFFSET 3 ROWS 
FETCH NEXT 4 ROWS ONLY;

--3.18.	Выбрать сотрудников с 4 по 7, отсортированных по возрасту и тех, кто с ними одного возраста.
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

--3.19.	Выбрать уникальные товары в заказах.
select distinct product 
from orders;

--3.20.	Подсчитать количество заказов для каждого покупателя.
select cust, sum(QTY) as sum_QTY
from orders 
group by cust;
--having count(*) > 1;

--3.21.	Подсчитать итоговую сумму заказа для каждого покупателя.
select cust, sum(amount) as sum_amount
from orders 
group by cust;

--3.22.	Подсчитать среднюю цену заказа для каждого сотрудника.
select cust, avg(amount) as sum_amount
from orders 
group by cust;

--3.23.	Найти сотрудников, у которых есть заказ стоимости выше определенного значения.
select cust, amount
from orders
where amount > 22500;

--3.24.	Найти количество продуктов для каждого производителя.
select mfr, sum(qty) as sum_qty
from orders
group by mfr;

--3.25.	Найти самый дорогой товар каждого производителя.
select max(price) as high_price
from products

--3.26.	Найти покупателей и их заказы 
--(в результирующем наборе должны быть: 
--наименование покупателя, наименование товара, производитель, количество и итоговая сумма).
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

--3.27.	Найти всех покупателей и их заказы.
select
	c.company, 
	o.product,
	o.mfr,
	o.qty,
	o.amount
from customers c left join orders o
on o.cust = c.cust_num;

--3.28.	Найти покупателей, у которых нет заказов.
select
	c.company, 
	o.product,
	o.mfr,
	o.qty,
	o.amount
from customers c left join orders o
on o.cust = c.cust_num
where o.order_num is null;

--3.29.	Найти покупателей, у которых есть заказы в определенный период.
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

--3.30.	Найти покупателей, у которых есть заказы выше определенной суммы.
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

--3.31.	Найти заказы, которые оформляли менеджеры из региона EAST.
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

--3.32.	Найти товары, которые купили покупатели с кредитным лимитом больше 40000.
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
--3.33.	Найти всех сотрудников из региона EAST и все их заказы.
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

--3.34.	Найти сотрудников, которые не оформили ни одного заказа.
select *
from salesreps
where quota is null;

--3.35.	Найти сотрудников одного возраста.
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
order by description asc  -- группировка по алфавиту