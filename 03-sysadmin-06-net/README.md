Домашнее задание к занятию "3.6. Компьютерные сети, лекция 1"
--------------------------------------------------------------

1- *Работа c HTTP через телнет.*
```
vagrant@vagrant:~$ telnet stackoverflow.com 80
Trying 151.101.1.69...
Connected to stackoverflow.com.
Escape character is '^]'.
GET /questions HTTP/1.0
HOST: stackoverflow.com

HTTP/1.1 301 Moved Permanently
cache-control: no-cache, no-store, must-revalidate
location: https://stackoverflow.com/questions
x-request-guid: 851d9c77-3437-4332-a4e3-5b466ddbe051
feature-policy: microphone 'none'; speaker 'none'
content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
Accept-Ranges: bytes
Date: Sun, 21 Nov 2021 13:45:03 GMT
Via: 1.1 varnish
Connection: close
X-Served-By: cache-bma1678-BMA
X-Cache: MISS
X-Cache-Hits: 0
X-Timer: S1637502303.240782,VS0,VE101
Vary: Fastly-SSL
X-DNS-Prefetch-Control: off
Set-Cookie: prov=d18e3768-2c68-d4d6-ae02-2e2e272a6a34; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly

Connection closed by foreign host.
```
Сервер ответил "301 Moved Permanently", что означает, что запрашиваемый ресурс был переимещен в новое место. 


