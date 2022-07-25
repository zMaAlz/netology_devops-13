# Домашнее задание к занятию "09.06 Gitlab"

## DevOps

В репозитории содержится код проекта на python. Проект - RESTful API сервис. Ваша задача автоматизировать сборку образа с выполнением python-скрипта:

Образ собирается на основе centos:7
Python версии не ниже 3.7
Установлены зависимости: flask flask-jsonpify flask-restful
Создана директория /python_api
Скрипт из репозитория размещён в /python_api
Точка вызова: запуск скрипта
Если сборка происходит на ветке master: должен подняться pod kubernetes на основе образа python-api, иначе этот шаг нужно пропустить


```dockerfile
FROM centos:centos7
COPY ./src/CentOS-Base.repo etc/yum.repos.d/
RUN yum install -y python3
RUN pip3 install flask && \
    pip3 install flask-jsonpify && \
    pip3 install flask-restful
RUN mkdir /restfullapi
COPY ./src/python-api.py /restfullapi
WORKDIR /restfullapi
CMD [ "python3", "python-api.py" ]
```
