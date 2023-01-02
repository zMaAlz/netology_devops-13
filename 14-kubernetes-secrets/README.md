# Домашнее задание к занятию "14.1 Создание и использование секретов"

## Задача 1: Работа с секретами через утилиту kubectl

**Создание секрета**

```bash
[dev1@kingdom secret]$ openssl genrsa -out cert.key 4096
[dev1@kingdom secret]$ openssl req -x509 -new -key cert.key -days 3650 -out cert.crt -subj '/C=RU/ST=Moscow/L=Moscow/CN=netology.local'

[dev1@kingdom secret]$ kubectl create secret tls domain-cert --cert=cert.crt --key=cert.key
secret/domain-cert created

```

**Список секретов**

```bash
[dev1@kingdom secret]$ kubectl get secrets
NAME                               TYPE                 DATA   AGE
domain-cert                        kubernetes.io/tls    2      2m11s
postgres-secret                    Opaque               3      3d17h
sh.helm.release.v1.nfs-server.v1   helm.sh/release.v1   1      2d19h

```
**Просмотр секрета**

```bash
[dev1@kingdom secret]$ kubectl get secret domain-cert
NAME          TYPE                DATA   AGE
domain-cert   kubernetes.io/tls   2      3m8s

[dev1@kingdom secret]$ kubectl describe secret domain-cert
Name:         domain-cert
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  kubernetes.io/tls

Data
====
tls.crt:  1948 bytes
tls.key:  3268 bytes

```
**Информация в YAML|JSON**

```bash
[dev1@kingdom secret]$ kubectl get secret domain-cert -o yaml
apiVersion: v1
data:
  tls.crt: LS0**tCg==
  tls.key: LS0**tCg==
kind: Secret
metadata:
  creationTimestamp: "2023-01-01T12:41:03Z"
  name: domain-cert
  namespace: default
  resourceVersion: "111667"
  uid: 821c65c1-f74e-4087-9424-5ca8d4457ecb
type: kubernetes.io/tls

[dev1@kingdom secret]$ kubectl get secret domain-cert -o json
{
    "apiVersion": "v1",
    "data": {
        "tls.crt": "LS0**tCg==",
        "tls.key": "LS0**tCg=="
    },
    "kind": "Secret",
    "metadata": {
        "creationTimestamp": "2023-01-01T12:41:03Z",
        "name": "domain-cert",
        "namespace": "default",
        "resourceVersion": "111667",
        "uid": "821c65c1-f74e-4087-9424-5ca8d4457ecb"
    },
    "type": "kubernetes.io/tls"
}
```

**Выгрузка секрета в файл**

```bash
[dev1@kingdom secret]$ kubectl get secrets -o json > secrets.json
[dev1@kingdom secret]$ kubectl get secret domain-cert -o yaml > domain-cert.yml

[dev1@kingdom secret]$ ls -lh
итого 37K
-rw-r--r--. 1 dev1 dev1 7,1K янв  1 15:49 domain-cert.yml
-rw-r--r--. 1 dev1 dev1  30K янв  1 15:48 secrets.json

```
**Удаление секрета**

```bash
[dev1@kingdom secret]$ kubectl delete secret domain-cert
secret "domain-cert" deleted
```
**Загрузка секрета из файла**

```bash
[dev1@kingdom secret]$ kubectl apply -f domain-cert.yml
secret/domain-cert created
```


## Задача 2 (*): Работа с секретами внутри модуля

<details>
Выберите любимый образ контейнера, подключите секреты и проверьте их доступность как в виде переменных окружения, так и в виде примонтированного тома.
</details>

Созданы 2 секрета ([sec1](src/sec-env.yaml), [sec2](src/sec.yaml)) и добавлены в [манифест](src/pod.yml) пода. 

```bash
[dev1@kingdom src]$ kubectl exec -it multitool -- /bin/bash
bash-5.1# echo $TEST_ENV
Hello_ENV
bash-5.1# ls -lh /opt/secret/
total 0      
lrwxrwxrwx    1 root     root          24 Jan  2 15:45 POSTGRES_PASSWORD -> ..data/POSTGRES_PASSWORD
lrwxrwxrwx    1 root     root          20 Jan  2 15:45 POSTGRES_USER -> ..data/POSTGRES_USER
bash-5.1# cat /opt/secret/POSTGRES_USER 
postgres

```