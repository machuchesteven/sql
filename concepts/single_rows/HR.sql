SELECT USER FROM DUAL;

SELECT SYSDATE, SYSTIMESTAMP FROM DUAL;

SELECT UPPER(company_name), LOWER(company_name) FROM GOOD_PROJS;

SELECT 'O''Hearn' FROM DUAL;

select concat('Hello ', 'World') from dual;

select 'Hello '|| 'World' || ' It''s Me again' from dual;

select LPAD('Hello', 10, '-'), RPAD('Hello', 10, '-') from dual;

SELECT RTRIM('HELO -----', '-') FROM DUAL;


select soundex('Machuche'), soundex('Matufe') from dual;

select substr('Machuche', 3, -1) from dual; -- returns null

select substr('Machuche', 3) from dual; -- works well

select ceil(1.0) from dual;

select floor(1.10), floor(0.9) from dual;

select round(2.122921001, 3), round(23545, -3) from dual;


SELECT SYSDATE FROM DUAL;

SELECT SYSDATE TODAY, ROUND(SYSDATE, 'MM') ROUNDED_MONTH, ROUND(SYSDATE, 'RR') ROUNDED_YEAR, ROUND(SYSDATE) ROUND_DAY FROM DUAL;

SELECT TO_CHAR(ROUND(SYSDATE), 'DD-MM-RR HH:MI:SS') ROUNDED_DAY FROM DUAL;


SELECT TRUNC(sysdate, 'mi') AS TRUNC_MIN FROM dual;


SELECT to_char(TRUNC(sysdate, 'mm'), 'mm') AS TRUNC_MIN, to_char(ROUND(sysdate, 'mm'), 'mm') AS ROUND_MIN FROM dual;


SELECT NEXT_DAY(SYSDATE, 'Saturday') FROM DUAL;

select last_day(sysdate) from dual;


SELECT ADD_MONTHS(SYSDATE, 3) FROM DUAL;

SELECT ADD_MONTHS(SYSDATE, 3), ADD_MONTHS(SYSDATE, -3) FROM DUAL;


SELECT MONTHS_BETWEEN('07-feb-23', '07-may-23'), MONTHS_BETWEEN('07-feb-24', '07-may-23') FROM DUAL;


select numtoyminterval(1.5, 'Year') from dual;

SELECT NUMTOYMINTERVAL(12, 'YEAR') FROM DUAL;




SELECT NUMTODSINTERVAL(2400.23423, 'HOUR') FROM DUAL;

DROP TABLE SHIPS;


CREATE TABLE SHIPS(
ID NUMERIC PRIMARY KEY,
ROOM NUMERIC,
WINDOW VARCHAR2(20),
SQR_FT NUMERIC);
INSERT INTO SHIPS VALUES ( 1, 102, 'Ocean', 533);
INSERT INTO SHIPS VALUES ( 2, 103, 'Ocean', 160);
INSERT INTO SHIPS VALUES ( 3, 104, 'Ocean', 533);
INSERT INTO SHIPS VALUES ( 4, 105, 'None', 586);
INSERT INTO SHIPS VALUES ( 5, 106, 'Ocean', 205);
INSERT INTO SHIPS VALUES ( 6, 107, 'None', 1524);

SELECT SUM(SQR_FT) FROM SHIPS;

SELECT ID, WINDOW, SUM(SQR_FT) OVER (ORDER BY SQR_FT) "CUMULATIVE SQR_FT" FROM SHIPS ORDER BY ID;

SELECT ID, WINDOW, SUM(SQR_FT) OVER (ORDER BY ID) "CUMULATIVE SQR_FT" FROM SHIPS;

SELECT ID, WINDOW, SUM(SQR_FT) OVER (PARTITION BY WINDOW ORDER BY ID) "CUMULATIVE SQR_FT" FROM SHIPS;

SELECT ID, WINDOW, SQR_FT, SUM(SQR_FT) OVER (PARTITION BY WINDOW ORDER BY ID) "CUMULATIVE SQR_FT", SUM(SQR_FT) OVER (PARTITION BY WINDOW ORDER BY ID ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) "SUBSET_CUMULATIVE" FROM SHIPS ORDER BY ID;


SELECT ID, LAG(ID) OVER (ORDER BY ID), LEAD(ID) OVER (ORDER BY ID) FROM SHIPS;

SELECT ID, LAG(ID) OVER (PARTITION BY WINDOW ORDER BY ID), LEAD(ID) OVER ( PARTITION BY WINDOW ORDER BY ID) FROM SHIPS;

SELECT ID, LAG(ID) OVER (ORDER BY ID), LEAD(ID) OVER (ORDER BY ID) ,LAG(ID) OVER (PARTITION BY WINDOW ORDER BY ID), LEAD(ID) OVER ( PARTITION BY WINDOW ORDER BY ID) FROM SHIPS;

select id, stddev(id) over (order by id) from ships;


select stddev(id), variance(id), avg(id), median(id) from ships;

select stddev(sqr_ft), variance(sqr_ft), avg(sqr_ft), median(sqr_ft) from ships;


select stddev(sqr_ft) OVER (ORDER BY sqr_ft) , variance(sqr_ft)  OVER (ORDER BY sqr_ft) , avg(sqr_ft) over (order by sqr_ft) from ships;

