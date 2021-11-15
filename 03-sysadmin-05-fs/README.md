Домашнее задание к занятию "3.5. Файловые системы"
------------------------------------------------------
1- *Узнайте о sparse (разряженных) файлах.*

Разрежённый файл (англ. sparse file) — файл, в котором последовательности нулевых байтов заменены на информацию об этих последовательностях.

2-*Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?*

Нет, немогут, т.к. жестккие ссылки реализованы на более низком уровне файловой системы и ссылкются на определенную область на жестком диске (где размещены данные файла). 

3-*Сделайте vagrant destroy на имеющийся инстанс Ubuntu.*

```Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'bento/ubuntu-20.04'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'bento/ubuntu-20.04' version '202107.28.0' is up to date...
==> default: There was a problem while downloading the metadata for your box
==> default: to check for updates. This is not an error, since it is usually due
==> default: to temporary network problems. This is just a warning. The problem
==> default: encountered was:
==> default:
==> default: schannel: next InitializeSecurityContext failed: Unknown error (0x80092012) - ╘єэъЎш  юЄч√тр эх ёьюуыр яЁюшчтхёЄш яЁютхЁъє юЄч√тр фы  ёхЁЄшЇшърЄр.
==> default:
==> default: If you want to check for box updates, verify your network connection
==> default: is valid and try again.
==> default: Setting the name of the VM: ubuntu
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Running 'pre-boot' VM customizations...
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
    default: Warning: Connection reset. Retrying...
    default: Warning: Connection aborted. Retrying...
    default:
    default: Vagrant insecure key detected. Vagrant will automatically replace
    default: this with a newly generated keypair for better security.
    default:
    default: Inserting generated public key within guest...
    default: Removing insecure key from the guest if it's present...
    default: Key inserted! Disconnecting and reconnecting using new SSH key...
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
==> default: Mounting shared folders...
    default: /vagrant => D:/Vagrant
```

4-*Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.*

```
vagrant@vagrant:~$ sudo fdisk /dev/sdb

Command (m for help): g
Created a new GPT disklabel (GUID: 19A5DFCF-04B5-3444-B8CC-22E24B7A8F9E).

Command (m for help): n
Partition number (1-128, default 1): 1
First sector (2048-5242846, default 2048): 2048
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242846, default 5242846): +2G

Created a new partition 1 of type 'Linux filesystem' and of size 2 GiB.

Command (m for help): n
Partition number (2-128, default 2): 2
First sector (4196352-5242846, default 4196352): 4196352
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242846, default 5242846): 5242846

Created a new partition 2 of type 'Linux filesystem' and of size 511 MiB.

Command (m for help): p
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: A2706CBF-25BC-D841-8ADE-93EA1292A511

Device       Start     End Sectors  Size Type
/dev/sdb1     2048 4196351 4194304    2G Linux filesystem
/dev/sdb2  4196352 5242846 1046495  511M Linux filesystem

```

5-*Используя sfdisk, перенесите данную таблицу разделов на второй диск.*

```
vagrant@vagrant:~/backup$ sudo sfdisk --dump /dev/sdb>sdb.dump
vagrant@vagrant:~/backup$ sudo sfdisk /dev/sdc<sdb.dump
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new GPT disklabel (GUID: A2706CBF-25BC-D841-8ADE-93EA1292A511).
/dev/sdc1: Created a new partition 1 of type 'Linux filesystem' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux filesystem' and of size 511 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: gpt
Disk identifier: A2706CBF-25BC-D841-8ADE-93EA1292A511

Device       Start     End Sectors  Size Type
/dev/sdc1     2048 4196351 4194304    2G Linux filesystem
/dev/sdc2  4196352 5242846 1046495  511M Linux filesystem

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

6-*Соберите mdadm RAID1 на паре разделов 2 Гб.*

```
vagrant@vagrant:~/backup$ sudo mdadm --create /dev/md0 -l 1 -n 2 /dev/sd{c1,b1}
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
Continue creating array? Y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.

```

7-*Соберите mdadm RAID0 на второй паре маленьких разделов.*
```
vagrant@vagrant:~/backup$ sudo mdadm --create /dev/md1 -l 0 -n 2 /dev/sd{c2,b2}
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
```

8-*Создайте 2 независимых PV на получившихся md-устройствах.*
```
vagrant@vagrant:~$ sudo pvcreate /dev/md0
  Physical volume "/dev/md0" successfully created.

vagrant@vagrant:~$ sudo pvcreate /dev/md1
  Physical volume "/dev/md1" successfully created.
```

9-*Создайте общую volume-group на этих двух PV.*

```

```

10-*Создайте LV размером 100 Мб, указав его расположение на PV с RAID0*

11-*Создайте mkfs.ext4 ФС на получившемся LV.*

12-*Смонтируйте этот раздел в любую директорию, например, /tmp/new.*

13-*Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz.*

14-*Прикрепите вывод lsblk.*

15-*Протестируйте целостность файла:*

16-*Используя pvmove, переместите содержимое PV с RAID0 на RAID1.*

17-*Сделайте --fail на устройство в вашем RAID1 md.*

18-*Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.*

19-*Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:*

20-*Погасите тестовый хост, vagrant destroy.*

