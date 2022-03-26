# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

вывода списка БД

```bash
root@90556b82d0b6:/# psql -l -U admin2
                                List of databases
     Name      | Owner  | Encoding |  Collate   |   Ctype    | Access privileges
---------------+--------+----------+------------+------------+-------------------
 postgres      | admin2 | UTF8     | en_US.utf8 | en_US.utf8 |
 template0     | admin2 | UTF8     | en_US.utf8 | en_US.utf8 | =c/admin2        +
               |        |          |            |            | admin2=CTc/admin2
 template1     | admin2 | UTF8     | en_US.utf8 | en_US.utf8 | =c/admin2        +
               |        |          |            |            | admin2=CTc/admin2
 test_database | admin2 | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)
```

подключения к БД

```bash
root@90556b82d0b6:/# psql -U admin2 -W -d test_database 
Password: 
psql (13.6 (Debian 13.6-1.pgdg110+1))
Type "help" for help.

test_database=#
```

вывода списка таблиц

```bash
test_database=# \dt+
                          List of relations
 Schema | Name | Type  | Owner  | Persistence |  Size   | Description
--------+------+-------+--------+-------------+---------+-------------
 public | test | table | admin2 | permanent   | 0 bytes |
(1 row)

```

вывода описания содержимого таблиц

```bash
test_database-# \d+ test
                                       Table "public.test"
 Column |     Type      | Collation | Nullable | Default | Storage  | Stats target | Description
--------+---------------+-----------+----------+---------+----------+--------------+-------------
 nomer  | integer       |           |          |         | plain    |              |
 name   | character(20) |           |          |         | extended |              |
Access method: heap
```

выхода из psql

```bash
test_database-# \q
root@90556b82d0b6:/#
```

## Задача 2

Создание БД

```bash
root@6f82253e09ec:/# psql -U admin2 postgres
psql (13.6 (Debian 13.6-1.pgdg110+1))
Type "help" for help.

postgres=# 
postgres=# create database test_database;
CREATE DATABASE
```

Восстановление БД

```bash
root@6f82253e09ec:/# psql -U admin2 test_database < /var/postgresql/backup/test_dump.sql
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ERROR:  role "postgres" does not exist
CREATE SEQUENCE
ERROR:  role "postgres" does not exist
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE
```

Сбор статистики по таблице.

```bash
test_database=# ANALYZE VERBOSE orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```

Наибольшее среднее значение размера элементов в байтах у столбца "title" = 16.

```bash
test_database=# select schemaname, tablename, attname, inherited, null_frac, avg_width, n_distinct, most_common_vals, most_common_freqs, correlation, most_common_elems, most_common_elem_freqs, elem_count_histogram from pg_stats where tablename='orders';
 schemaname | tablename | attname | inherited | null_frac | avg_width | n_distinct | most_common_vals | most_common_freqs | correlation | most_common_elems | most_common_elem_freqs | elem_count_histogram 
------------+-----------+---------+-----------+-----------+-----------+------------+------------------+-------------------+-------------+-------------------+------------------------+----------------------
 public     | orders    | id      | f         |         0 |         4 |         -1 |                  |                   |           1 |                   |                        |
 public     | orders    | title   | f         |         0 |        16 |         -1 |                  |                   |  -0.3809524 |                   |                        |
 public     | orders    | price   | f         |         0 |         4 |     -0.875 | {300}            | {0.25}            |   0.5952381 |                   |                        |
(3 rows)

```

## Задача 3

В качестве варианта масштабировная на этапе проектирования можно было использовать шардирование и настроить правила перенаправления из основной таблицы:

```bash
test_database=# start transaction;
START TRANSACTION
test_database=*# create table orders_1 (check (price > 499)) inherits (orders);
CREATE TABLE
test_database=*# create table orders_2 (check (price <= 499)) inherits (orders);
CREATE TABLE
test_database=*# savepoint my_point;
SAVEPOINT
test_database=*# create rule orders_insert_1 as on insert to orders where (price > 499) do instead insert into orders_1 values (new.*);
CREATE RULE
test_database=*# create rule orders_insert_2 as on insert to orders where (price <= 499) do instead insert into orders_2 values (new.*);
CREATE RULE
test_database=*# commit;
COMMIT
```

Для переноса информации из таблицы orders в orders_1 и orders_2 необходимо:

```bash
test_database=# start transaction;
START TRANSACTION
test_database=*# insert into orders_1 (title, price) select title, price from orders where "price" > '499';
INSERT 0 3
test_database=*# insert into orders_2 (title, price) select title, price from orders where "price" <= '499';
INSERT 0 5
test_database=*# select * from orders;
 id |        title         | price
----+----------------------+-------
  1 | War and peace        |   100
  2 | My little database   |   500
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  6 | WAL never lies       |   900
  7 | Me and my bash-pet   |   499
  8 | Dbiezdmin            |   501
 13 | My little database   |   500
 14 | WAL never lies       |   900
 15 | Dbiezdmin            |   501
 16 | War and peace        |   100
 17 | Adventure psql time  |   300
 18 | Server gravity falls |   300
 19 | Log gossips          |   123
 20 | Me and my bash-pet   |   499
(16 rows)

test_database=*# select * from orders_1;
 id |       title        | price 
----+--------------------+-------
 13 | My little database |   500
 14 | WAL never lies     |   900
 15 | Dbiezdmin          |   501
(3 rows)

test_database=*# select * from orders_2;
 id |        title         | price 
----+----------------------+-------
 16 | War and peace        |   100
 17 | Adventure psql time  |   300
 18 | Server gravity falls |   300
 19 | Log gossips          |   123
 20 | Me and my bash-pet   |   499
(5 rows)

test_database=*# SAVEPOINT my_sp;
SAVEPOINT

test_database=*# delete from only orders;
DELETE 8
test_database=*# select * from orders;
 id |        title         | price 
----+----------------------+-------
 13 | My little database   |   500
 14 | WAL never lies       |   900
 15 | Dbiezdmin            |   501
 16 | War and peace        |   100
 17 | Adventure psql time  |   300
 18 | Server gravity falls |   300
 19 | Log gossips          |   123
 20 | Me and my bash-pet   |   499
(8 rows)

test_database=*# commit;
COMMIT

test_database=# select * from orders;
 id |        title         | price
----+----------------------+-------
 13 | My little database   |   500
 14 | WAL never lies       |   900
 15 | Dbiezdmin            |   501
 16 | War and peace        |   100
 17 | Adventure psql time  |   300
 18 | Server gravity falls |   300
 19 | Log gossips          |   123
 20 | Me and my bash-pet   |   499
(8 rows)

```

## Задача 4

Для создания резервной копии используем команду:

```bash
root@6f82253e09ec:/# pg_dump -U admin2 test_database > /var/postgresql/backup/test_database.dump
```

Для добавления уникальности значения столбца title необходимо добавить параметр UNIQUE при создание.  

```bash 
title character varying(80) UNIQUE  NOT NULL,
```

```bash
--
-- PostgreSQL database dump
--

-- Dumped from database version 13.6 (Debian 13.6-1.pgdg110+1)
-- Dumped by pg_dump version 13.6 (Debian 13.6-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: orders; Type: TABLE; Schema: public; Owner: admin2
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) UNIQUE NOT NULL,
    price integer DEFAULT 0
);


ALTER TABLE public.orders OWNER TO admin2;

--
-- Name: orders_1; Type: TABLE; Schema: public; Owner: admin2
--

CREATE TABLE public.orders_1 (
    CONSTRAINT orders_1_price_check CHECK ((price > 499))
)
INHERITS (public.orders);


ALTER TABLE public.orders_1 OWNER TO admin2;

--
-- Name: orders_2; Type: TABLE; Schema: public; Owner: admin2
--

CREATE TABLE public.orders_2 (
    CONSTRAINT orders_2_price_check CHECK ((price <= 499))
)
INHERITS (public.orders);


ALTER TABLE public.orders_2 OWNER TO admin2;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: admin2
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_id_seq OWNER TO admin2;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin2
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: admin2
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: orders_1 id; Type: DEFAULT; Schema: public; Owner: admin2
--

ALTER TABLE ONLY public.orders_1 ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: orders_1 price; Type: DEFAULT; Schema: public; Owner: admin2
--

ALTER TABLE ONLY public.orders_1 ALTER COLUMN price SET DEFAULT 0;


--
-- Name: orders_2 id; Type: DEFAULT; Schema: public; Owner: admin2
--

ALTER TABLE ONLY public.orders_2 ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: orders_2 price; Type: DEFAULT; Schema: public; Owner: admin2
--

ALTER TABLE ONLY public.orders_2 ALTER COLUMN price SET DEFAULT 0;


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: admin2
--

COPY public.orders (id, title, price) FROM stdin;
\.


--
-- Data for Name: orders_1; Type: TABLE DATA; Schema: public; Owner: admin2
--

COPY public.orders_1 (id, title, price) FROM stdin;
13      My little database      500
14      WAL never lies  900
15      Dbiezdmin       501
\.


--
-- Data for Name: orders_2; Type: TABLE DATA; Schema: public; Owner: admin2
--

COPY public.orders_2 (id, title, price) FROM stdin;
16      War and peace   100
17      Adventure psql time     300
18      Server gravity falls    300
19      Log gossips     123
20      Me and my bash-pet      499
\.


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin2
--

SELECT pg_catalog.setval('public.orders_id_seq', 20, true);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: admin2
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
--
-- Name: orders orders_insert_1; Type: RULE; Schema: public; Owner: admin2
--

CREATE RULE orders_insert_1 AS
    ON INSERT TO public.orders
   WHERE (new.price > 499) DO INSTEAD  INSERT INTO public.orders_1 (id, title, price)
  VALUES (new.id, new.title, new.price);


--
-- Name: orders orders_insert_2; Type: RULE; Schema: public; Owner: admin2
--

CREATE RULE orders_insert_2 AS
    ON INSERT TO public.orders
   WHERE (new.price <= 499) DO INSTEAD  INSERT INTO public.orders_2 (id, title, price)
  VALUES (new.id, new.title, new.price);


--
-- PostgreSQL database dump complete
--
```
