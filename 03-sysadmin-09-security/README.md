Домашнее задание к занятию "3.9. Элементы безопасности информационных систем"
------------------------------------------------------------------------------

1- *Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей.*
![image](https://user-images.githubusercontent.com/87389868/147406113-22cf1f32-a8d4-4430-a0db-571bab11b5e3.png)

2- *Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.*
![image](https://user-images.githubusercontent.com/87389868/147406129-3030b43c-e896-4681-a1be-d0abd664ed32.png)


3- *Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.*
![image](https://user-images.githubusercontent.com/87389868/147409862-bab662be-ee31-4598-9740-647a3c37dc21.png)

![image](https://user-images.githubusercontent.com/87389868/147416475-7260cd75-6920-4e2a-8cc7-216e33190e97.png)


4- *Проверьте на TLS уязвимости произвольный сайт в интернете (кроме сайтов МВД, ФСБ, МинОбр, НацБанк, РосКосмос, РосАтом, РосНАНО и любых госкомпаний, объектов КИИ, ВПК ... и тому подобное).*

```
admin2@ubuntu-srv:~/testssl.sh-3.0.4$ ./testssl.sh -U --sneaky 2ip.ru

###########################################################
    testssl.sh       3.0.4 from https://testssl.sh/

      This program is free software. Distribution and
             modification under GPLv2 permitted.
      USAGE w/o ANY WARRANTY. USE IT AT YOUR OWN RISK!

       Please file bugs @ https://testssl.sh/bugs/

###########################################################

 Using "OpenSSL 1.0.2-chacha (1.0.2k-dev)" [~183 ciphers]
 on ubuntu-srv:./bin/openssl.Linux.x86_64
 (built: "Jan 18 17:12:17 2019", platform: "linux-x86_64")


 Start 2021-12-26 15:40:57        -->> 195.201.201.32:443 (2ip.ru) <<--

 rDNS (195.201.201.32):  2ip.ru.
 Service detected:       HTTP


 Testing vulnerabilities

 Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
 CCS (CVE-2014-0224)                       not vulnerable (OK)
 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK)
 ROBOT                                     not vulnerable (OK)
 Secure Renegotiation (RFC 5746)           supported (OK)
 Secure Client-Initiated Renegotiation     not vulnerable (OK)
 CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
 BREACH (CVE-2013-3587)                    potentially NOT ok, "gzip" HTTP compression detected. - only supplied "/" tested
                                           Can be ignored for static pages or if no secrets in the page
 POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
 TLS_FALLBACK_SCSV (RFC 7507)              Downgrade attack prevention supported (OK)
 SWEET32 (CVE-2016-2183, CVE-2016-6329)    not vulnerable (OK)
 FREAK (CVE-2015-0204)                     not vulnerable (OK)
 DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                           make sure you don't use this certificate elsewhere with SSLv2 enabled services
                                           https://censys.io/ipv4?q=E03715E377AADBD111BFF3D1014A6DC14E9FD79D08F9B828DB78ED5B0369BE40 could help you to find out
 LOGJAM (CVE-2015-4000), experimental      not vulnerable (OK): no DH EXPORT ciphers, no DH key detected with <= TLS 1.2
 BEAST (CVE-2011-3389)                     TLS1: ECDHE-RSA-AES256-SHA ECDHE-RSA-AES128-SHA AES256-SHA
                                                 CAMELLIA256-SHA AES128-SHA CAMELLIA128-SHA
                                           VULNERABLE -- but also supports higher protocols  TLSv1.1 TLSv1.2 (likely mitigated)
 LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
 RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)


 Done 2021-12-26 15:41:43 [  49s] -->> 195.201.201.32:443 (2ip.ru) <<--

```
5- *Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.*

Задание выполнялось на 2 виртуальных машинах с windows 10 и ubuntu 20.04. Но порядок выполнения аналогичен как при использовании 2 ПК на linux.
```
admin2@ubuntu-srv:~$ sudo systemctl status sshd
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
     Active: active (running) since Sun 2021-12-26 14:07:25 UTC; 3h 4min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
    Process: 841 ExecStartPre=/usr/sbin/sshd -t (code=exited, status=0/SUCCESS)
   Main PID: 875 (sshd)
      Tasks: 1 (limit: 2245)
     Memory: 6.3M
     CGroup: /system.slice/ssh.service
             └─875 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
```
```
PS C:\Users\Admin> scp C:\Users\Admin\.ssh\id_rsa.pub admin2@192.168.1.64:/home/admin2/.ssh/authorized_keys
The authenticity of host '192.168.1.64 (192.168.1.64)' can't be established.
ECDSA key fingerprint is SHA256:1BEQpIR6hbP1NxP26ULhSH12u8ELZCVmsks/Lx8Hu1M.
Are you sure you want to continue connecting (yes/no/[fingerprint])?
Warning: Permanently added '192.168.1.64' (ECDSA) to the list of known hosts.
admin2@192.168.1.64's password:
id_rsa.pub                                    100%  568   138.9KB/s   00:00
PS C:\Users\Admin> ssh admin2@192.168.1.64
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Вс 26 дек 2021 17:03:38 UTC

  System load:  0.0                Processes:              229
  Usage of /:   18.8% of 23.99GB   Users logged in:        1
  Memory usage: 21%                IPv4 address for ens33: 192.168.1.64
  Swap usage:   0%

 * Super-optimized for small spaces - read how we shrank the memory
   footprint of MicroK8s to make it the smallest full K8s around.

   https://ubuntu.com/blog/microk8s-memory-optimisation

50 updates can be applied immediately.
6 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable


Last login: Sun Dec 26 14:39:58 2021 from 192.168.1.117
admin2@ubuntu-srv:~$
```

6- *Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.*

Задание выполнялось на 2 виртуальных машинах с windows 10 и ubuntu 20.04. Но порядок выполнения аналогичен как при использовании 2 ПК на linux.
```
admin2@ubuntu-srv:~$ touch ~/.ssh/config && chmod 600 ~/.ssh/config
admin2@ubuntu-srv:~$ ls -lha .ssh/
total 20K
drwx------ 2 admin2 admin2 4,0K дек 26 17:42 .
drwxr-xr-x 5 admin2 admin2 4,0K дек 26 16:25 ..
-rw-rw-r-- 1 admin2 admin2  568 дек 26 17:01 authorized_keys
-rw------- 1 admin2 admin2    0 дек 26 17:42 config
-rw------- 1 admin2 admin2 2,6K дек 26 16:25 id_rsa
-rw-r--r-- 1 admin2 admin2  571 дек 26 16:25 id_rsa.pub
```

```
PS C:\Users\Admin\.ssh> New-Item -Path $HOME\.ssh\config -ItemType File

    Каталог: C:\Users\Admin\.ssh


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        26.12.2021     20:37              0 config

PS C:\Users\Admin\.ssh> C:\WINDOWS\System32\notepad.exe $HOME\.ssh\config

Host ubuntu_srv
  HostName 192.168.1.64
  User admin2
  IdentityFile ~/.ssh/id_rsa_publ.pub
  IdentitiesOnly yes
```  
```
PS C:\Users\Admin\.ssh> ssh ubuntu_srv
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Вс 26 дек 2021 17:44:28 UTC

  System load:  0.0                Processes:              225
  Usage of /:   18.8% of 23.99GB   Users logged in:        1
  Memory usage: 18%                IPv4 address for ens33: 192.168.1.64
  Swap usage:   0%

 * Super-optimized for small spaces - read how we shrank the memory
   footprint of MicroK8s to make it the smallest full K8s around.

   https://ubuntu.com/blog/microk8s-memory-optimisation

50 updates can be applied immediately.
6 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable


Last login: Sun Dec 26 17:41:21 2021 from 192.168.1.117
admin2@ubuntu-srv:~$
```

7- *Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.*

```
admin2@ubuntu-srv:~$ sudo tcpdump -i ens33 -w dump.pcap -c 500
tcpdump: listening on ens33, link-type EN10MB (Ethernet), capture size 262144 bytes
500 packets captured
512 packets received by filter
0 packets dropped by kernel
```
![image](https://user-images.githubusercontent.com/87389868/147416430-bd5c3b43-5f8a-4ec7-9992-d59b23ec72ec.png)


8- *Просканируйте хост scanme.nmap.org. Какие сервисы запущены?*

```
admin2@ubuntu-srv:~$ sudo nmap -O scanme.nmap.org
[sudo] password for admin2:
Starting Nmap 7.80 ( https://nmap.org ) at 2021-12-26 18:07 UTC
Nmap scan report for scanme.nmap.org (45.33.32.156)
Host is up (0.19s latency).
Other addresses for scanme.nmap.org (not scanned): 2600:3c01::f03c:91ff:fe18:bb2f
Not shown: 994 closed ports
PORT      STATE    SERVICE
22/tcp    open     ssh
25/tcp    filtered smtp
53/tcp    open     domain
80/tcp    open     http
9929/tcp  open     nping-echo
31337/tcp open     Elite
Aggressive OS guesses: HP P2000 G3 NAS device (93%), Linux 2.6.32 (92%), Infomir MAG-250 set-top box (92%), Ubiquiti AirMax NanoStation WAP (Linux 2.6.32) (92%), Ubiquiti AirOS 5.5.9 (92%), Ubiquiti Pico Station WAP (AirOS 5.2.6) (92%), Linux 2.6.32 - 3.13 (92%), Linux 3.3 (92%), Linux 2.6.32 - 3.1 (91%), Linux 3.7 (91%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 15 hops

OS detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 16.76 seconds
```

На серере запущены: SSH, Почтовый сервер, Web-сервер, nping(утилита генерации пакетов), Elite (отслеживает подключения и сканирование порта 31337).

9- *Установите и настройте фаервол ufw на web-сервер из задания 3. Откройте доступ снаружи только к портам 22,80,443*

```
admin2@ubuntu-srv:~$ sudo ufw allow 80/tcp
Rules updated
Rules updated (v6)
admin2@ubuntu-srv:~$ sudo ufw allow 443/tcp
Rules updated
Rules updated (v6)
admin2@ubuntu-srv:~$ sudo ufw allow 22
Rules updated
Rules updated (v6)
admin2@ubuntu-srv:~$ sudo ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup
admin2@ubuntu-srv:~$ sudo ufw status
Status: active

To                         Action      From
--                         ------      ----
22                         ALLOW       Anywhere
443/tcp                    ALLOW       Anywhere
80/tcp                     ALLOW       Anywhere
22 (v6)                    ALLOW       Anywhere (v6)
443/tcp (v6)               ALLOW       Anywhere (v6)
80/tcp (v6)                ALLOW       Anywhere (v6)
```
