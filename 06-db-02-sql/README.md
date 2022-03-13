# Домашнее задание к занятию "6.2. SQL"

## Задача 1

В: Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.
Приведите получившуюся команду или docker-compose манифест.

О: Создан docker-compose.yaml

```yaml
version: '3.1'
networks:
  monitoring:
    driver: bridge
volumes:
  db_PostgresSQL: {}
  db_backup_PostgresSQL: {}

services:
  postgreSQL:
    image: postgres:12.10
    container_name: PostgreSQL
    volumes:
      - db_PostgresSQL:/var/postgresql/db
      - db_backup_PostgresSQL:/var/postgresql/backup
    restart: always
    networks:
      - monitoring
    ports:
      - 5432:5432
    environment:
      POSTGRES_USER: adm
      POSTGRES_PASSWORD: Pw1
      POSTGRES_DB: tstdb
      PGDATA: /var/postgresql/db
```

## Задача 2

* итоговый список БД после выполнения пунктов выше

```bash
test_db=# \d+
                           List of relations
 Schema |      Name      |   Type   | Owner  |    Size    | Description
--------+----------------+----------+--------+------------+-------------
 public | clients        | table    | admin2 | 8192 bytes |
 public | clients_id_seq | sequence | admin2 | 8192 bytes |
 public | orders         | table    | admin2 | 8192 bytes |
 public | orders_id_seq  | sequence | admin2 | 8192 bytes |
(4 rows)
```

* описание таблиц (describe)

```bash
test_db=# \d+ clients
                                                             Table "public.clients"
      Column       |         Type          | Collation | Nullable |               Default               | Storage  | Stats target | Description
-------------------+-----------------------+-----------+----------+-------------------------------------+----------+--------------+-------------
 id                | integer               |           | not null | nextval('clients_id_seq'::regclass) | plain    |              |
 Їрьшыш            | character varying(40) |           | not null |                                     | extended |              |
 ёЄЁрэр яЁюцштрэш  | character varying(40) |           | not null |                                     | extended |              |
 чрърч             | integer               |           |          |                                     | plain    |              |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "clients_чрърч_fkey" FOREIGN KEY ("чрърч") REFERENCES orders(id)
Access method: heap

```

