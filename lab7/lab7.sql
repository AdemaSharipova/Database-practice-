-- #1 create a function:
-- a) Increments given values by 1 and returns it.

create or replace function increment(value integer)
    returns integer
as
$$
begin
    return value + 1;
end;
$$
    language plpgsql;

select increment(1);

-- b) Returns sum of 2 numbers.
create or replace function sum(in number1 integer, in number2 integer, out sum integer)
as
$$
begin
    sum := number1 + number2;
end;
$$
    language plpgsql;

select sum(2, 2);

-- c) Returns true or false if numbers are divisible by 2
create or replace function isDivisibleByTwo(in number integer)
    returns boolean
as
$$
begin
    if number % 2 = 0 then
        return true;
    else
        return false;
    end if;
end;
$$
    language plpgsql;

select isDivisibleByTwo(39);

-- d) Checks some password for validity.

create or replace function isPasswordValid(password character varying)
    returns boolean
as
$$
begin
    if length(password) >= 8 and
       password ~* '[a-z]' and
       password ~* '[0-9]' and
       (password like '%@%' or password like '%!%' or password like '%*%' or password like '%$%')
    then
        return true;
    else
        return false;
    end if;
end;
$$
    language plpgsql;

select *
from isPasswordValid('213ujkdfdjsk!!');

-- e)Returns two outputs, but has one input.

create or replace function two_outputs_one_input(inout password varchar, out isValid varchar)
as
$$
begin
    if isPasswordValid(password) = true then
        isValid = 'valid';
    else
        isValid = 'not valid';
    end if;
    raise notice '% password is %', password, isValid;
end
$$
    language plpgsql;

select *
from two_outputs_one_input('sfsdkfsdfs4324!');


-- #2 create a triger:
-- a) Return timestamp of the occured action within the database

create table worker
(
    id              serial primary key,
    name            varchar,
    date_of_birth   date,
    age             integer,
    salary          integer,
    work_experience integer,
    discount        integer
);

create or replace function timestamp_worker()
    returns trigger
    language plpgsql
as
$$
begin
    insert into timestamp_worker values (now());
    raise notice 'timestamp is %', now();
    return new;
end;
$$;

create table timestamp_worker
(
    time_action timestamp
);

create trigger timestamp_worker_trigger
    after insert or update or delete
    on worker
    for each row
execute procedure timestamp_worker();

insert into worker (name, date_of_birth, age, salary, work_experience, discount)
VALUES ('name4', '12-12-2022', 18, 100000, 2, 0.15);

update worker
set name = 'newName4'
where id = 4;

select *
from worker;
select *
from timestamp_worker;


-- b) Computes the age of a person when persons’date of birth is inserted.

create or replace function compute_age()
    returns trigger
    language plpgsql
as
$$
begin
    new.age = date_part('year', age(current_date, new.date_of_birth));
    return new;
end;
$$;


create trigger compute_age_trigger
    before insert
    on worker
    for each row
execute procedure compute_age();

insert into worker (name, date_of_birth, salary, work_experience, discount)
VALUES ('name5', '2001-10-12', 100000, 2, 0.15);

select *
from worker;

-- c) Adds 12% tax on the price of the inserted item.

create table item
(
    id    serial primary key,
    name  varchar,
    price float
);

create or replace function add_tax()
    returns trigger
    language plpgsql
as
$$
begin
    new.price := cast((new.price * 0.12 + new.price) as float);
    raise notice 'now, new price is %', new.price;
    return new;
end;
$$;

create trigger add_tax_trigger
    before insert
    on item
    for row
execute procedure add_tax();

insert into item (name, price)
VALUES ('name2', 23423);

select *
from item;

-- d) prevents deletion of any row from only one table.

create or replace function stop_deletion()
    returns trigger
    language plpgsql
as
$$
begin
    raise notice 'deletion stopped';
    return null;
end;
$$;


create trigger stop_deletion_trigger
    before delete
    on item
    for each row
execute procedure stop_deletion();

drop trigger stop_deletion_trigger on item;

delete
from item
where id = 2;
select *
from item;

-- d) Launches functions 1.d and 1.e.

create table user_table
(
    id       serial primary key,
    username varchar,
    password varchar
);


create trigger oneD_oneE_trigger
    before insert
    on user_table
    for each row
execute procedure oneD_oneE();

create or replace function oneD_oneE()
    returns trigger
    language plpgsql
as
$$
begin
    perform isPasswordValid(new.password);
    perform two_outputs_one_input(new.password);
    return new;
end
$$;

insert into user_table (username, password)
VALUES ('Username', 'sfjkdjfks');
select *
from user_table;

-- #3 create procedures:
-- a) Increases salary by 10% for every 2 years of work experience and provides
-- 10% discount and after 5 years adds 1% to the discount.

create or replace procedure increases_salary_discount()
    language plpgsql
as
$$
begin
    update worker
    set salary = salary + (salary * (work_experience / 2 * 0.1));
    update worker
    set discount = 10 + (work_experience / 5 * 0.1);
end;
$$;

select *
from worker;

call increases_salary_discount();

insert into worker (name, date_of_birth, age, salary, work_experience)
VALUES ('name6', '2003-12-12', 18, 100000, 3);

-- b) After reaching 40 years, increase salary by 15%. If work experience is more
-- than 8 years, increase salary for 15% of the already increased value for work
-- experience and provide a constant 20% discount.

create or replace procedure a_lot_changes()
    language plpgsql
as
$$
begin
    update worker
    set salary = salary * 1.15
    where age >= 40;

    update worker
    set salary = salary * 1.15, discount = 20
    where work_experience > 8;
end;
$$;

select * from worker;

insert into worker (name, date_of_birth, age, salary, work_experience)
VALUES ('name', '2003-12-12', 18, 100000, 9);

insert into worker (name, date_of_birth, salary, work_experience)
VALUES ('name', '1950-12-12', 100000, 9);

delete from worker where id = 11;

call a_lot_changes();


