# Домашнее задание к занятию "6.2. SQL"

## Задача 1

В: Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.
Приведите получившуюся команду или docker-compose манифест.

О:

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

* список пользователей с правами над таблицами test_db

## Задача 3

## Задача 4

## Задача 5

## Задача 6
