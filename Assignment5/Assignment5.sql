-- Question 1

-- Function setunion

create or replace function setunion(A anyarray, B anyarray) returns anyarray as
$$
with
    Aset as (select UNNEST(A)),
    Bset as (select UNNEST(B))
select array( (select * from Aset) union (select * from Bset) order by 1);
$$ language sql;


-- (a) Function setintersection

create or replace function setintersection(A anyarray, B anyarray) returns anyarray as
$$
with
    Aset as (select UNNEST(A)),
    Bset as (select UNNEST(B))
select array( (select * from Aset) intersect (select * from Bset) order by 1);
$$ language sql;

-- (b) Function setdifference

create or replace function setdifference(A anyarray, B anyarray) returns anyarray as
$$
with
    Aset as (select UNNEST(A)),
    Bset as (select UNNEST(B))
select array( (select * from Aset) except (select * from Bset) order by 1);
$$ language sql;

-- Function memberof

create or replace function memberof(x anyelement, S anyarray) returns boolean as
$$
    select x = SOME(S)
$$ language sql;

-- Question 2

-- View student_books

create or replace view student_books as
    select s.sid, array(select t.bookno 
                        from buys t
                        where  t.sid = s.sid 
                        order by bookno) as books 
    from student s order by sid;

select * from student_books;

-- (a) View book_students

create or replace view book_students as
    select b.bookno, array(select bu.sid
                           from buys bu 
                           where bu.bookno = b.bookno
                           order by bu.sid) as students
    from book b order by bookno;

select * from book_students;

-- (b) View book_citedbooks

create or replace view book_citedbooks as
    select distinct b.bookno, array(select c.citedbookno
                          from cites c
                          where c.bookno = b.bookno
                          order by c.citedbookno) as citedbooks
    from book b order by bookno;
    
select * from book_citedbooks;

-- (c) View book_citingbooks

create or replace view book_citingbooks as
    select distinct b.bookno, array(select c.bookno
                          from cites c
                          where c.citedbookno = b.bookno
                          order by c.bookno) as citingbooks
    from book b order by bookno;
    
select * from book_citingbooks;

-- (d) View major_students

create or replace view major_students as
    select distinct m.major, array(select m1.sid
                         from major m1
                         where m1.major = m.major
                         order by sid) as m_students
    from major m order by m.major;
    
select * from major_students;

-- (e) View student_majors

create or replace view student_majors as
    select distinct s.sid, array(select m.major
                                from major m
                                where m.sid = s.sid
                                order by major) as s_majors
    from student s order by s.sid;
    
select * from student_majors;

-- Question 3

-- (a)
with 
bookslessthan50 as (select bookno from book where price < 50)
select distinct bcb.bookno 
from book_citingbooks bcb natural join bookslessthan50 
where cardinality(bcb.citingbooks) >=2;

-- (b)

select distinct b.bookno, b.title 
from book b, student_books sb natural join student_majors sm where memberof(b.bookno, sb.books) and sm.s_majors <@ '{"Math", "CS"}' and '{"Math", "CS"}' <@ sm.s_majors;

-- (c)

-- (d)

select bookno from book_citingbooks where cardinality(citingbooks) = 1;

-- (e) 
create or replace function allequal(A anyarray, B anyarray) returns boolean as
$$
    select (A <@ B)  and (B <@ A);
$$ language sql;

with 
booksmorethan50 as (select array(select bookno from book where price > 50) as booklist)

select distinct sb.sid from student_books sb, booksmorethan50 b where allequal(sb.books, b.booklist);

-- (f)
create or replace function alle(A anyarray, B anyarray) returns boolean as
$$
    select (A <@ B);
$$ language sql;

with 
booksmorethan50 as (select array(select bookno from book where price < 50) as booklist)

select distinct sb.sid from student_books sb, booksmorethan50 b where alle(sb.books, b.booklist);

-- (g)

create or replace function alle(A anyarray, B anyarray) returns boolean as
$$
    select A <@ B ;
$$ language sql;

with 
booksmorethan50 as (select array(select bookno from book where price > 50) as booklist)

select distinct sb.sid from student_books sb, booksmorethan50 b where alle(sb.books, b.booklist);

-- (q)
with bookstudentanthro as (select bs.bookno from book_students bs natural join student_majors sm where memberof("Anthropology", sm.s_majors))
select sb.sid from student_books sb, bookstudentanthro bsa where cardinality(sb.books) < cardinality(bsa.bookno);
-- (r)
select distinct bcb.bookno from book_citingbooks bcb natural join book_citedbooks bcdb where cardinality(bcb.citingbooks) >=2 and cardinality(bcdb.citedbooks) <4;
