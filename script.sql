/**************DANIEL ESTEBAN CIFUENTES COSSIO************************/
/*****************************PART I**********************************/
--1. Create a tablespace with name 'quiz' and three datafiles. Each datafile of 15Mb.
CREATE TABLESPACE quiz 
DATAFILE 'datafile1' SIZE 15M, 
'datafile2' SIZE 15M,
'datafile3' SIZE 15M;

--2. Create a profile with idle time of 20 minutes, the name of the profile should be 'student'

CREATE PROFILE student LIMIT
CONNECT_TIME 20;

--3. Create an user named "usuario_1" with password "usuario_1". 
	-- The user should be associated to the tablespace "quiz"
    -- The user should has the profile "student"
    
CREATE USER usuario_1
IDENTIFIED BY usuario_1
DEFAULT TABLESPACE quiz
PROFILE student
QUOTA UNLIMITED ON quiz;

	-- The user should be able to connect
    
GRANT CONNECT TO usuario_1;

    	-- The user should be able to create tables WITHOUT USING THE DBA ROLE. 

GRANT CREATE TABLE TO usuario_1;

--4. Create an user named "usuario_2" with password "usuario_2"
	-- The user should has the profile "student"
	-- The user should be associated to the tablespace "quiz"
	-- The user shouldn't be able to create tables.
    
CREATE USER usuario_2
IDENTIFIED BY usuario_2
DEFAULT TABLESPACE quiz
PROFILE student;

    -- The user should be able to connect
GRANT CONNECT TO usuario_2;

/*****************************PART II**********************************/

--1. With the usuario_1 create the next table (DON'T CHANGE THE NAME OF THE TABLE NOR COLUMNS:
--2. Import this data (The format of the date is "YYYY-MM-DD HH24:MI:SS"): 
--https://gist.github.com/amartinezg/6c2c27ae630102dbfb499ed22b338dd8
create table attacks (
	id INT,
	url VARCHAR(2048),
	ip_address VARCHAR(20),
	number_of_attacks INT,
	time_of_last_attack TIMESTAMP
);

--3. Give permission to view table "attacks" of the usuario_2 (Do selects)
GRANT SELECT ON ATTACKS TO usuario_2;

/*****************************PART III QUERYS**********************************/

--1. Count the urls which have been attacked and have the protocol 'https'
SELECT COUNT (number_of_attacks) FROM usuario_1.ATTACKS WHERE URL LIKE 'https%';

--2. List the records where the URL attacked matches with google 
--(it does not matter if it is google.co.jp, google.es, google.pt, etc) order by number of attacks ascendent

SELECT * FROM usuario_1.ATTACKS WHERE URL LIKE '%google%' ORDER BY number_of_attacks asc;

--3. List the ip addresses and the time of the last attack if the attack has been produced the last year (2017)
--(Hint: https://stackoverflow.com/a/30071091)

SELECT ip_address, time_of_last_attack FROM usuario_1.ATTACKS 
WHERE time_of_last_attack  BETWEEN TO_DATE ('2017-01-01T00:00:00', 'YYYY-MM-DD"T"HH24:MI:SS')
                               AND TO_DATE ('2017-12-31T23:59:59', 'YYYY-MM-DD"T"HH24:MI:SS');
                               
--4. Show the first IP Adress which has been registered with the minimum number of attacks 

SELECT ip_address FROM usuario_1.ATTACKS
WHERE ROWNUM =1 ORDER BY number_of_attacks ASC, time_of_last_attack ASC;

--5. Show the ip address and the number of attacks if instagram has been attack using https protocol
SELECT ip_address, number_of_attacks FROM usuario_1.ATTACKS WHERE URL LIKE '%https%instagram%' ORDER BY number_of_attacks asc;

