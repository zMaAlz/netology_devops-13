# Домашнее задание к занятию "12.1 Компоненты Kubernetes"

## Задача 1: Установить Minikube

<details>
Для экспериментов и валидации ваших решений вам нужно подготовить тестовую среду для работы с Kubernetes. Оптимальное решение — развернуть на рабочей машине Minikube.
</details>

```bash
[admin@h1 ~]$ minikube start --driver=kvm2
😄  minikube v1.27.1 на Fedora 36
✨  Используется драйвер kvm2 на основе конфига пользователя
💾  Downloading driver docker-machine-driver-kvm2:
    > docker-machine-driver-kvm2-...:  65 B / 65 B [---------] 100.00% ? p/s 0s
    > docker-machine-driver-kvm2-...:  12.20 MiB / 12.20 MiB  100.00% 6.79 MiB 
💿  Downloading VM boot image ...
    > minikube-v1.27.0-amd64.iso....:  65 B / 65 B [---------] 100.00% ? p/s 0s
    > minikube-v1.27.0-amd64.iso:  273.79 MiB / 273.79 MiB  100.00% 10.18 MiB p
👍  Запускается control plane узел minikube в кластере minikube
💾  Скачивается Kubernetes v1.25.2 ...
    > preloaded-images-k8s-v18-v1...:  385.41 MiB / 385.41 MiB  100.00% 9.34 Mi
🔥  Creating kvm2 VM (CPUs=2, Memory=3900MB, Disk=20000MB) ...
🐳  Подготавливается Kubernetes v1.25.2 на Docker 20.10.18 ...
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
🔎  Компоненты Kubernetes проверяются ...
    ▪ Используется образ gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Включенные дополнения: storage-provisioner, default-storageclass
🏄  Готово! kubectl настроен для использования кластера "minikube" и "default" пространства имён по умолчанию
[admin@h1  ~]$ minikube status
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured
```

## Задача 2: Запуск Hello World

<details>
После установки Minikube требуется его проверить. Для этого подойдет стандартное приложение hello world. А для доступа к нему потребуется ingress.

развернуть через Minikube тестовое приложение по туториалу

установить аддоны ingress и dashboard
</details>

```bash
[admin@h1 ~]$ minikube addons enable ingress
💡  ingress is an addon maintained by Kubernetes. For any concerns contact minikube on GitHub.
You can view the list of minikube maintainers at: https://github.com/kubernetes/minikube/blob/master/OWNERS
    ▪ Используется образ k8s.gcr.io/ingress-nginx/controller:v1.2.1
    ▪ Используется образ k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1
    ▪ Используется образ k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1
🔎  Verifying ingress addon...
🌟  The 'ingress' addon is enabled

[admin@h1 ~]$ minikube dashboard
🔌  Enabling dashboard ...
    ▪ Используется образ docker.io/kubernetesui/dashboard:v2.7.0
    ▪ Используется образ docker.io/kubernetesui/metrics-scraper:v1.0.8
🤔  Verifying dashboard health ...
🚀  Launching proxy ...
🤔  Verifying proxy health ...
🎉  Opening http://127.0.0.1:39023/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/ in your default browser...
Found ffmpeg: /opt/yandex/browser/libffmpeg.so
	avcodec: 3871844
	avformat: 3871077
	avutil: 3740260
Ffmpeg version is OK! Let's use it.
[5635:5635:1016/221034.363244:ERROR:isolated_origin_util.cc(74)] Ignoring port number in isolated origin: chrome://custo
Окно или вкладка откроются в текущем сеансе браузера.

```
```bash

[admin@h1] ~]$ kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4
deployment.apps/hello-node created

[admin@h1 ~]$ kubectl get deployments
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
hello-node   1/1     1            1           3m43s

[admin@h1 ~]$ kubectl get pods
NAME                         READY   STATUS    RESTARTS   AGE
hello-node-697897c86-t7dsm   1/1     Running   0          4m8s

[admin@h1 ~]$ kubectl get events
LAST SEEN   TYPE     REASON                    OBJECT                            MESSAGE
5m41s       Normal   Scheduled                 pod/hello-node-697897c86-t7dsm    Successfully assigned default/hello-node-697897c86-t7dsm to minikube
5m34s       Normal   Pulling                   pod/hello-node-697897c86-t7dsm    Pulling image "k8s.gcr.io/echoserver:1.4"
5m7s        Normal   Pulled                    pod/hello-node-697897c86-t7dsm    Successfully pulled image "k8s.gcr.io/echoserver:1.4" in 27.397087663s
5m2s        Normal   Created                   pod/hello-node-697897c86-t7dsm    Created container echoserver
5m          Normal   Started                   pod/hello-node-697897c86-t7dsm    Started container echoserver
5m41s       Normal   SuccessfulCreate          replicaset/hello-node-697897c86   Created pod: hello-node-697897c86-t7dsm
5m41s       Normal   ScalingReplicaSet         deployment/hello-node             Scaled up replica set hello-node-697897c86 to 1
21m         Normal   Starting                  node/minikube                     Starting kubelet.
21m         Normal   NodeHasSufficientMemory   node/minikube                     Node minikube status is now: NodeHasSufficientMemory
21m         Normal   NodeHasNoDiskPressure     node/minikube                     Node minikube status is now: NodeHasNoDiskPressure
21m         Normal   NodeHasSufficientPID      node/minikube                     Node minikube status is now: NodeHasSufficientPID
21m         Normal   NodeAllocatableEnforced   node/minikube                     Updated Node Allocatable limit across pods
20m         Normal   RegisteredNode            node/minikube                     Node minikube event: Registered Node minikube in Controller
20m         Normal   Starting                  node/minikube    

```


## Задача 3: Установить kubectl

<details>
Подготовить рабочую машину для управления корпоративным кластером. Установить клиентское приложение kubectl.

подключиться к minikube

проверить работу приложения из задания 2, запустив port-forward до кластера
</details>

```
[admin@h1 ~]$ kubectl port-forward hello-node-697897c86-t7dsm 8080:8080
Forwarding from 127.0.0.1:8080 -> 8080
Forwarding from [::1]:8080 -> 8080
Handling connection for 8080
Handling connection for 8080

```


## Задача 4 (*): собрать через ansible (необязательное)

<details>
Профессионалы не делают одну и ту же задачу два раза. Давайте закрепим полученные навыки, автоматизировав выполнение заданий ansible-скриптами. При выполнении задания обратите внимание на доступные модули для k8s под ansible.

собрать роль для установки minikube на aws сервисе (с установкой ingress)

собрать роль для запуска в кластере hello world
</details>

[Роль minikube](https://github.com/zMaAlz/Minikube-role)