select window, room, sqr_ft, percentile_cont(0.6) within group (order by sqr_ft) over (partition by window) "PCT" from ships order by sqr_ft;


SELECT 'Mikocheni, Dar es Salaam', INSTR('Mikocheni, Dar es Salaam', ', ') AS "COMMA", SUBSTR('Mikocheni, Dar es Salaam', INSTR('Mikocheni, Dar es Salaam', ',')) AS "State" from dual;

SELECT 'Mikocheni, Dar es Salaam', INSTR('Mikocheni, Dar es Salaam', ', ') AS "COMMA", SUBSTR('Mikocheni, Dar es Salaam', INSTR('Mikocheni, Dar es Salaam', ',')+2) AS "State" from dual;

SELECT 'Chapter ' || 1  ||' .... I am Born' FROM DUAL;

select to_number('374,000.98', '9G99d99', 'nls_numeric_characters='',.'' ') from dual;

SELECT TO_NUMBER('$5000', 'L9999D99' , 'NLS_CURRENCY = ''$''
    NLS_NUMERIC_CHARACTERS = '',.''
    ') FROM DUAL;

SELECT TO_NUMBER('-$100','L9G999D99',
   ' NLS_NUMERIC_CHARACTERS = '',.''
     NLS_CURRENCY            = ''$''
   ') "Amount"
     FROM DUAL;


select to_number('$0897', '$9999') from dual;

SELECT TO_NUMBER('7873.83939') FROM DUAL;
-- WITH A SPECIFIC FORMAT, KNOWING THE VALUE EXACTLY
SELECT TO_NUMBER('78987.789', '99999.999') FROM DUAL;

SELECT TO_NUMBER('#787,898.34', 'L999G999D99', 'NLS_CURRENCY= ''#'' ') FROM DUAL;

SELECT TO_NUMBER('787-898.34' DEFAULT 0 ON CONVERSION ERROR, '999G999D99', ' NLS_NUMERIC_CHARACTERS = ''-.'' ' ) FROM DUAL;

SELECT TO_NUMBER('787,898.34', '999G999D99' ) FROM DUAL;

SELECT TO_NUMBER('2,00' DEFAULT 0 ON CONVERSION ERROR) "Value"
  FROM DUAL;

SELECT TO_NUMBER('DXV', 'RN') FROM DUAL;


SELECT TO_NUMBER('DXV', 'RN') FROM DUAL; -- Result: 515
SELECT TO_NUMBER('MCMLXXXIV', 'RN') FROM DUAL; -- Result: 1984

SELECT TO_DATE('017-03-21', 'YYY-MM-DD') FROM DUAL;

SELECT TO_TIMESTAMP('21-MAR-20 12:04:30') FROM DUAL;
SELECT TO_TIMESTAMP('2020-03-21 12:04:30:839200', 'RRRR-MM-DD HH24:MI:SS:FF') FROM DUAL;
SELECT TO_TIMESTAMP_TZ('21-MAR-20 12:04:30 EAT') FROM DUAL;

SELECT TO_TIMESTAMP_TZ('2020-03-21 12:04:30:839200', 'RRRR-MM-DD HH24:MI:SS:FF') FROM DUAL;

SELECT TO_TIMESTAMP('2021-03-20 12:04:30', 'RRRR-MM-DD HH24:MI:SS') FROM DUAL;


SELECT TO_YMINTERVAL('-02-3') AS EVENT_TIME FROM DUAL;
SELECT TO_DSINTERVAL('40 21:23:30') AS EVENT_TIME FROM DUAL;
SELECT TO_DSINTERVAL('0 21:23:00') AS EVENT_TIME FROM DUAL;


SELECT NUMTOYMINTERVAL(24.4,'YEAR') AS EVENT_TIME FROM DUAL;
SELECT NUMTOYMINTERVAL(24,'month') AS EVENT_TIME FROM DUAL;


SELECT NUMTODSINTERVAL(245000, 'SECOND') AS EVENT_TIME FROM DUAL;

SELECT CAST('19-JAN-16 11:35:00' AS TIMESTAMP WITH LOCAL TIME ZONE) FROM DUAL;


SELECT CAST(TO_TIMESTAMP('19-JAN-16 11:35:00') AS TIMESTAMP WITH LOCAL TIME ZONE) FROM DUAL;

SELECT case 5
      when 5 then 'Hello'
      when 6 then 'World'
      else 'Unknown'
      end
    FROM DUAL;
    
    
SELECT case
      when 4 <= 5 then 'Hello'
      when 6 <= 5 then 'World'
      else 'Unknown'
      end
    FROM DUAL;


SELECT DECODE(5, 5, 'GREATER', 'UNKNOWN') FROM DUAL;
SELECT DECODE(4, 8, 'eIGHT', 3, 'tHREE', 'NOT MENTIONED') FROM DUAL;

SELECT
  DECODE(NULL,NULL,'Equal','Not equal')
FROM
  dual;
  

SELECT NVL(100, 200) FROM DUAL;

SELECT NVL(NULL,200) FROM DUAL;
SELECT NVL(EXTRACT(YEAR FROM SYSDATE), 2018) FROM DUAL;
SELECT EXTRACT(YEAR FROM SYSDATE) FROM DUAL;

SELECT NVL2(NULL, 890, 230) FROM DUAL;
SELECT NVL2(1, 890, 230) FROM DUAL;

SELECT COALESCE(NULL, 0), COALESCE(34, 0), COALESCE(NULL, NULL) FROM DUAL;

SELECT NULLIF(20, 44) from dual;

select nullif(NULL, NULL) FROM DUAL;

select TO_NUMBER('2E6', 'EEEE9E9') FROM DUAL;
SELECT TRANSLATE('1.47654345670000000000 E010', '1 ', '1') FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'MON DAY') FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'DL') FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'DS') FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'TS') FROM DUAL;


