# Домашнее задание к занятию "08.02 Работа с Playbook"

## Основная часть

- Приготовьте свой собственный inventory файл prod.yml.
- Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает vector.
- При создании tasks рекомендую использовать модули: get_url, template, unarchive, file.
- Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.
- Запустите ansible-lint site.yml и исправьте ошибки, если они есть.
- Попробуйте запустить playbook на этом окружении с флагом --check.
- Запустите playbook на prod.yml окружении с флагом --diff. Убедитесь, что изменения на системе произведены.
- Повторно запустите playbook с флагом --diff и убедитесь, что playbook идемпотентен.
- Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
- Готовый playbook выложите в свой репозиторий, поставьте тег 08-ansible-02-playbook на фиксирующий коммит, в ответ предоставьте ссылку на него.

В файл prod.yml добавлен хост и пользователь для подключения

```yaml
clickhouse:
  hosts:
    clickhouse:
      ansible_host: "192.168.1.90"
      ansible_user: "vagrant"
```


Playbook изменен, добалвена проверка на версию OS и play для устновки vector. При создание использовались все перечисленные модули, кроме unarchive.

```yaml
---
- name: Install Clickhouse
  hosts: clickhouse
  handlers:
    - name: Start clickhouse service
      become: true
      ansible.builtin.service:
        name: clickhouse-server
        state: restarted
  pre_tasks:
    - name: Save the contents of /etc/os-release
      command: cat /etc/os-release
      register: os_release
    - name: Detect CentOS Servers
      debug:
        msg: "Installing clickhouse on CentOS..."
      when: os_release.stdout.find('CentOS') != -1
    - block:
        - name: Get clickhouse distrib (RPM)
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm"
            dest: "./{{ item }}-{{ clickhouse_version }}.rpm"
          with_items: "{{ clickhouse_packages }}"
          when: os_release.stdout.find('CentOS') != -1
      rescue:
        - name: Get clickhouse distrib (RPM)
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-{{ clickhouse_version }}.x86_64.rpm"
            dest: "./clickhouse-common-static-{{ clickhouse_version }}.rpm"
          when: os_release.stdout.find('CentOS') != -1
      notify: Start clickhouse service
    - name: Install clickhouse packages (RPM)
      become: true
      ansible.builtin.yum:
        name:
          - clickhouse-common-static-{{ clickhouse_version }}.rpm
          - clickhouse-client-{{ clickhouse_version }}.rpm
          - clickhouse-server-{{ clickhouse_version }}.rpm
      when: os_release.stdout.find('CentOS') != -1
    - name: Pause
      pause:
        minutes: 1
  tasks:
    - block:
      - name: Create database
        ansible.builtin.command: "clickhouse-client -q 'create database logs;'"
        register: create_db
        failed_when: create_db.rc !=0 and create_db.rc !=82
        changed_when: create_db.rc ==0
      rescue:
      - name: start clickhouse-server
        become: true
        ansible.builtin.command: "systemctl start clickhouse-server.service"
      - name: Create database
        ansible.builtin.command: "clickhouse-client -q 'create database logs;'"
        register: create_db
        failed_when: create_db.rc !=0 and create_db.rc !=82
        changed_when: create_db.rc ==0
    - name: Create table logs.alerts
      ansible.builtin.command: "clickhouse-client -q 'create table logs.alerts (message String) ENGINE = TinyLog();' "
      register: create_table
      failed_when: create_table.rc !=0 and create_table.rc !=57
      changed_when: create_table.rc ==0
- name: Install vector
  hosts: clickhouse
  tasks:
    - name: Download vector
      ansible.builtin.get_url:
        url: "https://packages.timber.io/vector/latest/vector-{{ vector_version }}.x86_64.rpm"
        dest: "./vector-{{ vector_version }}.x86_64.rpm"
      when: os_release.stdout.find('CentOS') != -1
    - name: Install vector
      become: true
      ansible.builtin.yum:
        name:
          - vector-{{ vector_version }}.x86_64.rpm
    - name: Create folder config vector
      become: true
      ansible.builtin.command: "mkdir /usr/conf"
      register: folder
      failed_when: folder.rc !=1 and folder.rc !=0
    - name: Copy vector config
      become: true
      template:
        src: "templates/vector.toml"
        dest: "/usr/conf/vector.toml"
    - name: Change file permissions vector.toml
      become: true
      ansible.builtin.file:
        path: "/usr/conf/vector.toml"
        state: touch
        mode: "0765"
    - name: Testing vector
      ansible.builtin.shell: "echo 'Hello world!' | vector --config /usr/conf/vector.toml"

```

Ansible-list при первом запуске выявил ошибки.

```bash
admin2@ubuntu-srv:/mnt/shares/Git/test-repo-ansible2$ ansible-lint site.yml 
[301] Commands should not change things if nothing needs doing
site.yml:11
Task/Handler: Save the contents of /etc/os-release

[602] Don't compare to empty string
site.yml:70
      failed_when: add_repo.stderr !=""
```


https://github.com/zMaAlz/test-repo-ansible2