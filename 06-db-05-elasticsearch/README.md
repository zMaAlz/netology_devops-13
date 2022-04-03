# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

При попытке загрузить архив с оф.сайте возникает ошибка доступа.

```bash
Step 3/4 : RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.1.1-linux-x86_64.tar.gz && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.1.1-linux-x86_64.tar.gz.sha512 && shasum -a 512 -c elasticsearch-8.1.1-linux-x86_64.tar.gz.sha512 && tar -xzf elasticsearch-8.1.1-linux-x86_64.tar.gz && cd elasticsearch-8.1.1/
 ---> Running in 05baf285c087
--2022-03-27 17:30:55--  https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.1.1-linux-x86_64.tar.gz
Resolving artifacts.elastic.co (artifacts.elastic.co)... 34.120.127.130, 2600:1901:0:1d7::
Connecting to artifacts.elastic.co (artifacts.elastic.co)|34.120.127.130|:443... connected.
HTTP request sent, awaiting response... 403 Forbidden
2022-03-27 17:30:55 ERROR 403: Forbidden.
```

В docker-манифесте использовался локальный архив с elasticsearch.

```bash
FROM centos:7
COPY ./src /var/src/
RUN cd /var/src/ && \
tar -xzf /var/src/elasticsearch-8.1.2-linux-x86_64.tar && \
rm /var/src/elasticsearch-8.1.2-linux-x86_64.tar && \
cp elasticsearch.yml /var/src/elasticsearch-8.1.2/config/ && \
adduser elastic && \
gpasswd -a elastic wheel && \
chown -R elastic:elastic /var/src/elasticsearch-8.1.2 && \
chmod 755 /var/src/elasticsearch-8.1.2 && \
chmod 777 /var/lib
USER elastic:wheel
EXPOSE 9200 9300
CMD ["var/src/elasticsearch-8.1.2/bin/elasticsearch"]

```

```bash
admin2@ubuntu-srv:~/elasticsearch$ curl http://192.168.1.64:9200
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "5qUDyLQpR5mk-iJSrVhIBQ",
  "version" : {
    "number" : "8.1.2",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "31df9689e80bad366ac20176aa7f2371ea5eb4c1",
    "build_date" : "2022-03-29T21:18:59.991429448Z",
    "build_snapshot" : false,
    "lucene_version" : "9.0.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

https://hub.docker.com/repository/docker/zmaalz/elasticsearch

## Задача 2

список индексов и их статусов:

```bash
admin2@ubuntu-srv:~/elasticsearch$ curl -X GET http://localhost:9200/_cat/indices
green  open ind-1 pILXhD-dRduCYd6vH_NyMw 1 0 0 0 225b 225b
yellow open ind-3 MciLjMCISHu1KAl70Ylpgg 4 2 0 0 900b 900b
yellow open ind-2 lZYTA2WNRt62nNK2TQYk3Q 2 1 0 0 450b 450b
```

Часть идексов находится в yellow т.к. часть реплик недоступны.

состояние кластера:

```bash
admin2@ubuntu-srv:~/elasticsearch$ curl -X GET http://localhost:9200/_cluster/health?pretty
{
  "cluster_name" : "elasticsearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 8,
  "active_shards" : 8,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 44.44444444444444
}
```

удаление индексов:

```bash
curl -X DELETE http://localhost:9200/ind-1
curl -X DELETE http://localhost:9200/ind-2
curl -X DELETE http://localhost:9200/ind-3
```

## Задача 3

Создание репозитория:

```bash
admin2@ubuntu-srv:~/elasticsearch$ curl -X PUT http://localhost:9200/_snapshot/netology_backup -H 'Content-Type: application/json' -d '
> {
>   "type": "fs",
>   "settings": {
>     "location": "snapshots"
>   }
> }'
{"acknowledged":true}
```

список индексов:

```bash
admin2@ubuntu-srv:~/elasticsearch$ curl -X GET http://localhost:9200/_cat/indices
green open test aJpkeZqgQdKAq3ax_Zx_Ag 1 0 0 0 225b 225b
```

snapshot состояния кластера

```bash
admin2@ubuntu-srv:~/elasticsearch$ curl -X PUT http://localhost:9200/_snapshot/netology_backup/my_snap
{"accepted":true}

admin2@ubuntu-srv:~/elasticsearch$ sudo docker exec optimistic_neumann bash -c 'ls -lh /var/src/elasticsearch-8.1.2/snapshots/snapshots'
total 36K
-rw-r--r-- 1 elastic wheel  840 Apr  3 18:03 index-0
-rw-r--r-- 1 elastic wheel    8 Apr  3 18:03 index.latest
drwxr-xr-x 4 elastic wheel 4.0K Apr  3 18:03 indices
-rw-r--r-- 1 elastic wheel  18K Apr  3 18:03 meta-V7_61Si7RQK55QcXSH1Cfw.dat
-rw-r--r-- 1 elastic wheel  354 Apr  3 18:03 snap-V7_61Si7RQK55QcXSH1Cfw.dat
```

создайте индекс test-2

```bash
admin2@ubuntu-srv:~/elasticsearch$ curl -X DELETE http://localhost:9200/test
{"acknowledged":true}
curl -X PUT http://localhost:9200/test2/ -H 'Content-Type: application/json' -d ' 
> {
>   "settings" : {
>     "index" : { 
>       "number_of_replicas" : 0,
>       "number_of_shards" : 1
>     }
>   }
> }'
admin2@ubuntu-srv:~/elasticsearch$ curl -X GET http://localhost:9200/_cat/indicesd '
green open test2 T71ytIqXQEKTEGO3w92S4g 1 0 0 0 225b 225b

```

Восстановите состояние кластера elasticsearch из snapshot

```bash
admin2@ubuntu-srv:~/elasticsearch$ curl -X POST http://localhost:9200/_snapshot/netology_backup/my_snap/_restore
{"accepted":true}

admin2@ubuntu-srv:~/elasticsearch$ curl -X GET http://localhost:9200/_cat/indices
green open test2 T71ytIqXQEKTEGO3w92S4g 1 0 0 0 225b 225b
green open test  3rOF5ZpOT_yhmU_t0cO4Pw 1 0 0 0 225b 225b
```