SELECT TO_CHAR(SYSDATE, 'DL') FROM DUAL;

-- REPORTING DATA USING GROUP FUNCTIONS
select * from ships;
SELECT COUNT(*) FROM SHIPS;
select sum(nvl(null,20)) from dual;

SELECT COUNT(DISTINCT WINDOW), COUNT(ALL WINDOW) FROM SHIPS;
select * from aggr;
create table aggr(id numeric, items numeric);

insert into aggr (id) values (3);

select * from aggr;
select sum(items) from aggr;


select avg(items) from aggr;
select avg(nvl(items, 0)) from aggr;
select median(items) from aggr;

select * from ships;
SELECT MIN(SQR_FT) FROM SHIPS;
select id, rank() over (partition by window order by sqr_ft),rank() over (order by sqr_ft) from ships;
SELECT RANK(533) WITHIN GROUP (ORDER BY SQR_FT) FROM SHIPS;


SELECT sqr_ft, DENSE_RANK() OVER (ORDER BY SQR_FT) FROM SHIPS;
SELECT DENSE_RANK() OVER (PARTITION BY WINDOW ORDER BY SQR_FT) FROM SHIPS;

SELECT DENSE_RANK(200) WITHIN GROUP(ORDER BY SQR_FT) FROM SHIPS;

SELECT DENSE_RANK(500) WITHIN GROUP(ORDER BY SQR_FT) FROM SHIPS;

SELECT DENSE_RANK(1) WITHIN GROUP(ORDER BY SQR_FT) FROM SHIPS;

SELECT LEAST(SQR_FT), GREATEST(SQR_FT) FROM SHIPS;

select least(1,2,3) from dual;
select greatest(1,2,8,-100) from dual;


SELECT MAX(SQR_FT) keep (DENSE_RANK FIRST ORDER BY sqr_ft desc) OVER (PARTITION BY sqr_ft) from ships;
SELECT MAX(SQR_FT) KEEP (DENSE_RANK LAST ORDER BY SQR_FT) FROM SHIPS;



select window, avg(sqr_ft), count(*) from ships where id > 2 group by window;

SELECT AVG(MAX(SQR_FT)) FROM SHIPS GROUP BY WINDOW;

SELECT WINDOW, AVG(SQR_FT) FROM SHIPS GROUP BY WINDOW HAVING AVG(SQR_FT) <> 500 AND LOWER(WINDOW) IN ('none') ;
SELECT WINDOW, COUNT(*) FROM SHIPS GROUP BY ROLLUP(WINDOW);

SELECT WINDOW, COUNT(*), grouping (window)  FROM SHIPS GROUP BY cube(WINDOW);
SELECT WINDOW, COUNT(*), GROUPING_ID(WINDOW), GROUP_ID() FROM SHIPS GROUP BY ROLLUP(WINDOW);

select window, count(*), group_id() from ships group by rollup(window);


select to_number("100,000") from dual;

select rank('Hello') within group (order by sqr_ft) from ships;

select * from ports;

ALTER table ships rename to ships_cabins;

select * from ships_cabins;
alter table ships_cabins rename to ship_cabins;


insert into ports(port_id, port_name) values (1,'Baltimore');
insert into ports(port_id, port_name) values (2,'Charleston');
insert into ports(port_id, port_name) values (3,'Tampa');
insert into ports(port_id, port_name) values (4,'Miami');

select * from ports;

create table ships(ship_id numeric(3,0) primary key,
ship_name varchar2(30),
home_port numeric,
constraint fk_ships_port foreign key (home_port) references ports (port_id));

insert into ships(ship_id, ship_name, home_port) values (1, 'Coddy Crystal', 1);
insert into ships(ship_id, ship_name, home_port) values (2, 'Coddy Elegance', 3);
insert into ships(ship_id, ship_name, home_port) values (3, 'Coddy Champion', null);
insert into ships(ship_id, ship_name, home_port) values (4, 'Coddy Victorius', 3);
insert into ships(ship_id, ship_name, home_port) values (5, 'Coddy Grandeur', 2);
insert into ships(ship_id, ship_name, home_port) values (6, 'Coddy Prince', 2);

describe ships;
select * from ships;
select * from ports;


SELECT ship_id, ship_name, port_name
FROM ships INNER JOIN ports
ON home_port = port_id
ORDER BY ship_id;

SELECT ship_id, ship_name, port_name, port_id
FROM ships INNER JOIN ports
ON home_port = port_id
WHERE port_id > 2
ORDER BY ship_id;


SELECT ship_id, ship_name, port_name
FROM ships JOIN ports
ON home_port = port_id
ORDER BY ship_id;

