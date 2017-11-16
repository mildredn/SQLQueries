--Question 1
--I will create two tables A and B with each containing names and corresponding IDs. 

create table A(
a_id integer not null,
a_name varchar(15)
);
    
alter table a add primary key(a_id);
 
insert into A values(001, 'Jane Doe');

insert into A values(002, 'Arya Stark');

insert into A values(003, 'Haruno Sakura');

insert into A values(004, 'Ellen Degeneres');

insert into A values(005, 'Grace Hopper');

insert into A values(006, 'Rhonda Byrne');
    

create table B(b_id integer primary key not null, b_name varchar(15));

alter table b add constraint a_b foreign key(b_id) references a(a_id);
    
insert into B values(004, 'Ellen Degeneres');
insert into B values(005, 'Grace Hopper');
insert into B values(006, 'Rhonda Byrne');
    
SELECT * from a;
/*
a_id |     a_name      
------+-----------------
    1 | Jane Doe
    2 | Arya Stark
    3 | Haruno Sakura
    4 | Ellen Degeneres
    5 | Grace Hopper
    6 | Rhonda Byrne
(6 rows)
*/
SELECT * from b;
/*
 b_id |     b_name      
------+-----------------
    4 | Ellen Degeneres
    5 | Grace Hopper
    6 | Rhonda Byrne
(3 rows)
*/

--Question 1.a

(SELECT a_id from a) except (SELECT b_id from b);

(SELECT b_id from b) except (SELECT a_id from a);

(SELECT a_id from a) intersect (SELECT b_id from b);
        
--Question 1.b
   
SELECT exists(SELECT a_id from a where a_id not in (SELECT b_id from b)) as empty_a_minus_b, exists(SELECT b_id from b where b_id not in (SELECT a_id from a)) as empty_b_minus_a, exists (SELECT a_id from a where a_id in(SELECT b_id from b)) as empty_a_intersection_b;

    
--Question 2
    
create table c(
c_id integer not null primary key references a(a_id),
c_name varchar(15));
    
insert into c values(001, 'Jane Doe');
insert into c values(002, 'Arya Stark');
insert into c values(003, 'Haruno Sakura');
insert into c values(007, 'Raven Symone');
insert into c values(008, 'Daenerys T');

 --2.(a)
    
SELECT exists((SELECT a_id from a) intersect (SELECT b_id from b)) as a_intersect_b;
     
SELECT exists(SELECT a_id from a where a_id in (SELECT b_id from b)) as a_in_b;  
    
--2.(b)
   
SELECT not exists((SELECT a_id from a) intersect (SELECT b_id from b)) as a_intersect_b; 
       
SELECT not exists(SELECT a_id from a where a_id in (SELECT b_id from b)) as a_in_b;
        
--2.(c)
   
select exists(select a_id from a where a_id = all ((select a_id from a) intersect (select b_id from b))) as a_subset_intersect_b;
    
select exists(select a_id from a where a_id = all (select a_id from a where a_id in (select b_id from b))) as a_subset_in_b;
    
--2.(d)
    
 select exists(select a_id from a where a_id != all((select a_id from a) union (select b_id from b))) as a_notsuperset_intersect_b;

    
select exists(select b_id from b where b_id = all(select a_id from a)) as a_notsuperset_in_b;

--(e)
select exists(select u.a_id from ((select a_id from a) union (select b_id from b)) as u where u.a_id != all ((select a_id from a) intersect (select b_id from b))) as a_notequal_b;    
    
select not exists(select a_id from a where a_id = all (select b_id from b)) as a_notequal_b;

--(f)

--select exists (select count(1) from a where exists ((select a_id from a) except (select b_id from b))) < 2 as a_except_b;

--(g)


--(h)


--Question 3

create table p (coefficient bigint, degree bigint);
create table q (coefficient bigint, degree bigint);

insert into p values (2,2), (-5, 1), (5, 0);
insert into q values (3,3), (1,2), (-1,1);

