# Домашнее задание к занятию "15.1. Организация сети"

<details>

Домашнее задание будет состоять из обязательной части, которую необходимо выполнить на провайдере Яндекс.Облако и дополнительной части в AWS по желанию. Все домашние задания в 15 блоке связаны друг с другом и в конце представляют пример законченной инфраструктуры.
Все задания требуется выполнить с помощью Terraform, результатом выполненного домашнего задания будет код в репозитории.

Перед началом работ следует настроить доступ до облачных ресурсов из Terraform используя материалы прошлых лекций и ДЗ. А также заранее выбрать регион (в случае AWS) и зону.

</details>

## Задание 1. Яндекс.Облако

<details>

1. Создать VPC.
* Создать пустую VPC. Выбрать зону.
2. Публичная подсеть.
* Создать в vpc subnet с названием public, сетью 192.168.10.0/24.
* Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1
* Создать в этой публичной подсети виртуалку с публичным IP и подключиться к ней, убедиться что есть доступ к интернету.
3. Приватная подсеть.
* Создать в vpc subnet с названием private, сетью 192.168.20.0/24.
* Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс
* Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее и убедиться что есть доступ к интернету

</details>

**Манифесты:**

* src/connect_yc.tf - данные для подключение к YC
* src/variable.tf - Переменные 
* src/network_subnet.tf - манифест для создания сети, подсетей и таблиц маршрутизации
* src/instance.tf - манифест для создания ната и виртуальной машины. 

**Запускаем терраформ** 

```bash
[maal@kingdom src]$ terraform validate
Success! The configuration is valid.

[maal@kingdom src]$ terraform apply
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

...

Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

instance_ip_addr_nat-instance = "84.201.130.71"
instance_ip_addr_private-srv = "192.168.20.14"

```

**Подключаемся по ssh к nat-instance**

```bash

[maal@kingdom src]$ ssh 84.201.130.71
maal@fhm0o47a1kg8eejfbbuq:~$ ping ya.ru
PING ya.ru (87.250.250.242) 56(84) bytes of data.
64 bytes from ya.ru (87.250.250.242): icmp_seq=1 ttl=58 time=1.39 ms
64 bytes from ya.ru (87.250.250.242): icmp_seq=2 ttl=58 time=0.614 ms
^Z
[2]+  Stopped                 ping ya.ru
maal@fhm0o47a1kg8eejfbbuq:~$ curl http://ifconfig.me
84.201.130.71

```

**С nat-instance переходим на ВМ в private сети и проверяем доступ в интернет**

```bash
maal@fhm0o47a1kg8eejfbbuq:~$ ssh 192.168.20.14
[maal@fhm4i88nfdqbdho2anha ~]$ 
[maal@fhm4i88nfdqbdho2anha ~]$ ping ya.ru
PING ya.ru (87.250.250.242) 56(84) bytes of data.
64 bytes from ya.ru (87.250.250.242): icmp_seq=1 ttl=56 time=4.65 ms
64 bytes from ya.ru (87.250.250.242): icmp_seq=2 ttl=56 time=1.30 ms
^Z
[1]+  Stopped                 ping ya.ru
[maal@fhm4i88nfdqbdho2anha ~]$ curl http://ifconfig.me
84.201.130.71
```
