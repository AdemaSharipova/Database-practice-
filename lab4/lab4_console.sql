--Find all courses worth more than 3 credits;
select *
from course
where credits > 3;

--Find all classrooms situated either in ‘Watson’ or ‘Packard’ buildings;
select *
from classroom
where building = 'Watson'
   or building = 'Packard';

--Find all courses offered by the Computer Science department;
select *
from course
WHERE dept_name = 'Comp. Sci.';

--Find all courses offered during fall;
select *
from course
where course_id in (select course_id from section where semester = 'Fall');

--Find all students who have more than 45 credits but less than 90;
select *
from student
where tot_cred > 45
  and tot_cred < 90;

--Find all students whose names end with vowels;
select *
from student
where right(name, 1) = 'a'
   or right(name, 1) = 'o'
   or right(name, 1) = 'e'
   or right(name, 1) = 'i'
   or right(name, 1) = 'y'
   or right(name, 1) = 'u';

--Find all courses which have course ‘CS-101’ as their prerequisite;
select *
from course
where course_id in (select course_id from prereq where prereq_id = 'CS-101');

--#2
/*For each department, find the average salary of instructors in that
 department and list them in ascending order. Assume that every
 department has at least one instructor */
select avg(salary) as salary_average, dept_name
from instructor
group by dept_name
order by dept_name;

--Find the building where the biggest number of courses takes place
select building
from classroom
where capacity = (select max(capacity) from classroom);

--Find the department with the lowest number of courses offered !!!!!!!!!
select *
from department
where dept_name in (select dept_name
                    from course
                    group by dept_name
                    having count(*) in (select count(*) from course group by dept_name order by count(*) limit 1));


--Find the ID and name of each student who has taken more than 3 courses
--from the Computer Science department
select id, name
from student
where id in (select id
             from takes
             where course_id in (select course_id from course where dept_name = 'Comp. Sci.')
             group by id
             having count(*) > 3);

--Find all instructors who work either in Biology, Philosophy, or Music
--departments;

select *
from instructor
where id in (select id
             from teaches
             where course_id in
                   (select course_id
                    from course
                    where dept_name = 'Biology'
                       or dept_name = 'Philosophy'
                       or dept_name = 'Music'));

--Find all instructors who taught in the 2018 year but not in the 2017 year; !!!!!

-- select *
-- from instructor
-- where id in (select id from teaches group by id where year = 2018);
select *
from instructor
where id in
      ((select id from teaches where year = 2018) except (select id from teaches where year = 2017));

--#3
--Find all students who have taken Comp. Sci. course and got an excellent
--grade (i.e., A, or A-) and sort them alphabetically

select *
from student
where id in (select id
             from takes
             where course_id in (select course_id from course where dept_name = 'Comp. Sci.')
               and (grade = 'A' or grade = 'A-'))
order by name;

--Find all advisors of students who got grades lower than B on any class;
select *
from instructor
where id in
      (select distinct i_id
       from advisor
       where s_id in (select id from takes where grade != 'A' and grade != 'A-' and grade != 'B+' and grade != 'B'));

--Find all departments whose students have never gotten an F or C grade;
select *
from department
where dept_name in ((select dept_name
                     from student
                     where id in (select id
                                  from takes
                                  where grade != 'F'
                                    and grade != 'C')
                     except
                     (select dept_name
                      from student
                      where id in (select id
                                   from takes
                                   where grade = 'F'
                                      or grade = 'C'))));

--Find all instructors who have never given an A grade in any of the courses they taught;
select *
from instructor
where dept_name in (select dept_name
                    from student
                    where id in (select id from takes where grade != 'A' except select id from takes where grade = 'A')
                    except
                    select dept_name
                    from student
                    where id in (select id from takes where grade = 'A' except select id from takes where grade != 'A'));

--Find all courses offered in the morning hours (i.e., courses ending before 13:00);

select * from course where course_id in (
select course_id
from section
where time_slot_id in
      (select time_slot_id from time_slot where (end_hr <= 12 and end_min <= 59))
except (select course_id
from section
where time_slot_id in
      (select time_slot_id from time_slot where (end_hr >= 12))));





