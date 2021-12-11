Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"
------------------------------------------------------------

1- *Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP *
```
route-views>show ip route 92.242.74.248
Routing entry for 92.242.64.0/19
  Known via "bgp 6447", distance 20, metric 0
  Tag 2497, type external
  Last update from 202.232.0.2 2d00h ago
  Routing Descriptor Blocks:
  * 202.232.0.2, from 202.232.0.2, 2d00h ago
      Route metric is 0, traffic share count is 1
      AS Hops 3
      Route tag 2497
      MPLS label: none
      
route-views>show ip bgp 92.242.74.248
BGP routing table entry for 92.242.64.0/19, version 1400990087
Paths: (23 available, best #11, table default)
  Not advertised to any peer
  Refresh Epoch 1
  57866 3356 3216 8371, (aggregated by 8371 195.98.32.87)
    37.139.139.17 from 37.139.139.17 (37.139.139.17)
      Origin IGP, metric 0, localpref 100, valid, external, atomic-aggregate
      Community: 3216:2001 3216:4452 3356:2 3356:22 3356:100 3356:123 3356:503 3356:903 3356:2067 8371:1001
      path 7FE089ECAA10 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3549 3356 3216 8371, (aggregated by 8371 195.98.32.87)
    208.51.134.254 from 208.51.134.254 (67.16.168.191)
      Origin IGP, metric 0, localpref 100, valid, external, atomic-aggregate
      Community: 3216:2001 3216:4452 3356:2 3356:22 3356:100 3356:123 3356:503 3356:903 3356:2067 3549:2581 3549:30840 8371:1001
      path 7FE14C57FEB8 RPKI State not found
      rx pathid: 0, tx pathid: 0
 ```

2- *Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации. *

```
$ ip link add dummy0 type dummy
$ ip addr add 192.168.98.1/24 dev dummy0
$ ip link set dummy0 up

```
![image](https://user-images.githubusercontent.com/87389868/145684803-2cb185b6-575f-4c74-b821-6b78861f9b1b.png)
![image](https://user-images.githubusercontent.com/87389868/145684969-c7ee7b32-a924-4db9-a98d-3e00a877c2e4.png)



3- *Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров. *

![image](https://user-images.githubusercontent.com/87389868/145685719-d2052c4c-37ff-4fd4-a3fa-29013a7dc50b.png)
 На скриншоте сервер слушает 22 TCP порт ssh и DNS (domain) TCP 53

4- *Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты? *
![image](https://user-images.githubusercontent.com/87389868/145685719-d2052c4c-37ff-4fd4-a3fa-29013a7dc50b.png)
Сервер виртулаьный на EVE, открытых сокетов на udp приложениями нет. Только порт DNS 53 на UDP. 

5- *Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали. *
Диаграма домашней сети:
![image](https://user-images.githubusercontent.com/87389868/145686445-873e6944-4e8c-45f4-bcf1-8e3ac6ff7f6a.png)



