# Домашнее задание к занятию "14.2 Синхронизация секретов с внешними сервисами. Vault"

## Задача 1: Работа с модулем Vault

```bash
[dev1@kingdom src]$ kubectl apply -f vault-pod.yml 
pod/14.2-netology-vault created

[dev1@kingdom src]$ kubectl get pod 14.2-netology-vault -o=jsonpath='{.status.podIPs}'
[{"ip":"10.233.110.105"}]

[dev1@kingdom src]$ kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
If you don't see a command prompt, try pressing enter.
sh-5.2# 

sh-5.2# python3
Python 3.11.0 (main, Oct 24 2022, 00:00:00) [GCC 12.2.1 20220819 (Red Hat 12.2.1-2)] on linux
>>> import hvac
>>> client.is_authenticated()
True
>>> client.secrets.kv.v2.create_or_update_secret(
...     path='hvac',
...     secret=dict(netology='Big secret!!!'),
... )
{'request_id': '8337a91f-131b-2b65-0ffb-299bc0ac6776', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'created_time': '2023-01-02T13:58:23.512665028Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 2}, 'wrap_info': None, 'warnings': None, 'auth': None}
>>> client.secrets.kv.v2.read_secret_version(
...     path='hvac',
... )
{'request_id': '112ad37f-3eed-0445-eebc-d3d793be962d', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'data': {'netology': 'Big secret!!!'}, 'metadata': {'created_time': '2023-01-02T13:58:23.512665028Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 2}}, 'wrap_info': None, 'warnings': None, 'auth': None}

```

## Задача 2 (*): Работа с секретами внутри модуля

<details>

* На основе образа fedora создать модуль;
* Создать секрет, в котором будет указан токен;
* Подключить секрет к модулю;
* Запустить модуль и проверить доступность сервиса Vault.

</details>

Создан [секрет](src/sec-vau.yaml) и манифест [пода](src/pod.yml).


```bash

[dev1@kingdom src]$ kubectl apply -f sec-vau.yaml 
secret/secret-vault created
[dev1@kingdom src]$ kubectl apply -f vault-pod.yml 
pod/14.2-netology-vault created
[dev1@kingdom src]$ kubectl apply -f pod.yml 
pod/multitool created

[dev1@kingdom src]$ kubectl get po -o wide
NAME                  READY   STATUS    RESTARTS   AGE     IP               NODE        NOMINATED NODE   READINESS GATES
14.2-netology-vault   1/1     Running   0          2m14s   10.233.110.107   kubenode1   <none>           <none>
multitool             1/1     Running   0          48s     10.233.107.190   kubenode2   <none>           <none>

[dev1@kingdom src]$ kubectl exec -it multitool -- /bin/bash
[root@multitool /]# echo $VAULT_TOKEN
aiphohTaa0eeHei
[root@multitool /]# python3
>>> import hvac
>>> import os
>>> token_vau=os.environ['VAULT_TOKEN']
>>> token_vau=token_vau[:-1]
>>> client = hvac.Client(
...     url='http://10.233.110.107:8200',
...     token=token_vau,
... )
>>> 
>>> client.is_authenticated()
True
>>> client.secrets.kv.v2.read_secret_version(path='hvac',)
{'request_id': '640032af-1f41-1100-5fd1-dc24601ce27b', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'data': {'netology': 'Big secret!!!'}, 'metadata': {'created_time': '2023-01-02T18:09:22.825770823Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 1}}, 'wrap_info': None, 'warnings': None, 'auth': None}

```