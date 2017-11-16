-- Table creation queries

CREATE TABLE Student(
sid integer primary key not null,
sname varchar(15)
);

CREATE TABLE Major(
sid integer REFERENCES Student(sid),
major varchar(15)
);

CREATE TABLE Book(
bookno integer primary key not null,
title varchar(30),
price integer
);

CREATE TABLE Cites(
bookno integer REFERENCES Book(bookno),
citedbookno integer REFERENCES Book(bookno)
);

CREATE TABLE Buys(
sid integer REFERENCES Student(sid),
bookno integer REFERENCES Book(bookno)
);

--Tables have been populated using data.sql file

--Question 1
SELECT DISTINCT b.bookno, b.title
FROM Book b, Buys bu
WHERE b.bookno = bu.bookno AND bu.sid IN ((SELECT m.sid
                                           FROM Major m
                                           WHERE m.major = 'CS')
                                          INTERSECT
                                          (SELECT m.sid
                                           FROM Major m
                                           WHERE m.major = 'Math'))
AND b.price BETWEEN 10 AND 40;

--Question 2

select distinct s.sid, s.sname from Student s, Buys bu where s.sid = bu.sid and bu.bookno in (select b1.bookno from Book b1, Book b2, Cites c where b1.bookno = c.bookno and b2.bookno = c.citedbookno and b1.price > b2.price);

--Question 3

Select distinct c2.bookno from Cites c1, Cites c2 where c1.citedbookno = c2.citedbookno and c1.bookno <> c2.bookno;

--Question 4

select b.bookno from Book b where b.bookno not in (select bookno from Buys);

--Question 5

Select s.sid from Student s where exists(select b.bookno from Book b where b.price > 50 and b.bookno not in(select bu.bookno from Buys bu where bu.sid = s.sid) );

--Question 6

select distinct bu.bookno from Buys bu, Major m where bu.sid = m.sid and m.major = 'CS' and bu.bookno not in (Select bu1.bookno from Buys bu1, Major m1 where bu1.sid = m1.sid and m1.major = 'Math');

--Question 7

select distinct s.sid,  s.sname from student s, cites c where (s.sid,c.bookno) in (select distinct bu.sid, bu.bookno from buys bu where bu.sid in (select m.sid from major m where not exists (select m.sid from major m1 where m1.sid = m.sid and m1.major <> m.major)));

--Question 8

select distinct m.sid, m.major from major m where m.sid not in (select bu.sid from buys bu, book b where bu.bookno = b.bookno and b.price <=30);

--Question 9

select distinct bu.sid, b1.bookno from buys bu, book b1 where bu.bookno = b1.bookno and b1.price >= all(select b.price from book b where b.bookno in (select bu1.bookno from buys bu1 where bu1.sid = bu.sid)) order by(b1.bookno);

--Question 10

select distinct b.price from book b where exists(select b1.price from book b1 where b1.price > b.price) and not exists(select b1.price from book b1, book b2 where b1.price > b2.price and b2.price > b.price);

--Question 11

select distinct bu.sid, b1.bookno, c.bookno from buys bu, book b1, (select distinct bu1.bookno from buys bu1) c where b1.bookno <> c.bookno;

--Question 12

select distinct s.sid from student s where s.sid not in (select bu.sid from buys bu where bu.bookno in (select c.citedbookno from cites c where c.bookno = 2001)) order by (s.sid);

--Question 13

select distinct b1.bookno, b2.bookno from book b1, book b2 where (b1.bookno, b2.bookno) in (select bu1.bookno, bu2.bookno from buys bu1, buys bu2 where bu1.bookno <> bu2.bookno and bu1.sid = bu2.sid and (bu1.sid) in (select m.sid from major m where m.major = 'CS'));

--Question 14

select distinct bu.sid from buys bu where bu.bookno in (select bu.bookno from buys bu, book b where bu.bookno = b.bookno and b.price > any(select b1.price from buys bu1, book b1, major m where bu1.sid = m.sid and m.major = 'Math' and bu1.bookno = b1.bookno));
