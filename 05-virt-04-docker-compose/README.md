# Домашнее задание к занятию "5.4. Оркестрация группой Docker контейнеров на примере Docker Compose"

## Задача 1

```bash
    yandex: Complete!
==> yandex: Stopping instance...
==> yandex: Deleting instance...
    yandex: Instance has been deleted!
==> yandex: Creating image: centos-7-base
==> yandex: Waiting for image to complete...
==> yandex: Success image create...
==> yandex: Destroying boot disk...
    yandex: Disk has been deleted!
Build 'yandex' finished after 2 minutes 2 seconds.

==> Wait completed after 2 minutes 2 seconds

==> Builds finished. The artifacts of successful builds are:
--> yandex: A disk image was created: centos-7-base (id: fd8jc56ibk4mmpefoete) with family name centos
admin2@ubuntu-srv:~/packer$ yc compute image list
+----------------------+---------------+--------+----------------------+--------+
|          ID          |     NAME      | FAMILY |     PRODUCT IDS      | STATUS |
+----------------------+---------------+--------+----------------------+--------+
| fd8jc56ibk4mmpefoete | centos-7-base | centos | f2epin40q8nh7fqdv3sh | READY  |
+----------------------+---------------+--------+----------------------+--------+
```

## Задача 2

![2](https://user-images.githubusercontent.com/87389868/154150228-d949d40c-9e5f-4f74-aed5-c8389a8e6ed8.JPG)

## Задача 3

![3](https://user-images.githubusercontent.com/87389868/154150252-82a19c1b-214c-4bb3-9ab3-9425f436eebc.JPG)
