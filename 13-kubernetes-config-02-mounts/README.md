# Домашнее задание к занятию "13.2 разделы и монтирование"

## Задание 1: подключить для тестового конфига общую папку

<details>

В stage окружении часто возникает необходимость отдавать статику бекенда сразу фронтом. Проще всего сделать это через общую папку. Требования:

* в поде подключена общая папка между контейнерами (например, /static);
* после записи чего-либо в контейнере с беком файлы можно получить из контейнера с фронтом.

</details>

Для создания тестового окружения использовался манифест [stage.yaml](stage/stage.yaml). Для обмена файлами между контейнерами использовался volume с типом emptyDir.

```bash
[dev1@kingdom stage]$ kubectl apply -f stage.yaml 
namespace/stage created
deployment.apps/stage-front-back created
deployment.apps/stage-db created
persistentvolumeclaim/pvc-stage-db created
persistentvolume/pv-stage-db created
secret/postgres-secret-stage created

[dev1@kingdom stage]$ kubectl -n stage  get pod -o wide
NAME                               READY   STATUS    RESTARTS   AGE   IP               NODE        NOMINATED NODE   READINESS GATES
stage-db-79795847f9-xxh4g          1/1     Running   0          93s   10.233.107.164   kubenode2   <none>           <none>
stage-front-back-89cb7c84c-6524l   2/2     Running   0          94s   10.233.110.92    kubenode1   <none>           <none>
stage-front-back-89cb7c84c-76r2p   2/2     Running   0          95s   10.233.107.163   kubenode2   <none>           <none>

[dev1@kingdom stage]$ kubectl -n stage  exec -it stage-front-back-89cb7c84c-6524l -c stage-frontend -- /bin/bash
root@stage-front-back-89cb7c84c-6524l:/app# ls -lh /static
total 0
root@stage-front-back-89cb7c84c-6524l:/app# touch /static/file.html
root@stage-front-back-89cb7c84c-6524l:/app# ls -lh /static
total 0
-rw-r--r--. 1 root root 0 Dec 29 17:27 file.html

[dev1@kingdom stage]$ kubectl -n stage  exec -it stage-front-back-89cb7c84c-6524l -c stage-backend -- /bin/bash
root@stage-front-back-89cb7c84c-6524l:/app# ls -lh /static/
total 0
-rw-r--r--. 1 root root 0 Dec 29 17:27 file.html

```

## Задание 2: подключить общую папку для прода

<details>

Поработав на stage, доработки нужно отправить на прод. В продуктиве у нас контейнеры крутятся в разных подах, поэтому потребуется PV и связь через PVC. Сам PV должен быть связан с NFS сервером. Требования:

* все бекенды подключаются к одному PV в режиме ReadWriteMany;
* фронтенды тоже подключаются к этому же PV с таким же режимом;
* файлы, созданные бекендом, должны быть доступны фронту.

</details>

Для создания prod окружения использовался манифест [prod.yaml](prod/prod.yaml). Для обмена файлами между контейнерами использовался volume с типом nfs.


```bash
[dev1@kingdom prod]$ kubectl get pod -o wide
NAME                                  READY   STATUS    RESTARTS   AGE    IP              NODE        NOMINATED NODE   READINESS GATES
nfs-server-nfs-server-provisioner-0   1/1     Running   0          103m   10.233.110.91   kubenode1   <none>           <none>
[dev1@kingdom prod]$ kubectl -n prod get pod
NAME                          READY   STATUS    RESTARTS   AGE
prod-back-64949b884-bbj2m     1/1     Running   0          5m32s
prod-back-64949b884-tktc8     1/1     Running   0          5m31s
prod-db-ff7989d8-ljrt8        1/1     Running   0          5m28s
prod-front-5457c4469b-fmkz2   1/1     Running   0          5m34s
prod-front-5457c4469b-rtg98   1/1     Running   0          5m34s
[dev1@kingdom prod]$ 
[dev1@kingdom prod]$ kubectl -n prod exec -it prod-back-64949b884-bbj2m -- /bin/bash
root@prod-back-64949b884-bbj2m:/app# ls /static/
root@prod-back-64949b884-bbj2m:/app# touch /static/fileX.txt
root@prod-back-64949b884-bbj2m:/app# ls /static/
fileX.txt
[dev1@kingdom prod]$ kubectl -n prod exec -it prod-back-64949b884-tktc8  -- /bin/bash
root@prod-back-64949b884-tktc8:/app# ls /static/
fileX.txt
[dev1@kingdom prod]$ kubectl -n prod exec -it prod-front-5457c4469b-fmkz2  -- /bin/bash
root@prod-front-5457c4469b-fmkz2:/app# ls /static/
fileX.txt
[dev1@kingdom prod]$ kubectl -n prod exec -it prod-front-5457c4469b-rtg98  -- /bin/bash
root@prod-front-5457c4469b-rtg98:/app# ls /static/
fileX.txt

```