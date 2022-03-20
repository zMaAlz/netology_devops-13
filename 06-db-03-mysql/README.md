# Домашнее задание к занятию "6.3. MySQL"

## Задача 1

```bash
mysql> status
--------------
mysql  Ver 8.0.28 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          20
Current database:
Current user:           admin2@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.28 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 11 min 1 sec

Threads: 4  Questions: 62  Slow queries: 0  Opens: 185  Flush tables: 3  Open tables: 103  Queries per second avg: 0.093--------------
```

```bash
mysql> select * from orders where price>300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.00 sec)
```

## Задача 2

```bash
mysql> CREATE USER 'test'@'%' IDENTIFIED BY 'test-pass' PASSWORD EXPIRE INTERVAL 180 DAY;
Query OK, 0 rows affected (0.00 sec)

mysql> ALTER USER 'test'@'%' WITH MAX_QUERIES_PER_HOUR 100 MAX_USER_CONNECTIONS 3 comment "Pretty James";
Query OK, 0 rows affected (0.00 sec)

mysql> grant select on * to 'test';
Query OK, 0 rows affected (0.01 sec)

mysql> select * from INFORMATION_SCHEMA.USER_ATTRIBUTES where user='test';
+------+------+-----------------------------+
| USER | HOST | ATTRIBUTE                   |
+------+------+-----------------------------+
| test | %    | {"comment": "Pretty James"} |
+------+------+-----------------------------+
1 row in set (0.00 sec)
```

## Задача 3

```bash
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> show engines;
+--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
| Engine             | Support | Comment                                                        | Transactions | XA   | 
Savepoints |
+--------------------+---------+----------------------------------------------------------------+--------------+------+------------+       
| FEDERATED          | NO      | Federated MySQL storage engine                                 | NULL         | NULL | NULL       |       
| MEMORY             | YES     | Hash based, stored in memory, useful for temporary tables      | NO           | NO   | NO         |       
| InnoDB             | DEFAULT | Supports transactions, row-level locking, and foreign keys     | YES          | YES  | YES        |       
| PERFORMANCE_SCHEMA | YES     | Performance Schema                                             | NO           | NO   | NO         |       
| MyISAM             | YES     | MyISAM storage engine                                          | NO           | NO   | NO         |       
| MRG_MYISAM         | YES     | Collection of identical MyISAM tables                          | NO           | NO   | NO         |       
| BLACKHOLE          | YES     | /dev/null storage engine (anything you write to it disappears) | NO           | NO   | NO         |       
| CSV                | YES     | CSV storage engine                                             | NO           | NO   | NO         |       
| ARCHIVE            | YES     | Archive storage engine                                         | NO           | NO   | NO         |       
+--------------------+---------+----------------------------------------------------------------+--------------+------+------------+       
9 rows in set (0.00 sec)

mysql> show table status
    -> ;
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+-------------+------------+--------------------+----------+----------------+---------+     
| Name   | Engine | Version | Row_format | Rows | Avg_row_length | Data_length | Max_data_length | Index_length | Data_free | Auto_increment | Create_time         | Update_time | Check_time | Collation          | Checksum | Create_options | Comment |     
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+-------------+------------+--------------------+----------+----------------+---------+     
| orders | InnoDB |      10 | Dynamic    |    5 |           3276 |       16384 |               0 |            0 |         0 |              6 | 2022-03-19 17:52:33 | NULL        | NULL       | utf8mb4_0900_ai_ci |     NULL |                |         |     
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+-------------+------------+--------------------+----------+----------------+---------+     
1 row in set (0.00 sec)
```

По умолчанию в версии 8 используется движок - InnoDB.

Время выполнения запроса на изменение движка MyISAM - 0.11484950 (alter table orders engine = MyISAM). alter table orders engine = InnoDB, время выполнения - 0.14736625.

```bash
mysql> SHOW PROFILES;
+----------+------------+------------------------------------+
| Query_ID | Duration   | Query                              |
+----------+------------+------------------------------------+
|        1 | 0.00052175 | show engines                       |
|        2 | 0.02062750 | select * from orders               |
|        3 | 0.00011175 | alter teble orders engine = MyISAM |
|        4 | 0.11484950 | alter table orders engine = MyISAM |
|        5 | 0.00047650 | select * from orders               |
|        6 | 0.00047175 | select * from orders               |
|        7 | 0.14736625 | alter table orders engine = InnoDB |
|        8 | 0.00036625 | select * from orders               |
|        9 | 0.00034150 | select * from orders               |
+----------+------------+------------------------------------+
9 rows in set, 1 warning (0.00 sec)

```



## Задача 4

```bash

[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /etc/mysql/db
secure-file-priv= NULL
innodb_buffer_pool_size = 1G
default-authentication-plugin = mysql_native_password
innodb_file_per_table = 1
innodb_log_file_size = 100M
innodb_log_buffer_size = 1M
innodb_flush_method = O_DSYNC
innodb_flush_log_at_trx_commit = 2


# Custom config should go here
!includedir /etc/mysql/conf.d/
```
