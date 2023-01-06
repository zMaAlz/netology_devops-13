# Домашнее задание к занятию "14.3 Карты конфигураций"

## Задача 1: Работа с картами конфигураций через утилиту kubectl

**Как создать карту конфигураций?**

```bash
[dev1@kingdom src]$ kubectl create configmap nginx-config --from-file=nginx.conf
configmap/nginx-config created
[dev1@kingdom src]$ kubectl create configmap domain --from-literal=name=netology.ru
configmap/domain created

```

**Как просмотреть список карт конфигураций?**

```bash
[dev1@kingdom src]$ kubectl get configmap
NAME               DATA   AGE
domain             1      80s
kube-root-ca.crt   1      3d14h
nginx-config       1      2m46s

```

**Как просмотреть карту конфигурации?**

```bash
[dev1@kingdom src]$ kubectl get configmap nginx-config
NAME           DATA   AGE
nginx-config   1      3m32s
[dev1@kingdom src]$ kubectl describe configmap domain
Name:         domain
Namespace:    stage
Labels:       <none>
Annotations:  <none>

Data
====
name:
----
netology.ru

BinaryData
====

Events:  <none>

```


**Как получить информацию в формате YAML и/или JSON?**

```bash
[dev1@kingdom src]$ kubectl get configmap nginx-config -o yaml
apiVersion: v1
data:
  nginx.conf: |-
    server {
        listen 80;
        server_name  netology.ru www.netology.ru;
        access_log  /var/log/nginx/domains/netology.ru-access.log  main;
        error_log   /var/log/nginx/domains/netology.ru-error.log info;
        location / {
            include proxy_params;
            proxy_pass http://10.10.10.10:8080/;
        }
    }
kind: ConfigMap
metadata:
  creationTimestamp: "2023-01-06T08:35:41Z"
  name: nginx-config
  namespace: stage
  resourceVersion: "150618"
  uid: 5931858a-9f70-4325-9d3f-49c87f5c1e1a

[dev1@kingdom src]$ kubectl get configmap domain -o json
{
    "apiVersion": "v1",
    "data": {
        "name": "netology.ru"
    },
    "kind": "ConfigMap",
    "metadata": {
        "creationTimestamp": "2023-01-06T08:37:07Z",
        "name": "domain",
        "namespace": "stage",
        "resourceVersion": "150792",
        "uid": "9c66ce8f-3091-46ec-8a68-2d1fbd4c4680"
    }
}

```

**Как выгрузить карту конфигурации и сохранить его в файл?**

```bash
[dev1@kingdom ~]$ kubectl get configmaps -o json > configmaps.json
[dev1@kingdom ~]$ kubectl get configmap nginx-config -o yaml > nginx-config.yml
[dev1@kingdom ~]$ ls -lh
итого 8,0K
-rw-r--r--. 1 dev1 dev1 3,2K янв  6 11:41 configmaps.json
-rw-r--r--. 1 dev1 dev1  566 янв  6 11:42 nginx-config.yml

```

**Как удалить карту конфигурации?**

```bash
[dev1@kingdom ~]$ kubectl delete configmap nginx-config
configmap "nginx-config" deleted
[dev1@kingdom ~]$ kubectl get configmaps
NAME               DATA   AGE
domain             1      6m27s
kube-root-ca.crt   1      3d14h

```

**Как загрузить карту конфигурации из файла?**

```bash

[dev1@kingdom ~]$ kubectl apply -f nginx-config.yml
configmap/nginx-config created
[dev1@kingdom ~]$ kubectl get configmaps
NAME               DATA   AGE
domain             1      6m52s
kube-root-ca.crt   1      3d14h
nginx-config       1      2s

```

## Задача 2 (*): Работа с картами конфигураций внутри модуля

<details>

Выбрать любимый образ контейнера, подключить карты конфигураций и проверить их доступность как в виде переменных окружения, так и в виде примонтированного тома

</details>

```bash
[dev1@kingdom src]$ kubectl apply -f nginx-config.yaml 
configmap/nginx-config created
[dev1@kingdom src]$ kubectl apply -f app-pod.yml 
pod/netology-14.3 created
[dev1@kingdom src]$ kubectl get po -o wide
NAME            READY   STATUS    RESTARTS   AGE   IP               NODE        NOMINATED NODE   READINESS GATES
netology-14.3   1/1     Running   0          37s   10.233.107.133   kubenode2   <none>           <none>
[dev1@kingdom src]$ kubectl exec -it netology-14.3 -- /bin/bash
[root@netology-14 /]# echo $SPECIAL_LEVEL_KEY
server { listen 80; server_name netology.ru www.netology.ru; access_log /var/log/nginx/domains/netology.ru-access.log main; error_log /var/log/nginx/domains/netology.ru-error.log info; location / { include proxy_params; proxy_pass http://localhost:80/; } }
[root@netology-14 /]# ls -lh /etc/nginx/conf.d
lrwxrwxrwx. 1 root root 17 Jan  6 09:02 nginx.conf -> ..data/nginx.conf
[root@netology-14 /]# cat /etc/nginx/conf.d/nginx.conf 
server {
    listen 80;
    server_name  netology.ru www.netology.ru;
    access_log  /var/log/nginx/domains/netology.ru-access.log  main;
    error_log   /var/log/nginx/domains/netology.ru-error.log info;
    location / {
        include proxy_params;
        proxy_pass http://localhost:80/;
    }

```