# Домашнее задание к занятию "5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"

## Задача 1

Дайте письменые ответы на следующие вопросы:

В: В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
О: Глобальный режим подразумевает запуск задачи развертывания сервисов на всех нодах кластера. Реплицирование задает количество нод для развертывания сервиса.

В: Какой алгоритм выбора лидера используется в Docker Swarm кластере?
О: Docker Swarm использует алгоритм консенсуса Raft

В: Что такое Overlay Network?
О: Безопасная сеть (с шифрованием), которую создает Docker Swarm поверх сети хоста. При добавлении новой ноды с Docker на ней создается 2 сети: ingress - для передачи трафика управления и данных, сеть-мост docker_gwbridge - для соединения домонов docker между собой.  

## Задача 2

```bash
[centos@node01 ~]$ sudo docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
y7d3o65dwpnn4ihx17fh859md *   node01.netology.yc   Ready     Active         Leader           20.10.12
bqh4lhikby9fdsqhefmpmn37g     node02.netology.yc   Ready     Active         Reachable        20.10.12
5s9vqsmnbzxzf00oo3qjad3zw     node03.netology.yc   Ready     Active         Reachable        20.10.12
cswq74207692p1ks4kcn9drve     node04.netology.yc   Ready     Active                          20.10.12
iljs26crfwvmq8ltn5o4y2cp4     node05.netology.yc   Ready     Active                          20.10.12
i65o5aq3qkisn89inczeuouzx     node06.netology.yc   Ready     Active                          20.10.12
```

## Задача 3

```bash
[root@node01 monitoring]# docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
il3bkim8mh9e   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0
d4hcynskn3p5   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
njag9t2cx7gi   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest
pj9m8nl6kent   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest
p2bw0h6nrds0   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4
iw9wn3qr3c8t   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0
4iyul76b0mnv   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0
kzukirkyyrhf   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0
```

## Задача 4

```bash
docker swarm update --autolock=true
```

Команда блокирует автоматический запуск и загрузку ключей шифрования в ноду с ролью менеждера при перезапуске docker. Ручной режим валидации позволяет исключить неправомерный доступ к ключам шифрования кластера.
