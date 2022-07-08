# Домашнее задание к занятию "09.03 CI\CD"

## Подготовка к выполнению

* Создаём 2 VM в yandex cloud со следующими параметрами: 2CPU 4RAM Centos7(остальное по минимальным требованиям)
* Прописываем в inventory playbook'a созданные хосты
* Добавляем в files файл со своим публичным ключом (id_rsa.pub). Если ключ называется иначе - найдите таску в плейбуке, которая использует id_rsa.pub имя и исправьте на своё
* Запускаем playbook, ожидаем успешного завершения
* Проверяем готовность Sonarqube через браузер
* Заходим под admin\admin, меняем пароль на свой
* Проверяем готовность Nexus через бразуер
* Подключаемся под admin\admin123, меняем пароль, сохраняем анонимный доступ

## Знакомоство с SonarQube

* Создаём новый проект, название произвольное
* Скачиваем пакет sonar-scanner, который нам предлагает скачать сам sonarqube

```bash
sonar-scanner \
  -Dsonar.projectKey=netology \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://192.168.121.87:9000 \
  -Dsonar.login=0a59cea1aaef67179aa82bba41762767db52ae51
```

* Делаем так, чтобы binary был доступен через вызов в shell (или меняем переменную PATH или любой другой удобный вам способ)
* Проверяем sonar-scanner --version

```bash
[admin@home ~]$ sonar-scanner --version
INFO: Scanner configuration file: /home/admin/exchange/SonarScanner/sonar-scanner-4.7.0.2747-linux/conf/sonar-scanner.properties
INFO: Project root configuration file: NONE
INFO: SonarScanner 4.7.0.2747
INFO: Java 11.0.14.1 Eclipse Adoptium (64-bit)
INFO: Linux 5.18.7-200.fc36.x86_64 amd64
```

* Запускаем анализатор против кода из директории example с дополнительным ключом -Dsonar.coverage.exclusions=fail.py

```bash
INFO: Analysis total time: 9.973 s
INFO: ------------------------------------------------------------------------
INFO: EXECUTION SUCCESS
INFO: ------------------------------------------------------------------------
INFO: Total time: 13.903s
INFO: Final Memory: 7M/30M
INFO: ------------------------------------------------------------------------
```
* Смотрим результат в интерфейсе

```py
def increment(index):
    index =+ 1
    return index
def get_square(numb):
    return numb*numb
def print_numb(numb):
    print("Number is {}".format(numb))
    pass

index = 0
while (index < 10):
    index = increment(index)
    print(get_square(index))
```

* Исправляем ошибки, которые он выявил(включая warnings)

```py
def increment(index):
    index += 1
    return index
def get_square(numb):
    return numb*numb
def print_numb(numb):
    print("Number is {}".format(numb))


index = 0
while (index < 10):
    index = increment(index)
    print(get_square(index))
```

* Запускаем анализатор повторно - проверяем, что QG пройдены успешно
* Делаем скриншот успешного прохождения анализа, прикладываем к решению ДЗ

## Знакомство с Nexus

* В репозиторий maven-public загружаем артефакт с GAV параметрами:
groupId: netology
artifactId: java
version: 8_282
classifier: distrib
type: tar.gz
* В него же загружаем такой же артефакт, но с version: 8_102
* Проверяем, что все файлы загрузились успешно
* В ответе присылаем файл maven-metadata.xml для этого артефекта

## Знакомство с Maven

### Подготовка к выполнению
Скачиваем дистрибутив с maven
Разархивируем, делаем так, чтобы binary был доступен через вызов в shell (или меняем переменную PATH или любой другой удобный вам способ)
Удаляем из apache-maven-<version>/conf/settings.xml упоминание о правиле, отвергающем http соединение( раздел mirrors->id: my-repository-http-unblocker)
Проверяем mvn --version
Забираем директорию mvn с pom
### Основная часть
Меняем в pom.xml блок с зависимостями под наш артефакт из первого пункта задания для Nexus (java с версией 8_282)
Запускаем команду mvn package в директории с pom.xml, ожидаем успешного окончания
Проверяем директорию ~/.m2/repository/, находим наш артефакт
В ответе присылаем и


