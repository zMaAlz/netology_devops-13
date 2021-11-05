Домашнее задание к занятию "3.4. Операционные системы, лекция 2"
----------------------------------------------------------------

1- *На лекции мы познакомились с node_exporter. В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой unit-файл для node_exporter*

Создаем файл в /etc/systemd/system/node_exporter.service
Содержание:
[Unit]
Description=Metric collector
#Documentation=

[Service]
EnvironmentFile=-/home/vagrant/node_exporter-1.2.2.linux-amd64/node.config
WorkingDirectory=/home/vagrant/node_exporter-1.2.2.linux-amd64
ExecStart=/home/vagrant/node_exporter-1.2.2.linux-amd64/node_exporter
KillMode=process
Restart=on-failure
User=vagrant

[Install]
WantedBy=multi-user.target

добавляем в автозапуск systemctl enable node_exporter.service

![image](https://user-images.githubusercontent.com/87389868/140399226-796a9345-3238-49f2-8907-8cabaac1d451.png)


2- *Ознакомьтесь с опциями node_exporter и выводом /metrics по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.*

* cpu -	Exposes CPU statistics
* loadavg -	Exposes load average.
* diskstats -	Exposes disk I/O statistics.
* filesystem -	Exposes filesystem statistics, such as disk space used.
* meminfo	- Exposes memory statistics.
* netstat	- Exposes network statistics from /proc/net/netstat. This is the same information as netstat -s.


3- *Установите в свою виртуальную машину Netdata. Воспользуйтесь готовыми пакетами для установки (sudo apt install -y netdata).*



4- *Можно ли по выводу dmesg понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?*



5- *Как настроен sysctl fs.nr_open на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (ulimit --help)?*



6- *Запустите любой долгоживущий процесс (не ls, который отработает мгновенно, а, например, sleep 1h) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через nsenter. Для простоты работайте в данном задании под root (sudo -i). Под обычным пользователем требуются дополнительные опции (--map-root-user) и т.д.*



7- *Найдите информацию о том, что такое :(){ :|:& };:. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (это важно, поведение в других ОС не проверялось). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов dmesg расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?*


