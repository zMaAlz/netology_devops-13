# Домашнее задание к занятию "09.03 CI\CD"


## Знакомоство с SonarQube

* Создан новый проект  "netology"

```bash
sonar-scanner \
  -Dsonar.projectKey=netology \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://192.168.121.87:9000 \
  -Dsonar.login=0a59cea1767db52ae51
```

* sonar-scanner --version

```bash
[admin@home ~]$ sonar-scanner --version
INFO: Scanner configuration file: /home/admin/exchange/SonarScanner/sonar-scanner-4.7.0.2747-linux/conf/sonar-scanner.properties
INFO: Project root configuration file: NONE
INFO: SonarScanner 4.7.0.2747
INFO: Java 11.0.14.1 Eclipse Adoptium (64-bit)
INFO: Linux 5.18.7-200.fc36.x86_64 amd64
```

* Запускаем анализатор против кода из директории example с дополнительным ключом -Dsonar.coverage.exclusions=fail.py

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

```bash
INFO: Analysis total time: 9.973 s
INFO: ------------------------------------------------------------------------
INFO: EXECUTION SUCCESS
INFO: ------------------------------------------------------------------------
INFO: Total time: 13.903s
INFO: Final Memory: 7M/30M
INFO: ------------------------------------------------------------------------
```

* Результат в интерфейсе

![1](https://user-images.githubusercontent.com/87389868/178056512-08f2b40d-f53e-4aea-876c-25d61b551f98.jpg)
 
* Исправляем ошибки, которые он выявил

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
![2](https://user-images.githubusercontent.com/87389868/178056583-73cd28a3-a8b4-4fad-a02e-0804ecee0a3d.jpg)


## Знакомство с Nexus

* В репозиторий maven-public загружено 2 артефакта с GAV параметрами:

groupId: netology
artifactId: java
version: 8_282
classifier: distrib
type: tar.gz


groupId: netology
artifactId: java
version: 8_102
classifier: distrib
type: tar.gz

* maven-metadata.xml для артефекта

```xml
<?xml version="1.0" encoding="UTF-8"?>
<metadata modelVersion="1.1.0">
  <groupId>netology</groupId>
  <artifactId>java</artifactId>
  <versioning>
    <latest>8_282</latest>
    <release>8_282</release>
    <versions>
      <version>8_102</version>
      <version>8_282</version>
    </versions>
    <lastUpdated>20220709113613</lastUpdated>
  </versioning>
</metadata>
```


## Знакомство с Maven


* Меняем в pom.xml блок с зависимостями под наш артефакт
```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
 
  <groupId>com.netology.app</groupId>
  <artifactId>simple-app</artifactId>
  <version>1.0-SNAPSHOT</version>
   <repositories>
    <repository>
      <id>my-repo</id>
      <name>maven-public</name>
      <url>http://192.168.121.165:8081/repository/maven-public/</url>
    </repository>
  </repositories>
  <dependencies>
    <dependency>
      <groupId>netology</groupId>
      <artifactId>java</artifactId>
      <version>8_282</version>
      <classifier>distrib</classifier>
      <type>tar.gz</type>
    </dependency>
  </dependencies>
</project>
```


* Запускаем команду mvn package 

```bash
WARNING] JAR will be empty - no content was marked for inclusion!
[INFO] Building jar: /home/admin/09-ci-03-cicd/mvn/target/simple-app-1.0-SNAPSHOT.jar
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  23.958 s
[INFO] Finished at: 2022-07-09T16:25:50+03:00
[INFO] ------------------------------------------------------------------------
```