--(a)
(select p.coefficient+q.coefficient as coefficient, p.degree from p, q where p.degree = q.degree) union (select p.coefficient as coefficient, p.degree as degree from p where p.degree not in(select q.degree from q)) union (select q.coefficient as coefficient, q.degree as degree from q where q.degree not in(select p.degree from p));

--(b)
select sum(p.coefficient*q.coefficient) as coefficient, p.degree+q.degree as degree from p, q group by(p.degree+q.degree);    
    
--Question 4
create table point (pid int, x int, y int);

INSERT INTO POINT values(1,0,0);
INSERT INTO POINT values(2,0,1);
INSERT INTO POINT values(3,1,0);
INSERT INTO POINT values(4,0,2);
INSERT INTO POINT values(5,1,1);
INSERT INTO POINT values(6,2,2);

--4.(a)

CREATE or replace FUNCTION distance(x1 FLOAT, y1 FLOAT, x2 FLOAT, y2 FLOAT)
     RETURNS FLOAT AS
     $$
          SELECT sqrt(power(x1-x2,2)+power(y1-y2,2));
     $$  LANGUAGE SQL;


select distinct p1.pid, p2.pid from point p1, point p2, point p3 where p1.pid <> p2.pid and  p2.pid <> p3.pid and distance(p1.x, p1.y, p2.x, p2.y) < distance(p3.x, p3.y, p2.x, p2.y) order by (p1.pid);

--4.(b)

create or replace function collinear(out pid1 int, out pid2 int, out pid3 int)
returns setof record 
as 
$$
    select p1.pid, p2.pid, p3.pid from point p1, point p2, point p3 where (p1.pid <> p2.pid and p2.pid <> p3.pid) and (p1.x = p2.x and p2.x =p3.x) or (p1.y= p2.y and p2.y = p3.y);
$$ LANGUAGE SQL;

select distinct * from collinear();

--Question 5
--Delete existing values from tables
DELETE FROM cites;
DELETE FROM buys;
DELETE FROM major;
DELETE FROM book;
DELETE FROM student;

--Insert values from data.sql

--5.(a)
create or replace function booksBoughtByStudent(sid int, out bookno int, out title varchar(30), out price integer) 
returns setof record
as
$$
    select bookno, title, price from book where bookno in(select bu.bookno from buys bu where bu.sid = $1);
$$ LANGUAGE SQL;

--5.(b)
select r.bookno, r.title, r.price from booksBoughtByStudent(1001) r;

select r.bookno, r.title, r.price from booksBoughtByStudent(1015) r;

--5.(c)
--5.c.(i)

select s.sid, s.sname from student s where(
select count(1) from booksBoughtByStudent(s.sid) r where r.price < 50) = 1;

--(ii)

select distinct m.sid from major m, booksBoughtByStudent(m.sid) r where m.major='CS' and r.bookno not in(
select distinct r1.bookno, m1.sid from major m1, booksBoughtByStudent(m1.sid) r1 where m1.major='Math');

--(iii)

select distinct s1.sid, s2.sid from buys s1, buys s2 where s1.sid<>s2.sid and s1.bookno in (select r1.bookno from booksBoughtByStudent(s1.sid) r1 where r1.bookno in(select r2.bookno from booksBoughtByStudent(s2.sid) r2));

--Question 6

--6.(a)

create or replace function studentWhoBoughtBook(bookno int, out sid int, out sname varchar(15)) 
returns setof record
as
$$
    select s.sid, s.sname 
    from student s, buys bu 
    where s.sid = bu.sid and bu.bookno = $1;
$$ LANGUAGE SQL;

--6.(b)

select r.sid, r.sname from studentWhoBoughtBook(2001) r;

select r.sid, r.sname from studentWhoBoughtBook(2010) r;

--6.(c)


--Question 7
--7.(a)

create or replace function numberOfBooksBoughtbyStudent(sid int)
returns bigint
as
$$
    select count(*) from buys where sid = $1;
$$ LANGUAGE SQL;
