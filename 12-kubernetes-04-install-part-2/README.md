# Домашнее задание к занятию "12.4 Развертывание кластера на собственных серверах, лекция 2"

## Задание 1: Подготовить инвентарь kubespray

<details>

Новые тестовые кластеры требуют типичных простых настроек. Нужно подготовить инвентарь и проверить его работу. Требования к инвентарю:

* подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды;
* в качестве CRI — containerd;
* запуск etcd производить на мастере.

</details>


Создан файл [hosts.yaml](kubespray/inventory/netology/hosts.yaml) и изменены параметры group_vars:

```yaml
kube_network_plugin: flannel
supplementary_addresses_in_ssl_keys: [51.250.40.99]
```

На удаленном ПК создан файл с конфигурацией для kubectl и проверена возможность подключения.

```bash

[dev1@kingdom ~]$ cat .kube/config
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1....0tLS0tCg==
    server: https://192.168.121.30:6443
  name: cluster.local
contexts:
- context:
    cluster: cluster.local
    user: kubernetes-admin
  name: kubernetes-admin@cluster.local
current-context: kubernetes-admin@cluster.local
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: LS0tLS1CRUdJTi....0tCg==
    client-key-data: LS0tLS1CRUdJTi....tLS0tCg==


[dev1@kingdom ~]$ kubectl get nodes -o wide
NAME         STATUS   ROLES           AGE    VERSION   INTERNAL-IP       EXTERNAL-IP   OS-IMAGE                KERNEL-VERSION           CONTAINER-RUNTIME
kubemaster   Ready    control-plane   128m   v1.25.5   192.168.121.30    <none>        CentOS Linux 7 (Core)   3.10.0-1127.el7.x86_64   containerd://1.6.14
kubenode1    Ready    <none>          126m   v1.25.5   192.168.121.123   <none>        CentOS Linux 7 (Core)   3.10.0-1127.el7.x86_64   containerd://1.6.14
kubenode2    Ready    <none>          126m   v1.25.5   192.168.121.2     <none>        CentOS Linux 7 (Core)   3.10.0-1127.el7.x86_64   containerd://1.6.14

```
