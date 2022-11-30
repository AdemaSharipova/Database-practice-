--create tables "Warehouses" and "Boxes"
create table Warehouses
(
    code     serial primary key,
    location varchar(255),
    capacity int
);

create table Boxes
(
    code       char(4) primary key,
    contents   varchar(255),
    value      real,
    warehouses int references Warehouses
);

--4) Select all warehouses with all columns.
select *
from Warehouses;

--5) Select all boxes with a value larger than $150.
select *
from Boxes
where value > 150;

--6) Select all the boxes distinct by contents.
select distinct on (contents) *
from boxes;

--7)Select the warehouse code and the number of the boxes in
--each warehouse.
select warehouses, count(*)
from boxes
group by warehouses
order by warehouses;

--8)Same as previous exercise, but select only those warehouses
--where the number of the boxes is greater than 2.
select warehouses, count(*)
from boxes
group by warehouses
having count(*) > 2
order by warehouses;

--9)Create a new warehouse in New York with a capacity for 3
--boxes.
alter sequence warehouses_code_seq restart with 6;
insert into warehouses (location, capacity)
VALUES ('New York', 3);


--10)Create a new box, with code "H5RT", containing "Papers"
--with a value of $200, and located in warehouse 2.
insert into boxes (code, contents, value, warehouses)
values ('H5RT', 'Papers', 200, 2);

drop table boxes;
--11)Reduce the value of the third largest box by 15%.
update boxes
set value = value - (value * 0.15)
where value =
      (select distinct on (value) from boxes order by value desc nulls last limit 1 offset 2);

--12)Remove all boxes with a value lower than $150.
delete
from boxes
where value < 150;

select *
from boxes;

--13)Remove all boxes which is located in New York. Statement
--should return all deleted data.
delete
from boxes
where warehouses in (select code from warehouses where location = 'New York')
returning *;





