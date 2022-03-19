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

```

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
