# Домашнее задание к занятию "14.5 SecurityContext, NetworkPolicies"

## Задача 1: Рассмотрите пример 14.5/example-security-context.yml

```bash
[dev1@kingdom src]$ kubectl apply -f example-security-context.yml
pod/security-context-demo created

[dev1@kingdom src]$ kubectl get pod
NAME                    READY   STATUS             RESTARTS      AGE
security-context-demo   0/1     Completed           0             53s

[dev1@kingdom src]$ kubectl logs security-context-demo
uid=1000 gid=3000 groups=3000

```

## Задача 2 (*): Рассмотрите пример 14.5/example-network-policy.yml

<details>

Создайте два модуля. Для первого модуля разрешите доступ к внешнему миру и ко второму контейнеру. Для второго модуля разрешите связь только с первым контейнером. Проверьте корректность настроек.

</details>

Для проведения теста создан манифест [prod.yaml](src/prod.yml) и изменена [NetworkPolicy](src/example-network-policy.yml).

```bash
[dev1@kingdom src]$ kubectl apply -f prod.yaml 
pod/multitool created
deployment.apps/prod-front created
service/prod-front created
deployment.apps/prod-back created
service/prod-back created

[dev1@kingdom src]$ kubectl get service,po,deploy,ep -o wide
NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE   SELECTOR
service/prod-back    ClusterIP   10.233.35.154   <none>        9000/TCP         39s   group=back
service/prod-front   NodePort    10.233.3.245    <none>        8000:31202/TCP   46s   group=front

NAME                              READY   STATUS    RESTARTS   AGE   IP               NODE        NOMINATED NODE   READINESS GATES
pod/multitool                     1/1     Running   0          48s   10.233.107.143   kubenode2   <none>           <none>
pod/prod-back-586bb758dc-mlclz    1/1     Running   0          38s   10.233.107.142   kubenode2   <none>           <none>
pod/prod-back-586bb758dc-ndgnc    1/1     Running   0          39s   10.233.110.118   kubenode1   <none>           <none>
pod/prod-front-847cbb4697-8wrtj   1/1     Running   0          46s   10.233.107.144   kubenode2   <none>           <none>
pod/prod-front-847cbb4697-kzh55   1/1     Running   0          46s   10.233.110.117   kubenode1   <none>           <none>

NAME                         READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES                            SELECTOR
deployment.apps/prod-back    2/2     2            2           40s   prod-back    praqma/network-multitool:fedora   group=back
deployment.apps/prod-front   2/2     2            2           47s   prod-front   praqma/network-multitool:fedora   group=front

NAME                   ENDPOINTS                             AGE
endpoints/prod-back    10.233.107.142:80,10.233.110.118:80   38s
endpoints/prod-front   10.233.107.144:80,10.233.110.117:80   43s

[dev1@kingdom src]$ kubectl exec -it pod/multitool -- bash
[root@multitool /]# curl http://prod-back:9000
Praqma Network MultiTool (with NGINX) -  - 10.233.107.142/32
[root@multitool /]# curl http://prod-back:9000
Praqma Network MultiTool (with NGINX) -  - 10.233.110.118/32
[root@multitool /]# ping prod-front
PING prod-front.stage.svc.cluster.local (10.233.3.245) 56(84) bytes of data.
64 bytes from prod-front.stage.svc.cluster.local (10.233.3.245): icmp_seq=1 ttl=64 time=0.044 ms
64 bytes from prod-front.stage.svc.cluster.local (10.233.3.245): icmp_seq=2 ttl=64 time=0.087 ms
64 bytes from prod-front.stage.svc.cluster.local (10.233.3.245): icmp_seq=3 ttl=64 time=0.084 ms

[dev1@kingdom src]$ kubectl apply -f example-network-policy.yml 
networkpolicy.networking.k8s.io/network-policy-back created
networkpolicy.networking.k8s.io/network-policy-front created

[dev1@kingdom src]$ kubectl exec -it pod/multitool -- bash
[root@multitool /]# curl http://prod-back:9000 -v
*   Trying 10.233.35.154:9000...
curl: (28) Failed to connect after 130331 ms: Время ожидания соединения истекло
[root@multitool /]# curl http://10.233.110.118 -v
*   Trying 10.233.110.118:80...
curl: (28) Failed to connect after 130331 ms: Время ожидания соединения истекло
[root@multitool /]# ping 10.233.110.118
PING 10.233.110.118 (10.233.110.118) 56(84) bytes of data.
^Z
[8]+  Stopped                 ping 10.233.110.118
[root@multitool /]# ping 10.233.107.142
PING 10.233.107.142 (10.233.107.142) 56(84) bytes of data.
^Z
[1]+  Stopped                 ping 10.233.107.142
[root@multitool /]# curl http://prod-front:8000
curl: (28) Failed to connect to prod-front port 8000: Connection timed out

```
