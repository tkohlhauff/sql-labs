/*
Lab1 requirements: 
	Create table named dogs with columns name, size, color, and bark.
	Then enter at least 5 dogs worth of data into the table.
	Finally display both the structure and data from the table.
Pseudo-Code:
	create table dogs(name,size,color,bark)
	insert name size color bark into dogs 5 times
	display structure of table dogs
	display table dogs

*/
USE test;
/* use the database test */
CREATE TABLE dogs (name VARCHAR(20), size CHAR(1), color VARCHAR(15), bark CHAR(1));
/* 
creates a table with columns: 
	name, size(Either Big(b),Medimum(m), or Small(s)),color, and bark(Loud(l) or quiet(q))
*/
LOAD DATA LOCAL INFILE 'c:/Users/Trenton/Desktop/dogs.txt' INTO TABLE dogs;
/* Use a txt file to easily insert initial data into table */
DESCRIBE dogs;
/* Display structure of the table dogs */
SELECT * FROM dogs;
/* Display all data in table dogs */