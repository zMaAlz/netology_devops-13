# Домашнее задание к занятию "13.1 контейнеры, поды, deployment, statefulset, services, endpoints"

## Задание 1: подготовить тестовый конфиг для запуска приложения

<details>

Для начала следует подготовить запуск [приложения](https://github.com/netology-code/devkub-homeworks/tree/main/13-kubernetes-config) в stage окружении с простыми настройками. Требования:

* под содержит в себе 2 контейнера — фронтенд, бекенд;
* регулируется с помощью deployment фронтенд и бекенд;
* база данных — через statefulset.

</details>


Контейнеры [бекенд](https://hub.docker.com/repository/docker/zmaalz/backend), [фронтенд](https://hub.docker.com/repository/docker/zmaalz/frontend), загружены в docker hub. Для развертывания в кластере kubernetes создан манифест [stage.yaml](stage/stage.yaml)

```bash
[dev1@kingdom stage]$ kubectl apply -f stage.yaml 
namespace/stage created
deployment.apps/stage-front-back created
deployment.apps/stage-db created
persistentvolumeclaim/pvc-stage-db created
persistentvolume/pv-stage-db created
secret/postgres-secret-stage created

[dev1@kingdom stage]$ kubectl -n stage get pod
NAME                                READY   STATUS    RESTARTS   AGE
stage-db-79795847f9-jzkvd           1/1     Running   0          44s
stage-front-back-7cc64dc965-7mql9   2/2     Running   0          44s
stage-front-back-7cc64dc965-hkgqz   2/2     Running   0          43s


[dev1@kingdom stage]$ kubectl -n stage describe pod stage-front-back-7cc64dc965-hkgqz
Name:             stage-front-back-7cc64dc965-hkgqz
Namespace:        stage
Service Account:  default
Node:             kubenode2/192.168.121.2
Start Time:       Thu, 29 Dec 2022 16:25:28 +0300
Labels:           app=stage-front-back
                  pod-template-hash=7cc64dc965
Status:           Running
IP:               10.233.107.157
Controlled By:  ReplicaSet/stage-front-back-7cc64dc965
Containers:
  stage-frontend:
    Container ID:   containerd://2267b480a473049e1d387623d07cab841d13c063078a6a8ecdf884b362f28197
    Image:          zmaalz/frontend:latest
    State:          Running
      Started:      Thu, 29 Dec 2022 16:25:43 +0300
    Limits:
      cpu:     500m
      memory:  2Gi
    Requests:
      cpu:        200m
      memory:     512Mi
    Mounts:
      /cache from cache-volume (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-xqgph (ro)
  stage-backend:
    Container ID:   containerd://66424225c3e8f6945e7ad5ef29d559141a622782edeefb2fdd25664c0ae7238e
    Image:          zmaalz/backend:latest
    State:          Running
      Started:      Thu, 29 Dec 2022 16:25:48 +0300
    Mounts:
      /cache from cache-volume (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-xqgph (ro)
Volumes:
  cache-volume:
    Type:       EmptyDir (a temporary directory that shares a pod lifetime)
    Medium:     
    SizeLimit:  <unset>

[dev1@kingdom stage]$ kubectl -n stage get deploy
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
stage-db           1/1     1            1           66s
stage-front-back   2/2     2            2           67s

[dev1@kingdom stage]$ kubectl -n stage get pv
NAME          CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                STORAGECLASS   REASON   AGE
pv-stage-db   5Gi        RWO            Delete           Bound    stage/pvc-stage-db                           79s

[dev1@kingdom stage]$ kubectl -n stage get pvc
NAME           STATUS   VOLUME        CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pvc-stage-db   Bound    pv-stage-db   5Gi        RWO                           81s

```

## Задание 2: подготовить конфиг для production окружения

<details>

Следующим шагом будет запуск приложения в production окружении. Требования сложнее:

каждый компонент (база, бекенд, фронтенд) запускаются в своем поде, регулируются отдельными deployment’ами;
для связи используются service (у каждого компонента свой);
в окружении фронта прописан адрес сервиса бекенда;
в окружении бекенда прописан адрес сервиса базы данных.

</details>

Для развертывания в production окружении создан манифест [prod.yaml](prod/prod.yaml).

```bash
[dev1@kingdom prod]$ kubectl apply -f prod.yaml 
namespace/prod created
deployment.apps/prod-front created
service/prod-front created
deployment.apps/prod-back created
service/prod-back created
deployment.apps/prod-db created
service/prod-db created
persistentvolumeclaim/pvc-prod-db created
persistentvolume/pv-prod-db created
secret/postgres-secret-prod created

[dev1@kingdom prod]$ kubectl -n prod get pod
NAME                         READY   STATUS    RESTARTS   AGE
prod-back-5b4cbf4ff8-dncxm   1/1     Running   0          73s
prod-back-5b4cbf4ff8-zxzgv   1/1     Running   0          72s
prod-db-ff7989d8-h5zwk       1/1     Running   0          67s
prod-front-c8895d844-m2dbb   1/1     Running   0          76s
prod-front-c8895d844-t7t8q   1/1     Running   0          76s

[dev1@kingdom prod]$ kubectl -n prod get deploy
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
prod-back    2/2     2            2           94s
prod-db      1/1     1            1           88s
prod-front   2/2     2            2           97s

[dev1@kingdom prod]$ kubectl -n prod get svc
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
prod-back    ClusterIP   10.233.23.44    <none>        9000/TCP         109s
prod-db      ClusterIP   10.233.24.218   <none>        5432/TCP         103s
prod-front   NodePort    10.233.37.90    <none>        8000:31146/TCP   113s

[dev1@kingdom prod]$ kubectl -n prod get pvc
NAME          STATUS   VOLUME       CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pvc-prod-db   Bound    pv-prod-db   5Gi        RWO                           2m18s

[dev1@kingdom prod]$ kubectl -n prod get pv
NAME         CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM              STORAGECLASS   REASON   AGE
pv-prod-db   5Gi        RWO            Delete           Bound    prod/pvc-prod-db                           2m20s

```


## Задание 3 (*): добавить endpoint на внешний ресурс api

<details>

Приложению потребовалось внешнее api, и для его использования лучше добавить endpoint в кластер, направленный на это api. Требования:

* добавлен endpoint до внешнего api (например, геокодер).

</details>

Для развертывания в production окружении Service с EndpointSlices для пересылки запросов к внешнему ресуру создан [ep.yaml](EndpointSlices/ep.yaml).

```bash
[dev1@kingdom endpoint]$ kubectl apply -f ep.yaml 
service/ext-api unchanged
endpointslice.discovery.k8s.io/ext-api-ep created

[dev1@kingdom endpoint]$ kubectl -n prod get svc
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
ext-api      ClusterIP   10.233.1.18     <none>        443/TCP          5m13s
prod-back    ClusterIP   10.233.33.154   <none>        9000/TCP         14m
prod-db      ClusterIP   10.233.34.28    <none>        5432/TCP         14m
prod-front   NodePort    10.233.19.69    <none>        8000:30785/TCP   14m

[dev1@kingdom endpoint]$ kubectl -n prod get endpointslice
NAME               ADDRESSTYPE   PORTS   ENDPOINTS                      AGE
ext-api-ep         FQDN          443     geocode-maps.yandex.ru         54s
prod-back-drvr7    IPv4          9000    10.233.110.89,10.233.107.160   14m
prod-db-plnj9      IPv4          5432    10.233.107.161                 14m
prod-front-vz276   IPv4          80      10.233.110.88,10.233.107.159   14m

```