SELECT s.ship_id, s.ship_name, p.port_name
FROM ships s, ports p
WHERE s.home_port = p.port_id;


select * from employees;
select * from departments;

SELECT * FROM ADDRESSES;

SELECT EMPLOYEE_ID, LAST_NAME, STREET_ADDRESS
FROM EMPLOYEES NATURAL JOIN ADDRESSES;

SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DEPARTMENT_NAME
FROM EMPLOYEES NATURAL LEFT OUTER JOIN DEPARTMENTS;

SELECT EMPLOYEE_ID, FIRST_NAME, DEPARTMENT_NAME, STREET_ADDRESS
FROM EMPLOYEES NATURAL FULL OUTER JOIN DEPARTMENTS
NATURAL FULL OUTER JOIN ADDRESSES ORDER BY DEPARTMENT_NAME;




SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DEPARTMENT_NAME
FROM EMPLOYEES JOIN DEPARTMENTS USING (DEPARTMENT_ID);

SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DEPARTMENT_NAME
FROM EMPLOYEES LEFT JOIN DEPARTMENTS USING (DEPARTMENT_ID);

SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DEPARTMENT_NAME 
FROM EMPLOYEES LEFT OUTER JOIN DEPARTMENTS USING (DEPARTMENT_ID);

SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, STREET_ADDRESS
FROM EMPLOYEES LEFT OUTER JOIN ADDRESSES USING (EMPLOYEE_ID);

SELECT * FROM ADDRESSES;

SELECT * FROM USER_TABLES;
SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;
SELECT * FROM LOCATIONS;


SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.EMAIL, L.STREET_ADDRESS, D.DEPARTMENT_NAME
FROM EMPLOYEES E JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID;


create table scores(score_id numeric primary key, test_score numeric not null);
insert into scores values (1,95);
insert into scores values (2,55);
insert into scores values (3,83);
insert into scores values (4,23);

create table grades(grade_id numeric primary key, grade varchar2(1), score_min numeric, score_max numeric,
constraint ck_scoremin_max check(score_min < score_max));

insert into grades values(1, 'A', 90, 100);
insert into grades values(2, 'B', 80, 89);
insert into grades values(3, 'C', 70, 79);
insert into grades values(4, 'D', 60, 69);
insert into grades values(5, 'E', 50, 59);

SELECT S.SCORE_ID, S.TEST_SCORE, G.GRADE
FROM SCORES S left JOIN GRADES G ON
S.TEST_SCORE BETWEEN G.SCORE_MIN AND G.SCORE_MAX;

SELECT E.FIRST_NAME || ' ' || E.LAST_NAME AS EMPL_NAME, M.FIRST_NAME, M.FIRST_NAME || ' ' || M.LAST_NAME AS MANAGER_NAME
FROM EMPLOYEES E JOIN EMPLOYEES M ON E.MANAGER_ID = M.EMPLOYEE_ID;

SELECT E.FIRST_NAME || ' ' || E.LAST_NAME AS EMPL_NAME, M.FIRST_NAME, M.FIRST_NAME || ' ' || M.LAST_NAME AS MANAGER_NAME
FROM EMPLOYEES E JOIN EMPLOYEES M ON E.MANAGER_ID = M.EMPLOYEE_ID;

SELECT E.FIRST_NAME || ' ' || E.LAST_NAME AS EMPL_NAME, M.FIRST_NAME, M.FIRST_NAME || ' ' || M.LAST_NAME AS MANAGER_NAME
FROM EMPLOYEES E LEFT JOIN EMPLOYEES M ON E.MANAGER_ID = M.EMPLOYEE_ID;

SELECT E.FIRST_NAME || ' ' || E.LAST_NAME AS EMPL_NAME, M.FIRST_NAME, M.FIRST_NAME || ' ' || M.LAST_NAME AS MANAGER_NAME
FROM EMPLOYEES E RIGHT JOIN EMPLOYEES M ON E.MANAGER_ID = M.EMPLOYEE_ID;

SELECT E.EMAIL, E.FIRST_NAME || ' ' || E.LAST_NAME AS EMPL_NAME, M.FIRST_NAME, M.FIRST_NAME || ' ' || M.LAST_NAME AS MANAGER_NAME
FROM EMPLOYEES E FULL OUTER JOIN EMPLOYEES M ON E.MANAGER_ID = M.EMPLOYEE_ID ORDER BY E.FIRST_NAME;

select * from ports;
select * from ships;

select ship_name, ship_id, port_name
from ships, ports
where home_port = port_id(+);


select ship_name, ship_id, port_name
from ships, ports
where home_port(+) = port_id;


SELECT ROUND(AVG(SQR_FT), 1) FROM SHIP_CABINS;
SELECT * FROM SHIP_CABINS WHERE SQR_FT >= (SELECT ROUND(AVG(SQR_FT), 1) FROM SHIP_CABINS);

SELECT * FROM SHIP_CABINS WHERE SQR_FT < (SELECT ROUND(AVG(SQR_FT), 1) FROM SHIP_CABINS);

SELECT A.ID, A.ROOM, A.WINDOW, A.SQR_FT
FROM SHIP_CABINS A
WHERE A.SQR_FT > (SELECT AVG(SQR_FT) FROM SHIP_CABINS WHERE WINDOW =A.WINDOW)
ORDER BY A.ROOM;

