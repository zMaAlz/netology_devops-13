# Домашнее задание к занятию "7.1. Инфраструктура как код"

## Задача 1. Выбор инструментов

В: Для этого в рамках совещания надо будет выяснить подробности о проекте, что бы в итоге определиться с инструментами:

- Какой тип инфраструктуры будем использовать для этого проекта: изменяемый или не изменяемый?
- Будет ли центральный сервер для управления инфраструктурой?
- Будут ли агенты на серверах?
- Будут ли использованы средства для управления конфигурацией или инициализации ресурсов?

О: Т.к. проект будет активно меняться и нет понимания в какую именно сторону (отсутсвие ТЗ), то, на мой взгляд, необходимо остановиться на минимально необходимом наборе инструментов. Packer + terraform помогут создать неизменяемый тип инфраструктуры, что обеспечит идемпотентность среды в условихя активного развития продукта, а также обеспечит скорость подготовки этой среды. Сам код (сервис) будет работать в Docker контейнерах. В дальнейшем, при увеличении количества клиентов и масштабирование сервиса можно будет добавить kubernetis для контроля конфигураций и Teamcity для автоматизации процесса выкадки в предпрод и возможно прод.

## Задача 2. Установка терраформ

```bash
admin2@ubuntu-srv:~/terraform$ terraform --version
Terraform v1.1.5
on linux_amd64
+ provider registry.terraform.io/hashicorp/local v2.1.0
+ provider registry.terraform.io/hashicorp/null v3.1.0
+ provider registry.terraform.io/yandex-cloud/yandex v0.71.0
```

## Задача 3. Поддержка легаси кода

```bash
admin2@ubuntu-srv:~/$ terraform --version
Terraform v1.1.5
on linux_amd64

Your version of Terraform is out of date! The latest version
is 1.1.8. You can update by downloading from https://www.terraform.io/downloads.html

admin2@ubuntu-srv:~/$ terraform013 --version
Terraform v0.13.7

Your version of Terraform is out of date! The latest version
is 1.1.8. You can update by downloading from https://www.terraform.io/downloads.html
```
