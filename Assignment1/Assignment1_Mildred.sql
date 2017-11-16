--Question 1

CREATE DATABASE adc_mildrednoronha;

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
INSERT INTO Sailor VALUES (32, 'ANDy', 8, 25);
INSERT INTO Sailor VALUES (58, 'Rusty', 10, 35);
INSERT INTO Sailor VALUES (64, 'Horatio', 7, 35);
INSERT INTO Sailor VALUES (71, 'Zorba', 10, 16);
INSERT INTO Sailor VALUES (74, 'Horatio', 9, 35);
INSERT INTO Sailor VALUES (85, 'Art', 3, 25);
INSERT INTO Sailor VALUES (95, 'Bob', 3, 63);

    --Query to view Sailor relation with all its rows
SELECT * FROM Sailor;

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
SELECT * FROM Boat;

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
SELECT * FROM Reserves;

/*#Question 2

#Trying the following query on the above relations to test the insertion of new values into the Reserves relation which references primary keys FROM Boat AND Sailor relations respectively

# INSERT INTO Reserves VALUES (30, 110, 'Sunday');

#Result obtained ---

# ERROR:  insert or update on table "reserves" violates foreign key constraint "reserves_sid_fkey"
# DETAIL:  Key (sid)=(30) is not present in table "sailor".

#Reserves relation cannot accept values which do not exist as primary keys in the tables it references.

#Trying to delete a value FROM Boat that is referenced in Reserves will give an error.

# DELETE FROM Boat WHERE Bid = 104;

#Result obtained ---

# ERROR:  update or delete on table "boat" violates foreign key constraint "reserves_bid_fkey" on table "reserves"
# DETAIL:  Key (bid)=(104) is still referenced FROM table "reserves".

#In the above queries we see that since the values we tried to alter/update were still being referenced in the Reserves relation as foreign keys, these actions were forbidden. This may be to prevent accidental deletions AND to provide data integrity among relations referencing each other.

#Trying to delete a value in Sailor relation not referenced by any other relation

# DELETE FROM Sailor WHERE Sid = 95;

#Result obtained ---

# DELETE 1

#This shows that even though sid is a foreign key in Reserves relation, the deletion of this value was possible because it was not referenced anyWHERE else. This ensures that deleting this value FROM Sailor relation does not mess with other relations.

#Trying to delete FROM Sailor when that value is being referenced in Reserves relation

# DELETE FROM Sailor WHERE Sid = 74;

#Result obtained ---

# ERROR:  update or delete on table "sailor" violates foreign key constraint "reserves_sid_fkey" on table "reserves"
# DETAIL:  Key (sid)=(74) is still referenced FROM table "reserves".

#Again we see that this query violates the foreign key refernce constraint on Reserves. Sid = 74 is also present in Reserves AND hence, cannot be deleted.*/

--#Question 3

--#(a)

SELECT sname, sid, rating
FROM Sailor;

--#(b)

SELECT bname
FROM Boat
WHERE color = 'red';

--#(c)

SELECT bname, color
FROM Boat;

--#(d)

SELECT s.sname
FROM Sailor as s, Reserves as r, Boat as b
WHERE s.sid = r.sid
  AND b.bid = r.bid
  AND b.color = 'red';

--#(e)

SELECT b.bname
FROM Sailor as s, Reserves as r, Boat as b
WHERE s.age> 25
  AND s.sid = r.sid
  AND b.bid = r.bid;

--#(f)

SELECT s.sname, b.color
FROM Sailor as s, Reserves as r, Boat as b
WHERE s.sid = r.sid
  AND b.bid = r.bid
  AND NOT (b.color = 'green'
            OR b.color = 'red');

--#(g)

SELECT b.bname
FROM Boat b, Reserves r
WHERE b.bid = r.bid
  AND r.sid in ((SELECT r1.sid
                FROM Reserves r1, Boat b1
                WHERE b1.bid = r1.bid
                AND b1.color = 'blue')
                INTERSECT
                (SELECT r1.sid
                FROM Reserves r1, Boat b1
                WHERE b1.bid = r1.bid
                AND b1.color = 'green'));

--#(h)

(SELECT b.bid
  FROM Boat b)
EXCEPT
(SELECT r.bid
  FROM Reserves r);

--#(i)

SELECT b.bname
FROM Boat b
WHERE b.bid in (SELECT b1.bid
                FROM Reserves r1, Reserves r2
                WHERE r1.bid = r2.bid
                AND r1.sid <> r2.sid);

--#(j)

(SELECT r.sid
  FROM Reserves)
EXCEPT
(SELECT r1.sid
  FROM Reserves r1, Reserves r2
  WHERE r1.bid = r2.bid
  AND r1.sid <> r2.sid));
