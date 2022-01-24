# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"

## Задача 1

Вопрос: Опишите своими словами основные преимущества применения на практике IaaC паттернов. Какой из принципов IaaC является основополагающим?

Ответ: главное преимущество использования на практине паттернов iaaC - это увеличение скорости разработки ПО. Как итог, конечные пользователи продукта быстрей получают обнолвения с новыми фитчами и исправления в случае выявления багов. Основопологающим, на мой взгляд, является - Continuous Integration.

## Задача 2

Вопрос: Чем Ansible выгодно отличается от других систем управление конфигурациями? Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

Ответ: Ansible можно использовать практически сразу после развертывания, т.к. он может использовать существующую ssh инфраструктуру. Низкий порог входа за счет использования формата YAML для описания конфигурации. А так же использование Push метода распространения конфигурации. На мой взгляд push метод более прозрачный, соединение инициирует сервер, в случае возникновения проблем или ошибок результат будет выведен сразу.

## Задача 3

Вопрос: Установить на личный компьютер: VirtualBox, Vagrant, Ansible. Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.

Ответ:

VirtualBox

![vb3](https://user-images.githubusercontent.com/87389868/150853329-90eb565f-7554-4a81-b7cf-ed208e0823e2.JPG)


Vagrant

```cmd
C:\Users\Admin>vagrant --version
Vagrant 2.2.18
```

Ansible

```bash
admin2@ubuntu-srv:~$ ansible --version
ansible 2.9.6
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/admin2/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']    
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.8.10 (default, Nov 26 2021, 20:14:08) [GCC 9.3.0]
```

## Задача 4

Вопрос: Воспроизвести практическую часть лекции самостоятельно. Создать виртуальную машину. Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды.

```bash
docker ps
```

Ответ:

```bash
admin2@ubuntu-srv:~/ansible$ ansible-playbook provision.yml --ask-pass
SSH password: 

PLAY [nodes] ***************************************************************************************
TASK [Gathering Facts] *****************************************************************************ok: [srv1.local]

TASK [Create directory for ssh-keys] ***************************************************************changed: [srv1.local]

TASK [Adding rsa-key in /root/.ssh/authorized_keys] ************************************************changed: [srv1.local]

TASK [Checking DNS] ********************************************************************************changed: [srv1.local]

TASK [Installing tools] ****************************************************************************ok: [srv1.local] => (item=['git', 'curl'])

TASK [Installing docker] ***************************************************************************changed: [srv1.local]

TASK [Add the current user to docker group] ********************************************************changed: [srv1.local]

PLAY RECAP *****************************************************************************************srv1.local                 : ok=7    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

vagrant@srv1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```