![image](https://user-images.githubusercontent.com/87389868/158032375-40300940-d058-4281-bc51-db0c5cdbd9e7.png)

```bash
test_db=# \d+ orders
                                                          Table "public.orders"
    Column    |         Type          | Collation | Nullable |              Default               | Storage  | Stats target | Description
--------------+-----------------------+-----------+----------+------------------------------------+----------+--------------+-------------
 id           | integer               |           | not null | nextval('orders_id_seq'::regclass) | plain    |              |
 эршьхэютрэшх | character varying(40) |           | not null |                                    | extended |              |
 Ўхэр         | integer               |           | not null |                                    | plain    |              |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_чрърч_fkey" FOREIGN KEY ("чрърч") REFERENCES orders(id)
Access method: heap

```

![image](https://user-images.githubusercontent.com/87389868/158032403-8523e376-8c1d-49af-9791-92496f55cf8a.png)

* SQL-запрос для выдачи списка пользователей с правами над таблицами test_db

```sql
SELECT * FROM information_schema.table_privileges where table_name='clients'  or table_name='orders';
```

* список пользователей с правами над таблицами test_db

```sql
 grantor |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy
---------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 admin2  | admin2           | test_db       | public       | orders     | INSERT         | YES          | NO
 admin2  | admin2           | test_db       | public       | orders     | SELECT         | YES          | YES
 admin2  | admin2           | test_db       | public       | orders     | UPDATE         | YES          | NO
 admin2  | admin2           | test_db       | public       | orders     | DELETE         | YES          | NO
 admin2  | admin2           | test_db       | public       | orders     | TRUNCATE       | YES          | NO
 admin2  | admin2           | test_db       | public       | orders     | REFERENCES     | YES          | NO
 admin2  | admin2           | test_db       | public       | orders     | TRIGGER        | YES          | NO
 admin2  | test-admin-user  | test_db       | public       | orders     | INSERT         | NO           | NO
 admin2  | test-admin-user  | test_db       | public       | orders     | SELECT         | NO           | YES
 admin2  | test-admin-user  | test_db       | public       | orders     | UPDATE         | NO           | NO
 admin2  | test-admin-user  | test_db       | public       | orders     | DELETE         | NO           | NO
 admin2  | test-admin-user  | test_db       | public       | orders     | TRUNCATE       | NO           | NO
 admin2  | test-admin-user  | test_db       | public       | orders     | REFERENCES     | NO           | NO
 admin2  | test-admin-user  | test_db       | public       | orders     | TRIGGER        | NO           | NO
 admin2  | test-simple-user | test_db       | public       | orders     | INSERT         | NO           | NO
 admin2  | test-simple-user | test_db       | public       | orders     | SELECT         | NO           | YES
 admin2  | test-simple-user | test_db       | public       | orders     | UPDATE         | NO           | NO
 admin2  | test-simple-user | test_db       | public       | orders     | DELETE         | NO           | NO
 admin2  | admin2           | test_db       | public       | clients    | INSERT         | YES          | NO
 admin2  | admin2           | test_db       | public       | clients    | SELECT         | YES          | YES
 admin2  | admin2           | test_db       | public       | clients    | UPDATE         | YES          | NO
 admin2  | admin2           | test_db       | public       | clients    | DELETE         | YES          | NO
 admin2  | admin2           | test_db       | public       | clients    | TRUNCATE       | YES          | NO
 admin2  | admin2           | test_db       | public       | clients    | REFERENCES     | YES          | NO
 admin2  | admin2           | test_db       | public       | clients    | TRIGGER        | YES          | NO
(25 rows)

```

## Задача 3

Таблица orders:

```sql
test_db=# select count(*) from clients;
 count
-------
     5
(1 row)
```

Таблица clients:

```sql
test_db=# select count(*) from orders;
 count
-------
     5
(1 row)
```

## Задача 4

Приведите SQL-запросы для выполнения данных операций.

```sql
update clients set "заказ" = 3 where "фамилия" = 'Иванов Иван Иванович';
update clients set "заказ" = 4 where "фамилия" = 'Петров Петр Петрович';
update clients set "заказ" = 5 where "фамилия" = 'Иоганн Себастьян Бах';
```

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

```sql
select * from clients as c where c.заказ is NOT NULL;

id|фамилия             |страна проживания|заказ|
--+--------------------+-----------------+-----+
 1|Иванов Иван Иванович|USA              |    3|
 2|Петров Петр Петрович|Canada           |    4|
 3|Иоганн Себастьян Бах|Japan            |    5|
```

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).Приведите получившийся результат и объясните что значат полученные значения.

```sql
explain (ANALYZE) select * from clients as c where c.заказ is NOT NULL;

QUERY PLAN                                                                                            |
------------------------------------------------------------------------------------------------------+
Seq Scan on clients c  (cost=0.00..13.50 rows=348 width=204) (actual time=0.016..0.017 rows=3 loops=1)|
  Filter: ("заказ" IS NOT NULL)                                                                       |
  Rows Removed by Filter: 2                                                                           |
Planning Time: 0.042 ms                                                                               |
Execution Time: 0.030 ms                                                                              |
```

EXPLAIN использовал Seq Scan для последовательного чтения данных из таблицы clients.

(cost=0.00..13.50 rows=348 width=204): cost - "затраты" на вполнение операции.  0.00 — затраты на получение первой строки, 13.50 - затраты на получение всех строк. width=204 — средний размер одной строки в байтах. rows=348 — приблизительное количество возвращаемых строк при выполнении операции Seq Scan. Это значение возвращает планировщик.

(actual time=0.016..0.017 rows=3 loops=1) - actual time реальное время на получение первой записи и всех записей выборки. rows=3 — реальное количество строк. loops=1 — сколько раз выполялась операция.

Filter: ("заказ" IS NOT NULL) - примененный фильтр. Rows Removed by Filter: 2  - количество отфильтрованных строк.

Planning Time: 0.042 ms  - плановое время выполнения.
Execution Time: 0.030 ms  - реальное время выполнения.

## Задача 6

1)Для создания бэкапа на хостовой машине была запущена команда:

```bash
sudo docker exec PostgreSQL /bin/bash -c "/usr/bin/pg_dump -U admin2 -Fc test_db > /var/postgresql/backup/test_db.dump"
```

2)Для создания нового контейнера был изменен манифест docker-compose

```bash
version: '3.1'
networks:
  monitoring:
    driver: bridge
volumes:
        #db_PostgresSQL: {}
  db_backup_PostgresSQL: {}
  db_new: {}

services:
  postgreSQL:
    image: postgres:12.10
    container_name: PostgreSQL-new
    volumes:
      - db_new:/var/postgresql/db
      - db_backup_PostgresSQL:/var/postgresql/backup
    restart: always
    networks:
      - monitoring
    ports:
      - 5432:5432
    environment:
      POSTGRES_USER: admin2
      POSTGRES_PASSWORD: Password0)
      POSTGRES_DB: test_db
      PGDATA: /var/postgresql/db
```

3)Подключаемся к серверу и создаем пользователей:

```sql
create user "test-admin-user" with password 'pwd'; 
create user "test-simple-user" with password 'pwd'; 
```

4)Для восстановления на хосте запускаем команду:

```bash
sudo docker exec  PostgreSQL-new /bin/bash -c "pg_restore -U admin2 -d test_db /var/postgresql/backup/test_db.dump"
```