SELECT A.ID, A.WINDOW, A.SQR_FT
FROM SHIP_CABINS A
WHERE A.SQR_FT < (SELECT AVG(SQR_FT) FROM SHIP_CABINS WHERE WINDOW = A.WINDOW);

SELECT WINDOW, AVG(SQR_FT) 
FROM SHIP_CABINS
GROUP BY WINDOW;


SELECT TO_CHAR(SYSDATE, 'RRRR Q') FROM DUAL;

select sqr_ft, (select count(*) from ships) from ship_cabins;

select * from ship_cabins;

delete ship_cabins s1 where sqr_ft = (select min(sqr_ft) from ship_cabins s2 where s1.window = s2.window);

rollback;

select * from ports;

select * from ships;

select * from ports p where exists (select * from ships s where s.home_port = p.port_id);


with dense_table as ( select * from ship_cabins s where sqr_ft > (select avg(sqr_ft) from ship_cabins where s.window = window) )
select * from dense_table d full join ports p on p.port_id =d.id;
    
CREATE TABLE PARENT(ID NUMBER, HOUSE VARCHAR2(30));

INSERT INTO PARENT VALUES (1, 'Oak');
INSERT INTO PARENT VALUES (2, 'Elm');

CREATE TABLE KID(ID NUMBER, HOUSE VARCHAR2(30));

INSERT INTO KID VALUES (10, 'Marple');

INSERT INTO KID VALUES (20, 'Elm');

select * from parent where house in (select house from kid);

select * from parent where house not in (select house from kid);

insert into kid values (30, null);

select * from parent where house not in (select house from kid where house is not null);

select * from family where id < any (select 20 from dual);


select * from family where id < any (select ID from KID);


select * from family where id < ALL (select ID from KID);


select * from family where id < SOME (select ID from KID);

SELECT * FROM FAMILY F WHERE EXISTS (SELECT ID FROM KID WHERE ID = F.ID);


create table family as select * from parent union select * from kid;

select * from family;

select * from recyclebin;

select * from user_recyclebin;

create table meeting_attendees (  
  attendee_id integer  
    not null,  
  start_date date  
    not null,  
  end_date date,  
  primary key (   
    attendee_id, start_date  
  )  
);

alter session set nls_date_format = '  DD Mon YYYY HH24:MI  ';

select * from meeting_attendees order by start_date, end_date;

select * from user_views;

select * from employees;
select * from departments;

create view vw_employees as 
    select employee_id, 
    first_name || ' ' || last_name as Full_Name,
    hire_date as Hired_on,
    department_name as Department
    from employees natural join departments;
    
select * from vw_employees;
select * from vw_employees order by full_name;

select department, count(*) from vw_employees group by department;

desc vw_employees;

select * from family;

delete from family where id = 1;

select * from family;

select * from kid;

select * from parent;

commit;

update family set House = 'Mwananyamala' where house is null;

select * from family;

select * from parent;

select * from kid;

create view vw_kid as select * from kid;

select * from vw_kid;

update vw_kid set House = 'Mwananyamala' where house is null;

select * from kid;

commit;


insert into vw_kid values (40, 'Kemmie');

select * from vw_kid;

select * from family;

select * from employees;

select max(employee_id) from employees;

create or replace view emp_phone_book as
select employee_id, last_name || ', '||  first_name as full_name, phone_number from employees;

insert into emp_phone_book (employee_id, phone_number) values (207, '590.423.7890');


delete emp_phone_book where employee_id = 206;

select * from invoices;

select rownum, id, house, num from (select id, house, rownum as num from kid order by id);

insert into kid values (50, 'Amina');


ALTER VIEW emp_phone_book COMPILE;
DESC FAMILY;
CREATE TABLE ship_admins(
    ID NUMBER PRIMARY KEY,
    SHIP_ID NUMBER,
    CONSTRUCTION_COST NUMBER(14,2) INVISIBLE
);

DESC ship_admins;

SET COLINVISIBLE ON;
DESC ship_admins;
select * from ship_admins;
select id, ship_id, construction_cost from ship_admins;
SET COLINVISIBLE ON; --RESTORE THE VALUE
insert into ship_admins values (1, 3, 678000.00); -- too many values error
insert into ship_admins(id, ship_id, construction_cost) values (1, 3, 678000.00);
select * from ship_admins;
select id, ship_id, construction_cost from ship_admins;
commit;

select * from (select id, construction_cost from ship_admins);

CREATE SEQUENCE my_easy_seq;

select my_easy_seq.currval from dual; -- the sequence is not yet defined

select my_easy_seq.nextval from dual; -- sequence initialized and called

select my_easy_seq.currval from dual;

drop sequence my_easy_seq;

create sequence my_easy_seq start with 20 maxvalue 200 increment by 10 cycle;

select my_easy_seq.nextval from dual;
select my_easy_seq.currval, my_easy_seq.nextval from dual;
select my_easy_seq.currval from dual;

select my_easy_seq.nextval from dual;

select * from kid;

insert into kid values (my_easy_seq.nextval, 'Machosa');




drop table kid;

flashback table kid to before drop;

select * from kid;


select * from recyclebin;

