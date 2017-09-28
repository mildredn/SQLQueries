--Question 1 
    
create database adc_mildrednoronha;

DROP TABLE Sailor;
DROP TABLE Boat;
DROP TABLE Reserves;

CREATE TABLE Sailor(
Sid integer primary key not null,
Sname varchar(20),
Rating integer,
Age integer
);

INSERT INTO Sailor VALUES (22, 'Dustin', 7 , 45);
INSERT INTO Sailor VALUES (29, 'Brutus', 1 , 33);
INSERT INTO Sailor VALUES (31, 'Lubber', 8, 55);
INSERT INTO Sailor VALUES (32, 'Andy', 8, 25);
INSERT INTO Sailor VALUES (58, 'Rusty', 10, 35);
INSERT INTO Sailor VALUES (64, 'Horatio', 7, 35);
INSERT INTO Sailor VALUES (71, 'Zorba', 10, 16);
INSERT INTO Sailor VALUES (74, 'Horatio', 9, 35);
INSERT INTO Sailor VALUES (85, 'Art', 3, 25);
INSERT INTO Sailor VALUES (95, 'Bob', 3, 63);

    --Query to view Sailor relation with all its rows
Select * from Sailor;

CREATE TABLE Boat(
Bid integer primary key not null,
Bname varchar(15),
Color varchar(15)
);

INSERT INTO Boat VALUES (101, 'Interlake', 'blue');
INSERT INTO Boat VALUES (102, 'Interlake', 'red');
INSERT INTO Boat VALUES (103, 'Clipper', 'green');
INSERT INTO Boat VALUES (104, 'Marine', 'red');

    --Query to view Boat relation with all its rows
Select * from Boat;

CREATE TABLE Reserves(
Sid integer REFERENCES Sailor(Sid),
Bid integer REFERENCES Boat(Bid),
Day varchar(10)
);

INSERT INTO Reserves VALUES (22, 101, 'Monday');
INSERT INTO Reserves VALUES (22, 102, 'Tuesday');
INSERT INTO Reserves VALUES (22, 103, 'Wednesday');
INSERT INTO Reserves VALUES (31, 102, 'Thursday');
INSERT INTO Reserves VALUES (31, 103, 'Friday');
INSERT INTO Reserves VALUES (31, 104, 'Saturday');
INSERT INTO Reserves VALUES (64, 101, 'Sunday');
INSERT INTO Reserves VALUES (64, 102, 'Monday');
INSERT INTO Reserves VALUES (74, 103, 'Tuesday');

    --Query to view Reserves relation with all its rows
Select * from Reserves;

/*#Question 2

#Trying the following query on the above relations to test the insertion of new values into the Reserves relation which references primary keys from Boat and Sailor relations respectively

# INSERT INTO Reserves VALUES (30, 110, 'Sunday');

#Result obtained ---

# ERROR:  insert or update on table "reserves" violates foreign key constraint "reserves_sid_fkey"
# DETAIL:  Key (sid)=(30) is not present in table "sailor".

#Reserves relation cannot accept values which do not exist as primary keys in the tables it references.

#Trying to delete a value from Boat that is referenced in Reserves will give an error.

# DELETE from Boat where Bid = 104;

#Result obtained ---

# ERROR:  update or delete on table "boat" violates foreign key constraint "reserves_bid_fkey" on table "reserves"
# DETAIL:  Key (bid)=(104) is still referenced from table "reserves".

#In the above queries we see that since the values we tried to alter/update were still being referenced in the Reserves relation as foreign keys, these actions were forbidden. This may be to prevent accidental deletions and to provide data integrity among relations referencing each other.

#Trying to delete a value in Sailor relation not referenced by any other relation

# DELETE from Sailor where Sid = 95;

#Result obtained ---

# DELETE 1

#This shows that even though sid is a foreign key in Reserves relation, the deletion of this value was possible because it was not referenced anywhere else. This ensures that deleting this value from Sailor relation does not mess with other relations.

#Trying to delete from Sailor when that value is being referenced in Reserves relation

# DELETE from Sailor where Sid = 74;

#Result obtained ---

# ERROR:  update or delete on table "sailor" violates foreign key constraint "reserves_sid_fkey" on table "reserves"
# DETAIL:  Key (sid)=(74) is still referenced from table "reserves".

#Again we see that this query violates the foreign key refernce constraint on Reserves. Sid = 74 is also present in Reserves and hence, cannot be deleted.*/

--#Question 3

--#(a)

SELECT sname, sid, rating from Sailor;

--#(b)

SELECT bname from Boat where color = 'red';

--#(c)

SELECT bname, color from Boat;

--#(d)

SELECT s.sname from Sailor as s, Reserves as r, Boat as b where s.sid = r.sid AND b.bid = r.bid AND b.color = 'red';

--#(e)

SELECT b.bname from Sailor as s, Reserves as r, Boat as b where s.age> 25 AND s.sid = r.sid AND b.bid = r.bid;

--#(f)

SELECT s.sname, b.color from Sailor as s, Reserves as r, Boat as b where s.sid = r.sid AND b.bid = r.bid AND NOT (b.color = 'green' OR b.color = 'red');

--#(g)

SELECT b1.bname from Reserves as r1, Boat as b1 where r1.bid = b1.bid AND b1.color = 'blue' 
UNION 
SELECT b2.bname from Reserves as r2, Boat as b2 where r2.bid = b2.bid AND b2.color = 'green';

--#(h)

SELECT b.bname from Boat as b where b.bid NOT IN (Select b1.bid from Boat as b1 , Reserves as r1 where b1.bid = r1.bid);

--#(i)

SELECT b.bname from Boat b where b.bid in (select b1.bid from Boat b1, Reserves r1 where b1.bid = r1.bid group by b1.bid having count(r1.sid)>=2);

--#(j)

SELECT r.sid from Sailor s, Reserves r where r.sid = s.sid group by r.sid having count(r.bid) = 1;