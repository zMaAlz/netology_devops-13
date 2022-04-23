Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"
---------------------------------------------------------------------------------------

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | Возникнет ошибка, т.к. мы пытаемся сложить стороку с цислом (TypeError: unsupported operand type(s) for +: 'int' and 'str')  |
| Как получить для переменной `c` значение 12?  |  Принудительно задать тип данных в переменной "а" (c = str(a) + b)  |
| Как получить для переменной `c` значение 3?  | Принудительно задать тип данных в переменной "b" (c = a + int(b)) |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3
import os
path_repo="/mnt/shares/Git/scripts/"
bash_command = [f"cd {path_repo}", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
print('Modified:')
for result in result_os.split('\n'):
    if result.find('modified') == 1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(path_repo+prepare_result)
print('New files:')
for result in result_os.split('\n'):
    if result.find('new file') == 1:
        new_result = result.replace('\tnew file:   ', '')
        print(path_repo+new_result)
        
```

### Вывод скрипта при запуске при тестировании:
```bash
admin2@ubuntu-srv:/mnt/shares/Git/scripts$ git status
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        new file:   KillSAP.py
        new file:   ch_file_repo.py
        new file:   new/Ping.py
        new file:   test_ping.sh
        new file:   test_url.sh

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   ch_file_repo.py
        modified:   new/Ping.py

admin2@ubuntu-srv:/mnt/shares/Git/scripts$ python3 ch_file_repo.py
Modified:
/mnt/shares/Git/scripts/ch_file_repo.py
/mnt/shares/Git/scripts/new/Ping.py
New files:
/mnt/shares/Git/scripts/KillSAP.py
/mnt/shares/Git/scripts/ch_file_repo.py
/mnt/shares/Git/scripts/new/Ping.py
/mnt/shares/Git/scripts/test_ping.sh
/mnt/shares/Git/scripts/test_url.sh
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3
import os
path_repo=input("Укажите путь к репозиторию: ")
bash_command = [f"cd {path_repo}", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
print('Modified:')
for result in result_os.split('\n'):
    if result.find('modified') == 1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(path_repo+prepare_result)
print('New files:')
for result in result_os.split('\n'):
    if result.find('new file') == 1:
        new_result = result.replace('\tnew file:   ', '')
        print(path_repo+new_result)
        
```

### Вывод скрипта при запуске при тестировании:
```
admin2@ubuntu-srv:/mnt/shares/Git/scripts$ python3 ch_file_repo.py
Укажите путь к репозиторию: /mnt/shares/Git/scripts
Modified:
/mnt/shares/Git/scriptsch_file_repo.py
/mnt/shares/Git/scriptsnew/Ping.py
New files:
/mnt/shares/Git/scriptsKillSAP.py
/mnt/shares/Git/scriptsch_file_repo.py
/mnt/shares/Git/scriptsnew/Ping.py
/mnt/shares/Git/scriptstest_ping.sh
/mnt/shares/Git/scriptstest_url.sh
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
#!/usr/bin/env python3
import os
def dnstoip (name):
    ipaddres = os.popen('nslookup ' + name).read()
    listns = ipaddres.split('\n')
    return listns[5]

def file_open_write (name):
    fileIp = open('ipsrv.csv', 'a')
    writetofile = name + '/n'
    fileIp.write(writetofile)
    fileIp.close()
    return print(f'данные {name} записаны')

DNSdict = {}


if os.path.isfile('ipsrv.csv') == False:
    delfile = open('ipsrv.csv', 'w')
    delfile.close()
else:
    dictfile = open('ipsrv.csv', 'r').read().split('/n')
    #print("dictfile ",dictfile)
    for a in dictfile:
        lista = a.split(" ")
        #print(lista[0])
        #print(lista[-1])
        DNSdict[lista[0]] = lista[-1]

address_srv = ['drive.google.com', 'googlemail.l.google.com', 'google.com']

print('Прошлые адреса: ',DNSdict)
print('*********************************')
for i in address_srv:
    addres_and_ip = dnstoip(i)
    ip_without_addres = addres_and_ip.replace('Address: ', '')
    if i in DNSdict.keys():
        if ip_without_addres != DNSdict[i]:
            print(f'[ERROR] {i} IP mismatch: {DNSdict[i]} {ip_without_addres}')
            forfile = i + " " + ip_without_addres
            file_open_write(forfile)
        else:
            print(f"IP адрес у {i} не изменился")
    else:
        forfile = i + " " + ip_without_addres
        file_open_write(forfile)

#os.system('echo -n >ipsrv.csv')

```

### Вывод скрипта при запуске при тестировании:
```bash
admin2@ubuntu-srv:/mnt/shares/Git/scripts$ python3 chek_ip.py
Прошлые адреса:  {'': ''}
*********************************
данные drive.google.com 142.251.1.139 записаны
данные googlemail.l.google.com 64.233.161.17 записаны
данные google.com 108.177.14.101 записаны
admin2@ubuntu-srv:/mnt/shares/Git/scripts$ python3 chek_ip.py
Прошлые адреса:  {'drive.google.com': '142.251.1.139', 'googlemail.l.google.com': '64.233.161.17', 'google.com': '108.177.14.101', '': ''}
*********************************
IP адрес у drive.google.com не изменился
IP адрес у googlemail.l.google.com не изменился
[ERROR] google.com IP mismatch: 108.177.14.101 108.177.14.138
данные google.com 108.177.14.138 записаны
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так получилось, что мы очень часто вносим правки в конфигурацию своей системы прямо на сервере. Но так как вся наша команда разработки держит файлы конфигурации в github и пользуется gitflow, то нам приходится каждый раз переносить архив с нашими изменениями с сервера на наш локальный компьютер, формировать новую ветку, коммитить в неё изменения, создавать pull request (PR) и только после выполнения Merge мы наконец можем официально подтвердить, что новая конфигурация применена. Мы хотим максимально автоматизировать всю цепочку действий. Для этого нам нужно написать скрипт, который будет в директории с локальным репозиторием обращаться по API к github, создавать PR для вливания текущей выбранной ветки в master с сообщением, которое мы вписываем в первый параметр при обращении к py-файлу (сообщение не может быть пустым). При желании, можно добавить к указанному функционалу создание новой ветки, commit и push в неё изменений конфигурации. С директорией локального репозитория можно делать всё, что угодно. Также, принимаем во внимание, что Merge Conflict у нас отсутствуют и их точно не будет при push, как в свою ветку, так и при слиянии в master. Важно получить конечный результат с созданным PR, в котором применяются наши изменения. 

### Ваш скрипт:
```python
???
```

### Вывод скрипта при запуске при тестировании:
```
???
```
