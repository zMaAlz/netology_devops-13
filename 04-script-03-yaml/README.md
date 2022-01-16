Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"
------------------------------------------------------------

## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```json
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip" : "71.78.22.43"
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

Ответ: пропущены кавычки в строке  "ip" : "71.78.22.43".

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3
from multiprocessing import Value
import socket
import os
import json
import yaml

def dnstoip (name):
    try:
        ip_adr = socket.gethostbyname(name)
    except NameError:
        ip_adr = "Имя не отвечает"
    except socket.gaierror:
        ip_adr = "Имя не отвечает"
    return ip_adr

def file_open_write (name):
    fileIp = open('ipsrv.csv', 'w')
    fileIp.close()
    fileIp = open('ipsrv.csv', 'a')
    for key, value in name.items():
        writetofile = key + " " + value + ';'
        fileIp.write(writetofile)
    fileIp.close()
    return

def file_write_json (name):
    fileIp = open('ipsrv.json', 'w')
    listyaml = []
    for key, value in name.items():
        dir={}
        dir[key] = value
        listyaml.append(dir)
    yamlfile = {'site': listyaml}
    json.dump(yamlfile, fileIp, indent=2)
    fileIp.close()
    return  

def file_write_yaml (name):
    fileIp = open('ipsrv.yml', 'w')
    listyaml = []
    for key, value in name.items():
        dir={}
        dir[key] = value
        listyaml.append(dir)
    yamlfile = {'site': listyaml}
    yaml.dump(yamlfile, fileIp, explicit_start=True, explicit_end=True, indent=2)
    fileIp.close()
    return  


DNSdict = {}

if os.path.isfile('ipsrv.csv') == False:
    delfile = open('ipsrv.csv', 'w')
    delfile.close()
else:
    dictfile = open('ipsrv.csv', 'r').read().split(';')
    #print("dictfile ",dictfile)
    for a in dictfile:
        lista = a.split(" ")
        #print(lista[0])
        #print(lista[-1])
        DNSdict[lista[0]] = lista[-1]

address_srv = ['drive.google.com', 'mail.google.com', 'google.com']

for i in address_srv:
    addres_and_ip = dnstoip(i)
    if i in DNSdict.keys():
        if addres_and_ip != DNSdict[i]:
            print(f'[ERROR] {i} IP mismatch: {DNSdict[i]} {addres_and_ip}')
            DNSdict[i] = addres_and_ip
        else:
            print(i + " - " + addres_and_ip)
    else:
        DNSdict[i] = addres_and_ip
        print(i + " - " + addres_and_ip)
del DNSdict[""]
#print(DNSdict)
file_open_write(DNSdict)
file_write_json(DNSdict)
file_write_yaml(DNSdict)
```

### Вывод скрипта при запуске при тестировании:
```cmd
D:\Git\scripts> d: && cd d:\Git\scripts && cmd /C "C:\ProgramData\Anaconda3\python.exe c:\Users\Admin\.vscode\extensions\ms-python.python-2021.12.1559732655\pythonFiles\lib\python\debugpy\launcher 62600 -- d:\Git\scripts\dns_to_ip.py "
drive.google.com - 64.233.165.102
mail.google.com - 64.233.161.17
google.com - 108.177.14.101

```

### json-файл(ы), который(е) записал ваш скрипт:
```json
{
  "site": [
    {
      "drive.google.com": "64.233.165.102"
    },
    {
      "mail.google.com": "64.233.161.17"
    },
    {
      "google.com": "108.177.14.101"
    }
  ]
}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
---
site:
- drive.google.com: 64.233.165.102
- mail.google.com: 64.233.161.17
- google.com: 108.177.14.101
...

```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
   * Принимать на вход имя файла
   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

### Ваш скрипт:
```python
???
```

### Пример работы скрипта:
???
