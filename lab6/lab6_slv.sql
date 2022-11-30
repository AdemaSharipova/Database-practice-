-- #1
-- a) Combine each row of dealer table with each row of client table;
SELECT *
FROM dealer,
     client;

-- b) Find all dealers along with client name, city, grade, sell number,
-- date, and amount
SELECT d.name                                                                            AS "dealer name",
       c.name                                                                            AS "customer name",
       c.city                                                                            AS "customer city",
       (SELECT count(*) FROM sell WHERE sell.dealer_id = d.id AND sell.client_id = c.id) AS sell_number,
       s.id                                                                              AS "sell id",
       s.date                                                                            AS "sell date",
       s.amount                                                                          AS "sell amount"
FROM dealer d
         JOIN client c ON d.id = c.dealer_id
         JOIN sell s ON d.id = s.dealer_id AND c.id = s.client_id;

--c) Find the dealer and client who belongs to same city
SELECT *
FROM dealer d
         JOIN client c ON c.city = d.location;

--d) Find sell id, amount, client name, city those sells where sell
-- amount exists between 100 and 500
SELECT s.id     AS "sale id",
       s.amount AS "sale amount",
       c.name   AS "customer name",
       c.city   AS "customer city"
FROM sell s
         JOIN client c ON s.client_id = c.id
WHERE s.amount BETWEEN 100 AND 500;

--e) Find dealers who works either for one or more client or not yet join
-- under any of the clients
SELECT *
FROM dealer
         FULL JOIN client ON dealer.id = client.dealer_id;

--f) Find the dealers and the clients he service, return
-- client name, city, dealer name, commission.
SELECT c.name   AS "customer name",
       c.city   AS "customer city",
       d.name   AS "dealer name",
       d.charge AS "dealer commission"
FROM dealer d
         JOIN client c ON d.id = c.dealer_id;

--g) find client name, client city, dealer, commission those dealers who
-- received a commission from the sell more than 12%
SELECT c.name   AS "customer name",
       c.city   AS "customer city",
       d.*,
       d.charge AS "dealer commission"
FROM client c
         JOIN dealer d ON c.dealer_id = d.id
WHERE d.charge > 0.12;

--h) make a report with client name, city, sell id, sell date, sell amount,
-- dealer name and commission to find that either any of the existing clients
-- haven’t made a purchase(sell) or made one or more purchase(sell) by their
-- dealer or by own.

select c.name   as "client name",
       c.city   as "client city",
       s.id     as "sell id",
       s.amount as "sell amount",
       d.name   as "dealer name",
       d.charge as "dealer commission"
from client c
         left join dealer d on c.dealer_id = d.id
         left join sell s on s.dealer_id = d.id and s.client_id = c.id;

-- i) find dealers who either work for one or more clients. The client may
-- have made, either one or more purchases, or purchase amount above 2000
-- and must have a grade, or he may not have made any purchase to the
-- associated dealer. Print client name, client grade, dealer name, sell id,
-- sell amount

select c.name     as "client name",
       c.priority as "client grade",
       d.name     as "dealer name",
       s.id       as "sell id",
       s.amount   as "sell amount"
from dealer d
         join client c on c.dealer_id = d.id
         left join sell s on d.id = s.dealer_id and c.id = s.client_id
where s.amount > 2000
  and c.priority is not null;


-- 2) Create following views:
-- a) count the number of unique clients, compute average and total purchase
-- amount of client orders by each date.

create or replace view client_or_by_each_date as
select count(distinct s.client_id), avg(amount), sum(amount), s.date
from sell s
group by s.date;

select *
from client_or_by_each_date;

-- b) find top 5 dates with the greatest total sell amount

create or replace view top_5_dates as
select count(distinct s.client_id), sum(amount), s.date
from sell s
group by s.date
order by sum(amount) desc nulls last
limit 5;

select *
from top_5_dates;

-- c) count the number of sales, compute average and total amount of all sales
-- of each dealer

create or replace view dealer_view as
select count(s.dealer_id), avg(s.amount), sum(s.amount), s.dealer_id
from sell s
group by dealer_id;

select *
from dealer_view;

-- d) compute how much all dealers earned from charge(total sell amount * charge)
-- in each location
create or replace view dealers_from_charge as
select d.location, sum(s.amount * d.charge)
from dealer d,
     sell s
where d.id = s.dealer_id
group by d.location;

select *
from dealers_from_charge;

-- e) compute number of sales, average and total amount of all sales dealers made in
-- each location
create or replace view sales_dealers as
select d.location, count(*), avg(s.amount), sum(s.amount)
from dealer d,
     sell s
where d.id = s.dealer_id
group by d.location;

select *
from sales_dealers;

-- f) compute number of sales, average and total amount of expenses in each city
-- clients made.
create or replace view clients_info as
select c.city, count(*), avg(s.amount), sum(s.amount)
from client c,
     sell s
where s.client_id = c.id
group by c.city;

select *
from clients_info;

-- g) find cities where total expenses more than total amount of sales in locations


-- Караганда ++
-- Алматы ++
-- Нур-Султан ++

select sales_dealers.location, clients_info.city, sales_dealers.sum, clients_info.sum
from sales_dealers,
     clients_info
where sales_dealers.location = clients_info.city
  and sales_dealers.sum < clients_info.sum;


select * from client join sell s on client.id = s.client_id;
select * from dealer join sell s on dealer.id = s.dealer_id;
select 65.26 + 2400.6 + 5760 + 3045.6;
select 250.45 + 270.65;