select * from dba_recyclebin;


select * from kid;

delete kid where house = 'Kemmie';

commit;
alter table kid enable row movement;

flashback table kid to timestamp systimestamp - interval '0 00:10:00' day to second;

select * from kid;

SELECT DBMS_FLASHBACK.GET_SYSTEM_CHANGE_NUMBER FROM DUAL;

SELECT DBMS_FLASHBACK.GET_SYSTEM_CHANGE_NUMBER FROM DUAL;

SELECT CURRENT_SCN FROM V$DATABASE;
SELECT CURRENT_SCN FROM V$DATABASE;


SELECT ORA_ROWSCN, ID, HOUSE FROM KID;


SELECT ORA_ROWSCN, ID, HOUSE FROM KID;




SELECT SCN_TO_TIMESTAMP(15600076) FROM DUAL;

create restore point before_truncate;

select dbms_flashback.get_system_change_number from dual;

-- 15770581
truncate table kid;

select * from kid;

flashback table kid to scn 15770581;

flashback table kid to timestamp systimestamp - interval '0 00:05:00' day to second;


flashback table kid to timestamp systimestamp - interval '0 00:10:00' day to second;


select count(*) from kid as of timestamp systimestamp - interval '0 01:00:00' day to second;

select ora_rowscn from family;

drop table kid;

alter view family compile;

alter view vw_kid compile;

select * from family;

select * from user_views;

select * from user_tables order by table_name;

select * from vw_kid;

EXEC DBMS_STATS.gather_table_stats(USER, 'parent', cascade => TRUE);

drop table parent;

purge recyclebin;

flashback table parent to before drop;


create sequence my_demo_seq start with 20 maxvalue 100 increment by 80 nocycle cache 4;

drop  sequence my_demo_seq;

alter view vw_kid compile;

select * from vw_kid;

create table kid (id numeric, house varchar2(30)) enable row movement;
drop table kid;

select * from parent;

create table kid as select * from family;

delete from family where id = 20;

commit;

select * from kid union select * from family;

select * from kid minus select * from family;

select * from kid intersect select * from family;

select * from kid union all select * from family;

select * from kid union all select id * 20, house from family order by 1;


select id, house from kid union all select id * 20 as id, house from family order by id ;

select id, house from kid union all select id, house from family order by id;

insert into kid values (1, 'Elm');
select * from kid;

select * from family;

select (select house from family where id = 2) from ship_cabins;

select house from kid union select house from family;

select a.id, b.id from kid A full outer join (select id from family) B on a.id = b.id;

select id, house from (select id, house from kid union all select id as my_id, house as unknown_coumn from family);

select * from dictionary;
select count(*) from dictionary;
select * from user_tables;
select * from user_external_tables;
select table_name, owner from all_tables;



select * from all_directories;

SELECT * FROM USER_COMMENTS;

SELECT * FROM KID;

COMMENT ON TABLE KID IS 'tHE PARENTTS TABLE';
SELECT * FROM USER_TAB_COMMENTS;

select * from user_tab_comments where table_name ='KID';

COMMENT ON TABLE KID IS '';


SELECT * FROM DICTIONARY;


SELECT COUNT(*) FROM DICTIONARY;


SELECT COLUMN_NAME, DECODE(
    DATA_TYPE,
    'DATE', DATA_TYPE,
    'NUMBER', DATA_TYPE || DECODE(DATA_SCALE,
        NULL, NULL,
        '(' || DATA_PRECISION || ', ' || DATA_SCALE || ')'
        ),
    'VARCHAR2', DATA_TYPE || '(' || DATA_LENGTH || ')', NULL
    ) DATA_TYPE
    FROM USER_TAB_COLUMNS
    WHERE TABLE_NAME = 'INVOICES' OR TABLE_NAME = 'KID';


SELECT STATUS, OBJECT_TYPE, OBJECT_NAME
FROM USER_OBJECTS
WHERE STATUS = 'INVALID'
ORDER BY OBJECT_NAME;

SELECT * FROM USER_VIEWS;

SELECT TEXT FROM USER_VIEWS;

SELECT * FROM USER_SYS_PRIVS;

SELECT * FROM USER_TAB_PRIVS;

SELECT * FROM USER_ROLE_PRIVS;
SELECT * FROM ROLE_TAB_PRIVS;

SELECT * FROM SESSION_PRIVS;

SELECT * FROM USER_CONSTRAINTS;

SELECT * FROM V$TIMEZONE_NAMES;

SELECT * FROM V$OBJECT_USAGE;

select * from user_role_privs;


select * from user_constraints where search_condition is not null;

select * from user_triggers;

select table_name, comments from dictionary where table_name like 'ALL%' or table_name like 'USER%';

drop table kids_ext;

create table kids_ext (id char(50), name char(50))
organization external(
type oracle_loader
default directory book_files 
access parameters(
    records delimited by newline
    fields terminated by '	' (
    id char(50),
    name char(50)
    )
)
location ('kids.txt')
);


    
select * from kids_ext;

select * from family;

select * from kid;

insert all into kid (id, house) values (to_number(id), trim(name))
            into family (id, house) values (to_number(id), trim(name))
        select id, name from kids_ext;
        

select * from family;

select rpad(to_char(id), 10) || lpad(house, 30) as summary from kid;