2- *Повторите задание 1 в браузере, используя консоль разработчика F12.*
![image](https://user-images.githubusercontent.com/87389868/142764486-bbc5405a-f130-4ca5-b5a6-6e248fb6a1a1.png)

Сервер ответил - 307 Internal Redirect. Запрашиваемый ресурс доступен по другому URI.

![image](https://user-images.githubusercontent.com/87389868/142764516-eb42f3ad-306a-4745-8090-599b5bb835a1.png)

Запрос был перенаправлен на https://stackoverflow.com/, этот запрос обрабатывался дольше всего. 

3- *Какой IP адрес у вас в интернете? *
```
vagrant@vagrant:~$ curl ifconfig.co
149.62.24.207
```

4- *Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой whois *
```
vagrant@vagrant:~$ whois -h  whois.ripe.net 149.62.24.207
inetnum:        149.62.11.0 - 149.62.26.255
netname:        BCA-FTTB-11
descr:          Business Communication Agency, Ltd.
descr:          Nizhny Novgorod, Russia
country:        RU
admin-c:        DV15-RIPE
tech-c:         DV15-RIPE
status:         ASSIGNED PA
mnt-by:         AS8371-MNT
created:        2012-01-25T05:22:00Z
last-modified:  2012-01-25T05:22:00Z
source:         RIPE # Filtered

person:         Dmitry Valdov
address:        Business Communication Agency, Ltd.
address:        12, Sovetskaya st.,
address:        N.Novgorod, 603002
address:        Russia
phone:          +7 8312 777780
nic-hdl:        DV15-RIPE
mnt-by:         AS8371-MNT
created:        2002-04-24T14:31:47Z
last-modified:  2015-06-10T08:37:34Z
source:         RIPE # Filtered

% Information related to '149.62.0.0/19AS8371'

route:          149.62.0.0/19
descr:          JSC Vimpelcom
descr:          Nizhny Novgorod, Russia
origin:         AS8371
mnt-by:         AS8371-MNT
created:        2011-10-20T18:44:11Z
last-modified:  2012-07-27T07:17:11Z
source:         RIPE # Filtered
```
Провайдер - JSC Vimpelcom
AS -  AS8371


5- *Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой traceroute *
```
vagrant@vagrant:~$ sudo traceroute -An 8.8.8.8 -i eth1
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  192.168.1.1 [*]  0.880 ms  0.697 ms  0.683 ms
 2  92.242.92.251 [AS8371]  1.984 ms  1.891 ms  1.371 ms
 3  89.189.25.213 [AS8371]  3.701 ms  5.035 ms  4.477 ms
 4  149.62.0.130 [AS8371]  5.403 ms  5.051 ms  4.707 ms
 5  149.62.0.129 [AS8371]  3.016 ms  2.669 ms  2.842 ms
 6  195.239.15.53 [AS3216]  2.498 ms  5.378 ms  3.460 ms
 7  79.104.225.15 [AS3216]  8.989 ms 79.104.235.213 [AS3216]  8.734 ms  8.435 ms
 8  72.14.213.116 [AS15169]  8.974 ms  8.743 ms 81.211.29.103 [AS3216]  13.331 ms
 9  * 108.170.250.113 [AS15169]  10.733 ms 108.170.250.99 [AS15169]  10.570 ms
10  * * 142.251.49.24 [AS15169]  29.638 ms
11  108.170.235.204 [AS15169]  27.755 ms 108.170.235.64 [AS15169]  27.724 ms 74.125.253.94 [AS15169]  23.015 ms
12  216.239.48.97 [AS15169]  30.911 ms 172.253.79.169 [AS15169]  22.615 ms 142.250.238.179 [AS15169]  25.569 ms
13  * * *
14  * * *
15  * * *
16  * * *
17  * * *
18  * * *
19  * * *
20  * * *
21  8.8.8.8 [AS15169]  20.951 ms * *
```

6- *Повторите задание 5 в утилите mtr. На каком участке наибольшая задержка - delay? *
```
                                                                      My traceroute  [v0.93]
vagrant (192.168.1.133)                                                                                                                   2021-11-21T15:15:07+0000
Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                                                                                                          Packets               Pings
 Host                                                                                                                   Loss%   Snt   Last   Avg  Best  Wrst StDev
 1. _gateway                                                                                                             0.7%   142    1.3   1.1   0.5   3.4   0.5
 2. _gateway                                                                                                             0.0%   142    4.1   2.8   1.4  23.2   2.0
 3. 92.242.92.251                                                                                                        0.0%   142    3.2   3.9   2.2  28.3   3.4
 4. 89.189.25.213                                                                                                        0.7%   142    5.0   7.1   3.9  33.8   4.9
 5. 149.62.0.130                                                                                                         0.0%   142    5.5   6.6   4.0  16.1   2.3
 6. 149.62.0.129                                                                                                         0.0%   142    4.5   4.4   2.8  29.8   2.6
 7. 195.239.15.53                                                                                                        0.7%   142    5.3   5.5   3.2  29.6   4.4
 8. pe05.KK12.Moscow.gldn.net                                                                                            0.0%   142    9.0  10.1   8.5  36.1   3.3
 9. 81.211.29.103                                                                                                        0.0%   142    8.6  10.8   8.4  45.7   5.6
10. 108.170.250.83                                                                                                      20.4%   142   10.3  12.7   9.0  47.0   7.0
11. 209.85.249.158                                                                                                      61.3%   142   27.0  25.0  23.0  32.3   1.8
12. 74.125.253.94                                                                                                        0.0%   142   23.9  25.7  22.7  66.7   5.7
13. 216.239.62.9                                                                                                         0.0%   141   23.8  24.7  22.6  56.5   4.2
14. (waiting for reply)
15. (waiting for reply)
16. (waiting for reply)
17. (waiting for reply)
18. (waiting for reply)
19. (waiting for reply)
20. (waiting for reply)
21. (waiting for reply)
22. (waiting for reply)
23. dns.google                                                                                                           0.0%   141   24.1  24.3  22.7  53.3   2.9
```
Наибольшая средняя задержка происходит на 209.85.249.158 (25,0) и 74.125.253.94 (25,7). 

7- *Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой dig *
```
vagrant@vagrant:~$ dig +trace dns.google

; <<>> DiG 9.16.1-Ubuntu <<>> +trace dns.google
;; global options: +cmd
.                       25642   IN      NS      j.root-servers.net.
.                       25642   IN      NS      c.root-servers.net.
.                       25642   IN      NS      g.root-servers.net.
.                       25642   IN      NS      a.root-servers.net.
.                       25642   IN      NS      e.root-servers.net.
.                       25642   IN      NS      h.root-servers.net.
.                       25642   IN      NS      i.root-servers.net.
.                       25642   IN      NS      d.root-servers.net.
.                       25642   IN      NS      b.root-servers.net.
.                       25642   IN      NS      f.root-servers.net.
.                       25642   IN      NS      m.root-servers.net.
.                       25642   IN      NS      l.root-servers.net.
.                       25642   IN      NS      k.root-servers.net.
;; Received 262 bytes from 127.0.0.53#53(127.0.0.53) in 68 ms

dns.google.             674     IN      A       8.8.8.8
dns.google.             674     IN      A       8.8.4.4
dns.google.             674     IN      RRSIG   A 8 2 900 20211221080936 20211121080936 1773 dns.google. EQ5hocM5ma31tdQ5OWRIs9RBNBeOKZbJDX7Jv50/RSrhoOUu8onfcBYH PbygeTcOaLQMP7Gt12jBaoR2YaXXzLuoRRxJs8q+JzuQTc0nR960jtpt acXjicWSM7RniJo01MHrphoV1VZudPu+WJmWHTxD8ZJFRAwP45ChQxS2 ZjA=
;; Received 253 bytes from 192.112.36.4#53(g.root-servers.net) in 64 ms

```
8- *Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой dig *
```
vagrant@vagrant:~$ dig -x 8.8.8.8

; <<>> DiG 9.16.1-Ubuntu <<>> -x 8.8.8.8
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 20433
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;8.8.8.8.in-addr.arpa.          IN      PTR

;; ANSWER SECTION:
8.8.8.8.in-addr.arpa.   4590    IN      PTR     dns.google.

```

