# Домашнее задание к занятию "6.2. SQL"

## Задача 1

В: Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.
Приведите получившуюся команду или docker-compose манифест.

О: docker-compose.yaml

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

В: Приведите:

* итоговый список БД после выполнения пунктов выше


* описание таблиц (describe)

* SQL-запрос для выдачи списка пользователей с правами над таблицами test_db

```sql
SELECT * FROM information_schema.table_privileges where table_name='clients'  or table_name='orders';

grantor|grantee         |table_catalog|table_schema|table_name|privilege_type|is_grantable|with_hierarchy|
-------+----------------+-------------+------------+----------+--------------+------------+--------------+
admin2 |admin2          |test_db      |public      |orders    |INSERT        |YES         |NO            |
admin2 |admin2          |test_db      |public      |orders    |SELECT        |YES         |YES           |
admin2 |admin2          |test_db      |public      |orders    |UPDATE        |YES         |NO            |
admin2 |admin2          |test_db      |public      |orders    |DELETE        |YES         |NO            |
admin2 |admin2          |test_db      |public      |orders    |TRUNCATE      |YES         |NO            |
admin2 |admin2          |test_db      |public      |orders    |REFERENCES    |YES         |NO            |
admin2 |admin2          |test_db      |public      |orders    |TRIGGER       |YES         |NO            |
admin2 |test-admin-user |test_db      |public      |orders    |INSERT        |NO          |NO            |
admin2 |test-admin-user |test_db      |public      |orders    |SELECT        |NO          |YES           |
admin2 |test-admin-user |test_db      |public      |orders    |UPDATE        |NO          |NO            |
admin2 |test-admin-user |test_db      |public      |orders    |DELETE        |NO          |NO            |
admin2 |test-admin-user |test_db      |public      |orders    |TRUNCATE      |NO          |NO            |
admin2 |test-admin-user |test_db      |public      |orders    |REFERENCES    |NO          |NO            |
admin2 |test-admin-user |test_db      |public      |orders    |TRIGGER       |NO          |NO            |
admin2 |test-simple-user|test_db      |public      |orders    |INSERT        |NO          |NO            |
admin2 |test-simple-user|test_db      |public      |orders    |SELECT        |NO          |YES           |
admin2 |test-simple-user|test_db      |public      |orders    |UPDATE        |NO          |NO            |
admin2 |test-simple-user|test_db      |public      |orders    |DELETE        |NO          |NO            |
admin2 |admin2          |test_db      |public      |clients   |INSERT        |YES         |NO            |
admin2 |admin2          |test_db      |public      |clients   |SELECT        |YES         |YES           |
admin2 |admin2          |test_db      |public      |clients   |UPDATE        |YES         |NO            |
admin2 |admin2          |test_db      |public      |clients   |DELETE        |YES         |NO            |
admin2 |admin2          |test_db      |public      |clients   |TRUNCATE      |YES         |NO            |
admin2 |admin2          |test_db      |public      |clients   |REFERENCES    |YES         |NO            |
admin2 |admin2          |test_db      |public      |clients   |TRIGGER       |YES         |NO            |
admin2 |test-admin-user |test_db      |public      |clients   |INSERT        |NO          |NO            |
admin2 |test-admin-user |test_db      |public      |clients   |SELECT        |NO          |YES           |
admin2 |test-admin-user |test_db      |public      |clients   |UPDATE        |NO          |NO            |
admin2 |test-admin-user |test_db      |public      |clients   |DELETE        |NO          |NO            |
admin2 |test-admin-user |test_db      |public      |clients   |TRUNCATE      |NO          |NO            |
admin2 |test-admin-user |test_db      |public      |clients   |REFERENCES    |NO          |NO            |
admin2 |test-admin-user |test_db      |public      |clients   |TRIGGER       |NO          |NO            |
admin2 |test-simple-user|test_db      |public      |clients   |INSERT        |NO          |NO            |
admin2 |test-simple-user|test_db      |public      |clients   |SELECT        |NO          |YES           |
admin2 |test-simple-user|test_db      |public      |clients   |UPDATE        |NO          |NO            |
admin2 |test-simple-user|test_db      |public      |clients   |DELETE        |NO          |NO            |

```

* список пользователей с правами над таблицами test_db

## Задача 3

## Задача 4

## Задача 5

## Задача 6