rollback;

select * from family;

select * from kid;
-- here we define our condition then we use it below for a conditional insert
select decode(mod(to_number(id), 2), 0, 'Even', 1, 'Odd', null) from kids_ext;

select * from user_sequences;

select departments_seq.nextval from dual;

insert all into kid (id, house) values (to_number(id), trim(name))
            into family (id, house) values (to_number(id), trim(name))
        select departments_seq.nextval, name from kids_ext;
        
select departments_seq.currval from dual;

-- now multitable insert with conditions

INSERT FIRST
    WHEN  rem = 0  THEN
        INTO kid (id, house) values (id, clean_name)
    WHEN  rem = 1  THEN
        INTO family (id, house) values (id, clean_name)
    select mod(to_number(id), 2) rem, to_number(id) id, trim(name) clean_name  from kids_ext;
    
INSERT ALL
    WHEN  rem = 0  THEN
        INTO kid (id, house) values (id * 2, clean_name || to_char(id))
    WHEN  rem = 1  THEN
        INTO family (id, house) values (id * 2, clean_name || to_char(id))
    select mod(to_number(id), 2) rem, to_number(id) id, trim(name) clean_name  from kids_ext;

select * from kid;

select * from family;


create table region_sales(prod_id varchar2(20), apac number, canada number, euro number, us number);

insert into region_sales values ('PROD1', 100,200,300,400);


insert into region_sales values ('PROD2', 500,600,700,800);
alter table kid add home varchar2(25);

select * from (select * from region_sales) unpivot (sales_amount for cols_name in (apac, euro, us, canada)) order by 1,2;

select * from kid;
update kid set home = 'Makambako';
select * from (select * from kid) unpivot (col_value for cols_value in (house, home)) order by 2;


CREATE TABLE SHIP_CABIN_STATISTICS (
    SC_ID NUMBER(7),
    ROOM_TYPE VARCHAR2(20),
    WINDOW_TYPE VARCHAR2(10),
    SQ_FT NUMBER(8)
);

create table SHIP_CABIN_GRID(
    ROOM_TYPE VARCHAR2(20),
    OCEAN NUMERIC(8),
    BALCONY  NUMERIC(8),
    NO_WINDOW  NUMERIC(8)
);

INSERT INTO SHIP_CABIN_GRID VALUES ('ROYAL', 1745,1635, NULL);
INSERT INTO SHIP_CABIN_GRID VALUES ('SKYLOFT', 722,722, NULL);
INSERT INTO SHIP_CABIN_GRID VALUES ('PRESIDENTIAL', 1142,1142, 1142);
INSERT INTO SHIP_CABIN_GRID VALUES ('LARGE', 225,NULL, 211);
INSERT INTO SHIP_CABIN_GRID VALUES ('STANDARD', 217,554, 586);

SELECT * FROM SHIP_CABIN_GRID;

COMMIT;


INSERT ALL
    WHEN OCEAN IS NOT NULL THEN 
        INTO SHIP_CABIN_STATISTICS (ROOM_TYPE, WINDOW_TYPE, SQ_FT) VALUES (ROOM_TYPE, 'OCEAN', OCEAN)
    WHEN BALCONY IS NOT NULL THEN 
        INTO SHIP_CABIN_STATISTICS (ROOM_TYPE, WINDOW_TYPE, SQ_FT) VALUES (ROOM_TYPE, 'BALCONY',BALCONY)
    WHEN NO_WINDOW IS NOT NULL THEN 
        INTO SHIP_CABIN_STATISTICS (ROOM_TYPE, WINDOW_TYPE, SQ_FT) VALUES (ROOM_TYPE, 'NO_WINDOW', NO_WINDOW)
    SELECT ROOM_TYPE, OCEAN, BALCONY, NO_WINDOW FROM SHIP_CABIN_GRID;
    
SELECT * FROM SHIP_CABIN_STATISTICS ORDER BY 2;

select * from SHIP_CABIN_GRID;

select * from (select * from SHIP_CABIN_GRID) unpivot (col_value for cols_value in (OCEAN, NO_WINDOW, BALCONY)) order by 2;


CREATE TABLE TARGET_TB (ID NUMERIC, AMOUNT NUMERIC(5));

CREATE TABLE SOURCE_TB (ID NUMERIC, AMOUNT NUMERIC(5));

INSERT INTO SOURCE_TB(ID, AMOUNT) VALUES (12345, 250);
INSERT INTO SOURCE_TB(ID, AMOUNT) VALUES (67890, 100);
INSERT INTO SOURCE_TB(ID, AMOUNT) VALUES (87765, -500);

INSERT INTO SOURCE_TB(ID, AMOUNT) VALUES (54321, 1000);


INSERT INTO SOURCE_TB(ID, AMOUNT) VALUES (99999, 900);

INSERT INTO TARGET_TB(ID, AMOUNT) VALUES (12345, 1250);


INSERT INTO TARGET_TB(ID, AMOUNT) VALUES (67890, 800);


INSERT INTO TARGET_TB(ID, AMOUNT) VALUES (98765, 750);

INSERT INTO TARGET_TB(ID, AMOUNT) VALUES (54321, 1500);

SELECT * FROM SOURCE_TB;
SELECT * FROM TARGET_TB;

