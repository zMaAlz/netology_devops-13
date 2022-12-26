# Домашнее задание к занятию "12.5 Сетевые решения CNI"

## Задание 1: установить в кластер CNI плагин Calico

<details>

Для проверки других сетевых решений стоит поставить отличный от Flannel плагин — например, Calico. Требования:

* установка производится через ansible/kubespray;
* после применения следует настроить политику доступа к hello-world извне. Инструкции kubernetes.io, Calico

</details>


В рамках выполнения задания был создан namespace ["app-namespace"](src/Namespaces_developnemt.yaml) раpвернут деплой ["network-multitool"](src/Deployment_network-multitool.yaml). Из контейнера есть возможность свободно получить доступ к нодам и другим подам.


```bash

dev1@kingdom src]$ kubectl -n app-namespace get pods -o wide
NAME                                 READY   STATUS    RESTARTS   AGE   IP               NODE        NOMINATED NODE   READINESS GATES
network-multitool-58885d6985-26v9t   1/1     Running   0          57m   10.233.107.130   kubenode2   <none>           <none>
network-multitool-58885d6985-4v57d   1/1     Running   0          57m   10.233.110.66    kubenode1   <none>           <none>
[dev1@kingdom src]$ kubectl get nodes -o wide
NAME         STATUS   ROLES           AGE    VERSION   INTERNAL-IP       EXTERNAL-IP   OS-IMAGE                KERNEL-VERSION           CONTAINER-RUNTIME
kubemaster   Ready    control-plane   114m   v1.25.5   192.168.121.30    <none>        CentOS Linux 7 (Core)   3.10.0-1127.el7.x86_64   containerd://1.6.14
kubenode1    Ready    <none>          112m   v1.25.5   192.168.121.123   <none>        CentOS Linux 7 (Core)   3.10.0-1127.el7.x86_64   containerd://1.6.14
kubenode2    Ready    <none>          112m   v1.25.5   192.168.121.2     <none>        CentOS Linux 7 (Core)   3.10.0-1127.el7.x86_64   containerd://1.6.14


[dev1@kingdom src]$ kubectl -n app-namespace exec -it network-multitool-58885d6985-4v57d -- /bin/bash
bash-5.1# ping 192.168.121.30
PING 192.168.121.30 (192.168.121.30) 56(84) bytes of data.
64 bytes from 192.168.121.30: icmp_seq=1 ttl=63 time=0.536 ms
64 bytes from 192.168.121.30: icmp_seq=2 ttl=63 time=0.562 ms

bash-5.1# ping 192.168.121.123
PING 192.168.121.123 (192.168.121.123) 56(84) bytes of data.
64 bytes from 192.168.121.123: icmp_seq=1 ttl=64 time=0.111 ms

bash-5.1# ping 192.168.121.2
PING 192.168.121.2 (192.168.121.2) 56(84) bytes of data.
64 bytes from 192.168.121.2: icmp_seq=1 ttl=63 time=0.396 ms
64 bytes from 192.168.121.2: icmp_seq=2 ttl=63 time=0.466 ms

bash-5.1# ping 10.233.107.130
PING 10.233.107.130 (10.233.107.130) 56(84) bytes of data.
64 bytes from 10.233.107.130: icmp_seq=1 ttl=62 time=0.695 ms
64 bytes from 10.233.107.130: icmp_seq=2 ttl=62 time=0.749 ms
```

Применена политика ["netology-network-policy"](src/NetworkPolicy.yaml). Доступ к подсетям отличным от 10.233.0.0/16 недоступен.

```bash

[dev1@kingdom src]$ kubectl apply -f NetworkPolicy.yaml 
networkpolicy.networking.k8s.io/netology-network-policy created
[dev1@kingdom src]$ kubectl -n app-namespace get networkpolicy
NAME                      POD-SELECTOR            AGE
netology-network-policy   app=network-multitool   8s

[dev1@kingdom src]$ kubectl -n app-namespace exec -it network-multitool-58885d6985-4v57d -- /bin/bash 
bash-5.1# ping 192.168.121.30
PING 192.168.121.30 (192.168.121.30) 56(84) bytes of data.

bash-5.1# ping 192.168.121.2
PING 192.168.121.2 (192.168.121.2) 56(84) bytes of data.

bash-5.1# ping 192.168.121.123
PING 192.168.121.123 (192.168.121.123) 56(84) bytes of data.

bash-5.1# ping 10.233.107.130
PING 10.233.107.130 (10.233.107.130) 56(84) bytes of data.
64 bytes from 10.233.107.130: icmp_seq=1 ttl=62 time=0.959 ms
64 bytes from 10.233.107.130: icmp_seq=2 ttl=62 time=0.440 ms

```


## Задание 2: изучить, что запущено по умолчанию

<details>

Самый простой способ — проверить командой calicoctl get . Для проверки стоит получить список нод, ipPool и profile. Требования:

* установить утилиту calicoctl;
* получить 3 вышеописанных типа в консоли.

</details>


```bash

[dev1@kingdom src]$ calicoctl get nodes
NAME         
kubemaster   
kubenode1    
kubenode2    

[dev1@kingdom src]$ calicoctl get ippools
NAME           CIDR             SELECTOR   
default-pool   10.233.64.0/18   all()      

[dev1@kingdom src]$ calicoctl get profile
NAME                                                 
projectcalico-default-allow                          
kns.app-namespace                                    
kns.default                                          
kns.kube-node-lease                                  
kns.kube-public                                      
kns.kube-system                                      
ksa.app-namespace.default                            
ksa.default.default                                  
ksa.kube-node-lease.default                          
ksa.kube-public.default                              
ksa.kube-system.attachdetach-controller              
ksa.kube-system.bootstrap-signer                     
ksa.kube-system.calico-kube-controllers              
ksa.kube-system.calico-node                          
ksa.kube-system.certificate-controller               
ksa.kube-system.clusterrole-aggregation-controller   
ksa.kube-system.coredns                              
ksa.kube-system.cronjob-controller                   
ksa.kube-system.daemon-set-controller                
ksa.kube-system.default                              
ksa.kube-system.deployment-controller                
ksa.kube-system.disruption-controller                
ksa.kube-system.dns-autoscaler                       
ksa.kube-system.endpoint-controller                  
ksa.kube-system.endpointslice-controller             
ksa.kube-system.endpointslicemirroring-controller    
ksa.kube-system.ephemeral-volume-controller          
ksa.kube-system.expand-controller                    
ksa.kube-system.generic-garbage-collector            
ksa.kube-system.horizontal-pod-autoscaler            
ksa.kube-system.job-controller                       
ksa.kube-system.kube-proxy                           
ksa.kube-system.namespace-controller                 
ksa.kube-system.node-controller                      
ksa.kube-system.nodelocaldns                         
ksa.kube-system.persistent-volume-binder             
ksa.kube-system.pod-garbage-collector                
ksa.kube-system.pv-protection-controller             
ksa.kube-system.pvc-protection-controller            
ksa.kube-system.replicaset-controller                
ksa.kube-system.replication-controller               
ksa.kube-system.resourcequota-controller             
ksa.kube-system.root-ca-cert-publisher               
ksa.kube-system.service-account-controller           
ksa.kube-system.service-controller                   
ksa.kube-system.statefulset-controller               
ksa.kube-system.token-cleaner                        
ksa.kube-system.ttl-after-finished-controller        
ksa.kube-system.ttl-controller          

```
