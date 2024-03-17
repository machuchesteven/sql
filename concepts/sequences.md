# Sequences in Sql

```SQL
CREATE SEQUENCE _sseq_name_
START WITH _start_number_ [default: 1]
INCREMENT BY _increment_value_ [default:1]
MINVALUE _min_value_ [default:NOMINVALUE]
MAXVALUE _max_value_ [default:NOMAXVALUE]
CYCLE [default NOCYCLE] --keyword to see if the sequence should loop repeatedly
CACHE [default - 20 | NOCACHE] --keyword to see if

```

`NETVAL` and `CURRVAL` are preudocolumns holding the next and current value of the sequence
examples of sequences in Sql

```sql
CREATE SEQUENCE my_name;

create sequence my_name_limited
minvalue 1
maxvalue 5
nocycle;

-- below, the number to cache must be less than one cycle ie you
-- cant cache by 20 default while the cycle does not do 20 times
-- before the next cace
create sequence my_name_cycle
minvalue 5
maxvalue 10000
increment by 35
cycle;

-- everytime called it increment the values, and return the next
SELECT my_name.nextval from dual;

SELECT my_name.currval from dual;

```

Tips on creating sequences :-
