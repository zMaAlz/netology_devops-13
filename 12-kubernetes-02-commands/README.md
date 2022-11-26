# Домашнее задание к занятию "12.2 Команды для работы с Kubernetes"

## Задание 1: Запуск пода из образа в деплойменте

<details>
Для начала следует разобраться с прямым запуском приложений из консоли. Такой подход поможет быстро развернуть инструменты отладки в кластере. Требуется запустить деплоймент на основе образа из hello world уже через deployment. Сразу стоит запустить 2 копии приложения (replicas=2).

Требования:

* пример из hello world запущен в качестве deployment
* количество реплик в deployment установлено в 2
* наличие deployment можно проверить командой kubectl get deployment
* наличие подов можно проверить командой kubectl get pods

</details>


``` bash
[adm@srv1 12-kubernetes-02-commands]$ kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4
deployment.apps/hello-node created
[adm@srv1 12-kubernetes-02-commands]$ kubectl scale --replicas=2 deployment  hello-node
deployment.apps/hello-node scaled
[adm@srv1 12-kubernetes-02-commands]$ kubectl get deployment
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
hello-node   2/2     2            2           91s
[adm@srv1 12-kubernetes-02-commands]$ kubectl get pod
NAME                         READY   STATUS    RESTARTS   AGE
hello-node-697897c86-226vj   1/1     Running   0          92s
hello-node-697897c86-fwhgz   1/1     Running   0          92s
```


## Задание 2: Просмотр логов для разработки

<details>
Разработчикам крайне важно получать обратную связь от штатно работающего приложения и, еще важнее, об ошибках в его работе. Требуется создать пользователя и выдать ему доступ на чтение конфигурации и логов подов в app-namespace.

Требования:

* создан новый токен доступа для пользователя
* пользователь прописан в локальный конфиг (~/.kube/config, блок users)
* пользователь может просматривать логи подов и их конфигурацию (kubectl logs pod <pod_id>, kubectl describe pod <pod_id>)
</details>

```bash
[kubadmin@srv1 minikube]$ kubectl apply -f Deployment_hello-node.yaml
[kubadmin@srv1 minikube]$ kubectl apply -f Namespaces_developnemt.yaml
[kubadmin@srv1 minikube]$ kubectl apply -f Role.yaml)
[kubadmin@srv1 minikube]$ kubectl apply -f RoleBinding.yaml)
```

[Deployment_hello-node.yaml](src/Deployment_hello-node.yaml)

[Namespaces_developnemt.yaml](src/Namespaces_developnemt.yaml)

[Role.yaml](src/Role.yaml)

[RoleBinding.yaml](src/RoleBinding.yaml)


```bash
[dev1@srv1 minikube]$ openssl genrsa -out kube.key 2048
[dev1@srv1 minikube]$ openssl req -new -key kube.key -out kube-dev.csr -subj "/CN=dev1/O=read-pods"

[kubadmin@srv1 minikube]$ openssl x509 -req -in kube-dev.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out kube-dev.crt -days 500

[kubadmin@srv1 minikube]$ kubectl config set-credentials dev1 --client-certificate=/home/dev1/minikube/kube-dev.crt  --client-key=/home/dev1/minikube/kube.key
[kubadmin@srv1 minikube]$ kubectl config set-context dev1-context --cluster=minikube --namespace=app-namespace --user=dev1

[dev1@kingdom minikube]$ cat ~/.kube/config
apiVersion: v1
clusters:
- cluster:
    certificate-authority: /home/kubadmin/.minikube/ca.crt
    extensions:
    - extension:
        last-update: Sat, 26 Nov 2022 13:34:23 MSK
        provider: minikube.sigs.k8s.io
        version: v1.27.1
      name: cluster_info
    server: https://192.168.39.102:8443
  name: minikube
contexts:
- context:
    cluster: minikube
    namespace: app-namespace
    user: dev1
  name: dev1-context
current-context: dev1-context
kind: Config
preferences: {}
users:
- name: dev1
  user:
    client-certificate: /home/dev1/minikube/kube-dev.crt
    client-key: /home/dev1/minikube/kube.key

[dev1@srv1 minikube]$ kubectl config current-context
dev1-context

[dev1@srv1 minikube]$ kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
hello-node-58d8bccc85-6jzgz   1/1     Running   0          42m
hello-node-58d8bccc85-frrv2   1/1     Running   0          42m

[dev1@srv1 minikube]$ kubectl get namespace
Error from server (Forbidden): namespaces is forbidden: User "dev1" cannot list resource "namespaces" in API group "" at the cluster scope

```


## Задание 3: Изменение количества реплик

<details>
Поработав с приложением, вы получили запрос на увеличение количества реплик приложения для нагрузки. Необходимо изменить запущенный deployment, увеличив количество реплик до 5. Посмотрите статус запущенных подов после увеличения реплик.

Требования:

* в deployment из задания 1 изменено количество реплик на 5
* проверить что все поды перешли в статус running (kubectl get pods)
</details>


``` bash
[adm@srv1 12-kubernetes-02-commands]$ kubectl scale --replicas=5 deployment  hello-node
deployment.apps/hello-node scaled
[adm@srv1 12-kubernetes-02-commands]$ kubectl get pod
NAME                         READY   STATUS    RESTARTS   AGE
hello-node-697897c86-9cpmv   1/1     Running   0          38m
hello-node-697897c86-cv9ch   1/1     Running   0          85s
hello-node-697897c86-jn2nb   1/1     Running   0          36m
hello-node-697897c86-kvzw2   1/1     Running   0          85s
hello-node-697897c86-zmtgg   1/1     Running   0          85s

```
