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

create or replace function two_outputs_one_input(inout value1 integer, out value2 integer)
as
$$
begin
    value2 := value1 + 1;

end;
$$
    language plpgsql;

select *
from two_outputs_one_input(3);


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

create table timestamp_worker(
    time_action timestamp
);

create trigger timestamp_worker_trigger
    before insert or update or delete
    on worker
    for each row
execute procedure timestamp_worker();

insert into worker (name, date_of_birth, age, salary, work_experience, discount)
VALUES ('name4', '12-12-2022', 18, 100000, 2, 0.15);

update worker set name = 'newName4' where id = 4;

select * from worker;
select * from timestamp_worker;

-- b) Computes the age of a person when persons’date of birth is inserted.





