# Домашнее задание к занятию "14.4 Сервис-аккаунты"

## Задача 1: Работа с сервис-аккаунтами через утилиту kubectl

**Как создать сервис-аккаунт?**

```bash

[dev1@kingdom vagrant]$ kubectl create serviceaccount netology
serviceaccount/netology created

```

**Как просмотреть список сервис-акаунтов?**

```bash

[dev1@kingdom vagrant]$ kubectl get serviceaccount
NAME       SECRETS   AGE
default    0         3h2m
netology   0         44s


```

**Как получить информацию в формате YAML и/или JSON?**

```bash

[dev1@kingdom ~]$ kubectl get serviceaccount netology -o yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  creationTimestamp: "2023-01-06T12:53:03Z"
  name: netology
  namespace: stage
  resourceVersion: "180917"
  uid: e28db28e-b17e-49af-a7b4-2f4ae708ac21
[dev1@kingdom ~]$ kubectl get serviceaccount default -o json
{
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
        "creationTimestamp": "2023-01-06T09:50:58Z",
        "name": "default",
        "namespace": "stage",
        "resourceVersion": "159266",
        "uid": "4ff1977c-3104-408d-98f2-327afcc77035"
    }
}

```

**Как выгрузить сервис-акаунты и сохранить его в файл?**

```bash

[dev1@kingdom ~]$ kubectl get serviceaccounts -o json > serviceaccounts.json
[dev1@kingdom ~]$ kubectl get serviceaccount netology -o yaml > netology.yml
[dev1@kingdom ~]$ ls -lh
-rw-r--r--. 1 dev1 dev1 198 янв  6 16:13 netology.yml
-rw-r--r--. 1 dev1 dev1 868 янв  6 16:13 serviceaccounts.json

```

**Как удалить сервис-акаунт?**

```bash

[dev1@kingdom ~]$ kubectl delete serviceaccount netology
serviceaccount "netology" deleted

[dev1@kingdom ~]$ kubectl get serviceaccount
NAME      SECRETS   AGE
default   0         3h6m


```

**Как загрузить сервис-акаунт из файла?**

```bash

[dev1@kingdom ~]$ kubectl apply -f netology.yml
serviceaccount/netology created

[dev1@kingdom ~]$ kubectl get serviceaccount
NAME       SECRETS   AGE
default    0         3h7m
netology   0         3s

```

## Задача 2 (*): Работа с сервис-акаунтами внутри модуля

<details>

Выбрать любимый образ контейнера, подключить сервис-акаунты и проверить доступность API Kubernetes

</details>

```bash

[dev1@kingdom src]$ kubectl get service,po,deploy
NAME            READY   STATUS    RESTARTS   AGE
pod/multitool   1/1     Running   0          106s
[dev1@kingdom src]$ kubectl exec -it multitool -- /bin/bash
bash-5.1# env | grep KUBE
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_SERVICE_PORT=443
KUBERNETES_PORT_443_TCP=tcp://10.233.0.1:443
KUBERNETES_PORT_443_TCP_PROTO=tcp
KUBERNETES_PORT_443_TCP_ADDR=10.233.0.1
KUBERNETES_SERVICE_HOST=10.233.0.1
KUBERNETES_PORT=tcp://10.233.0.1:443
KUBERNETES_PORT_443_TCP_PORT=443

bash-5.1# curl -H "Authorization: Bearer $TOKEN" --cacert $CACERT $K8S/api/v1/
{
  "kind": "APIResourceList",
  "groupVersion": "v1",
  "resources": [
    {
      "name": "bindings",
      "singularName": "",
      "namespaced": true,
      "kind": "Binding",
      "verbs": [
        "create"
      ]
    },
...
    {
      "name": "services/status",
      "singularName": "",
      "namespaced": true,
      "kind": "Service",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    }
  ]
}

```
