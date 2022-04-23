Домашнее задание к занятию "3.7. Компьютерные сети, лекция 2"
--------------------------------------------------------------

1-*Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?*

Windows - ipconfig
```
C:\Users\Admin>ipconfig

Настройка протокола IP для Windows

Адаптер Ethernet VirtualBox Host-Only Network:

   DNS-суффикс подключения . . . . . :
   Локальный IPv6-адрес канала . . . : fe80::45a4:8d7:2e48:862c%11
   IPv4-адрес. . . . . . . . . . . . : 192.168.56.1
   Маска подсети . . . . . . . . . . : 255.255.255.0
   Основной шлюз. . . . . . . . . :

Адаптер Ethernet Ethernet:

   DNS-суффикс подключения . . . . . :
   Локальный IPv6-адрес канала . . . : fe80::11bd:4983:91fb:3a71%10
   IPv4-адрес. . . . . . . . . . . . : 192.168.1.117
   Маска подсети . . . . . . . . . . : 255.255.255.0
   Основной шлюз. . . . . . . . . : 192.168.1.1
```
Linux - ip
```
vagrant@vagrant:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:73:60:cf brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 86373sec preferred_lft 86373sec
    inet6 fe80::a00:27ff:fe73:60cf/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:ed:ca:63 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.76/24 brd 192.168.1.255 scope global dynamic eth1
       valid_lft 25173sec preferred_lft 25173sec
    inet6 fe80::a00:27ff:feed:ca63/64 scope link
       valid_lft forever preferred_lft forever
```
2-*Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?*

LLDP — протокол канального уровня, который позволяет сетевым устройствам анонсировать в сеть информацию о себе и о своих возможностях, а также собирать эту информацию о соседних устройствах.
apt install lldpd
systemctl enable lldpd && systemctl start lldpd
```
vagrant@vagrant:~$ systemctl enable lldpd
Synchronizing state of lldpd.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable lldpd
==== AUTHENTICATING FOR org.freedesktop.systemd1.reload-daemon ===
Authentication is required to reload the systemd state.
Authenticating as: vagrant,,, (vagrant)
Password:
==== AUTHENTICATION COMPLETE ===
==== AUTHENTICATING FOR org.freedesktop.systemd1.reload-daemon ===
Authentication is required to reload the systemd state.
Authenticating as: vagrant,,, (vagrant)
Password:
==== AUTHENTICATION COMPLETE ===
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-unit-files ===
Authentication is required to manage system service or unit files.
Authenticating as: vagrant,,, (vagrant)
Password:
==== AUTHENTICATION COMPLETE ===
==== AUTHENTICATING FOR org.freedesktop.systemd1.reload-daemon ===
Authentication is required to reload the systemd state.
Authenticating as: vagrant,,, (vagrant)
Password:
==== AUTHENTICATION COMPLETE ===

vagrant@vagrant:~$ systemctl start lldpd
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===
Authentication is required to start 'lldpd.service'.
Authenticating as: vagrant,,, (vagrant)
Password:
==== AUTHENTICATION COMPLETE ===
```
sudo lldpctl

```
vagrant@vagrant:~$ sudo lldpctl
-------------------------------------------------------------------------------
LLDP neighbors:
-------------------------------------------------------------------------------
Interface:    eth1, via: LLDP, RID: 1, Time: 0 day, 00:01:25
  Chassis:
    ChassisID:    mac 74:d4:35:32:9f:24
  Port:
    PortID:       mac 74:d4:35:32:9f:24
    TTL:          3601
    PMD autoneg:  supported: yes, enabled: yes
      Adv:          1000Base-T, HD: no, FD: yes
      MAU oper type: unknown
  LLDP-MED:
    Device Type:  Generic Endpoint (Class I)
    Capability:   Capabilities, yes
-------------------------------------------------------------------------------
```

3-*Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.*

VLAN - — группа устройств, имеющих возможность взаимодействовать между собой напрямую на канальном уровне, хотя физически при этом они могут быть подключены к разным сетевым коммутаторам. И наоборот, устройства, находящиеся в разных VLAN'ах, невидимы друг для друга на канальном уровне, даже если они подключены к одному коммутатору, и связь между этими устройствами возможна только на сетевом и более высоких уровнях.
Настрока Vlan с помощью утилиты netplan:
```
vagrant@vagrant:~$ cat vi /etc/netplan/eth1.yaml
cat: vi: No such file or directory
network:
        renderer: networkd
        version: 2
        ethernets:
                eth1:
                        addresses: []
                        dhcp4: true
        vlans:
                vlan100:
                        id: 100
                        link: eth1
                        dhcp4: no
                        addresses: [192.168.1.99/24]
                        gateway4: 192.168.1.1


vagrant@vagrant:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:73:60:cf brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 86320sec preferred_lft 86320sec
    inet6 fe80::a00:27ff:fe73:60cf/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:ed:ca:63 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.76/24 brd 192.168.1.255 scope global dynamic eth1
       valid_lft 25120sec preferred_lft 25120sec
    inet6 fe80::a00:27ff:feed:ca63/64 scope link
       valid_lft forever preferred_lft forever
4: vlan100@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:ed:ca:63 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.99/24 brd 192.168.1.255 scope global vlan100
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:feed:ca63/64 scope link
       valid_lft forever preferred_lft forever
```
4-*Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.*
В linux агрегация сетевых интерфейсов называется бондингом (bonding).
Типы агрегации:
* balance-rr (задействуются оба интерфейса по очереди, распределение пакетов по принципу Round Robin).
* active-backup (используется только один интерфейс, второй активируется в случае неработоспособности первого).
* balance-xor (задействуются оба интерфейса по очереди, распределение пакетов на основе политики хеширования xmit_hash_policy).
* broadcast (задействуются оба интерфейса одновременно, пакеты передаются все интерфейсы).
* 802.3ad (задействуются оба интерфейса по очереди, распределение пакетов на основе политики хеширования xmit_hash_policy)
* balance-tlb (задействуются оба интерфейса по очереди, пакеты распределяются в соответствии с текущей нагрузкой)

```
vagrant@vagrant:~$ cat  /etc/netplan/bond0.yaml
network:
        version: 2
        renderer: networkd
        bonds:
                bond0:
                        dhcp4: false
                        interfaces: [eth1, eth2]
                        addresses: [192.168.1.90/24]
                        parameters:
                                mode: active-backup
                                primary: eth1
```

5-*Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.*

В сети с маской /29 будет 6 клиентских адресов. Из подсети /24 можно получить 32 подсети с маской /29.

10.10.10.0 - 10.10.10.7 / 29
10.10.10.8 - 10.10.10.15 / 29
10.10.10.16 - 10.10.10.23 / 29


6-*Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.*

Как вариант можно взять подсеть - 100.64.1.0 /26

7-*Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?*

В Windows: arp -a - выводит на экран содержимое ARP таблицы
В linux: ip neigh show - выводит на экран содержимое ARP таблицы

В Windows: ARP -d * - очитсти ARP таблицу полностью
В linux: ip neighbour flush nud all - очитсти ARP таблицу полностью

В Windows: ARP -d 192.168.1.1 - удаляет конкретный адрес из таблицы
В linux: ip neighbour delete dev eht1 192.168.1.1 - удаляет конкретный адрес из таблицы