COMMIT;

-- PERFORM THE MERGE NOW 

SELECT * FROM SOURCE_TB FULL OUTER JOIN TARGET_TB ON SOURCE_TB.ID = TARGET_TB.ID;



MERGE INTO TARGET_TB TT 
USING SOURCE_TB AS SS
ON (TT.ID = SS.ID)
WHEN MATCHED THEN DELETE
WHEN MATCHED THEN UPDATE TARGET_TB SET TT.AMOUNT = TT.AMOUNT + SS.AMOUNT
WHEN NOT MATCHED THEN INSERT (ID, AMOUNT) VALUES (SS.ID, SS.AMOUNT);


MERGE INTO TARGET_TB TT 
USING SOURCE_TB SS
ON (TT.ID = SS.ID)
WHEN MATCHED THEN 
    UPDATE SET TT.AMOUNT = TT.AMOUNT + SS.AMOUNT
    DELETE WHERE (SS.AMOUNT < 0)
WHEN NOT MATCHED THEN 
    INSERT (ID, AMOUNT) VALUES (SS.ID, SS.AMOUNT);

SELECT * FROM SOURCE_TB;

SELECT * FROM TARGET_TB;

ROLLBACK;

select * from kid;
SELECT * FROM FAMILY;
DESC KID;

ALTER TABLE FAMILY ADD HOME VARCHAR(25);


select * from family;

MERGE INTO FAMILY FA
    USING KID KD
    ON(FA.ID = KD.ID)
    WHEN MATCHED THEN UPDATE SET HOME = KD.HOME
    WHEN NOT MATCHED THEN INSERT (FA.ID, FA.HOUSE, FA.HOME) VALUES (KD.ID, KD.HOUSE, KD.HOME)
    WHERE 1 = 1;

MERGE INTO FAMILY FA
    USING KID KD
    ON(FA.ID = KD.ID)
    WHEN MATCHED THEN UPDATE SET HOME = KD.HOME where kd.id > 20
    WHEN NOT MATCHED THEN INSERT (FA.ID, FA.HOUSE, FA.HOME) VALUES (KD.ID, KD.HOUSE, KD.HOME)
    WHERE KD.ID > 10;
    
explain plan for MERGE INTO FAMILY FA
    USING KID KD
    ON(FA.ID = KD.ID)
    WHEN MATCHED THEN UPDATE SET HOME = KD.HOME where kd.id > 20
    WHEN NOT MATCHED THEN INSERT (FA.ID, FA.HOUSE, FA.HOME) VALUES (KD.ID, KD.HOUSE, KD.HOME)
    WHERE KD.ID > 10;
    
select * from table(dbms_xplan.display);

show user;
select * FROM SESSION_ROLES;
SELECT * FROM ROLE_ROLE_PRIVS;

SELECT * FROM ROLE_TAB_PRIVS;

SELECT * FROM ROLE_SYS_PRIVS;

select * from user_col_privs;

select * from session_roles;

select * from role_tab_privs;

SHOW PARAMETERS;

select * from kid;

alter table kid modify home invisible;

alter table kid modify home visible;


select * from kid;

update kid set home = null where id < 20;

rollback;


select * from kid order by home;

select house, id, home from kid order by 1;

select distinct house, home from kid;


SELECT EMPLOYEE_ID, LAST_NAME, MANAGER_ID, LEVEL FROM EMPLOYEES CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID;


create table my_invisible(id number, name varchar2(20), class char, dob date);

alter table my_invisible modify id invisible;
alter table my_invisible set unused (dob);

alter table my_invisible set unused column id;

alter table my_invisible drop unused columns;

select * from my_invisible;

select round(mod(25,3), -1) from dual;
select trunc(mod(25,3), -1) from dual;
select remainder(26,3)from dual;
select mod(26,3)from dual;
alter table my_invisible set unused column name;

select * from my_invisible;

drop table my_invisible;
SELECT SYSDATE - DATE '2019-01-01' - 1 FROM DUAL;

SELECT SYSDATE - 1 FROM DUAL;

create view my_dump_view as select * from non_existent;


CREATE TABLE DATE_TEST (DOB DATE DEFAULT SYSDATE);

DESC DATE_TEST;

select current_date from dual;

select current_timestamp from dual;

select localtimestamp + interval '2' YEAR from dual;

SELECT HOUSE HOME FROM KID;

select * from user_sequences;

create table sequence_trial (id number(5) default my_demo_seq.nextval primary key, name varchar2(30));

insert into sequence_trial(name) values ('Victoria');

insert into sequence_trial(name) values ('Machuche');
alter sequence my_demo_seq nomaxvalue;
insert into sequence_trial(name) values ('Witty');

select * from sequence_trial;

select to_date(sysdate, 'DD-MON-RR') from dual;

select cast('12-March-19' as date) from dual;



select coalesce(null, null, 7) coalesced, nvl(null,4) nvled from dual;

select decode(remainder(5,3), 1, 'It is', 'Not') from dual;


select to_char(localtimestamp, 'DD-MON-YYYY HH24:MI:SS') from dual;


select to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS TZR') from dual;


select to_char(cast(SYSDATE as timestamp) at time zone 'US/Eastern', 'DD RR MON HH24:MI:SS') from dual;





