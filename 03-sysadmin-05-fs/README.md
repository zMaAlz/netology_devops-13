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
vagrant@vagrant:~$ sudo vgcreate WG /dev/md0
  Volume group "WG" successfully created
  
 vagrant@vagrant:~$ sudo vgextend WG /dev/md1
  Volume group "WG" successfully extended 
```

10-*Создайте LV размером 100 Мб, указав его расположение на PV с RAID0*

```
 vagrant@vagrant:~$ sudo lvcreate -n lv1 -L 100M WG /dev/md1
  Logical volume "lv1" created.
```

11-*Создайте mkfs.ext4 ФС на получившемся LV.*

```
vagrant@vagrant:~$ sudo mkfs -t ext4 /dev/WG/lv1
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done

```

12-*Смонтируйте этот раздел в любую директорию, например, /tmp/new.*
```
 mkdir /tmp/new
 
 sudo mount /dev/WG/lv1 /tmp/new/
 
```

13-*Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz.*

```
sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2021-11-16 20:19:06--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 22452806 (21M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

/tmp/new/test.gz                               100%[====================================================================================================>]  21.41M  9.20MB/s    in 2.3s

2021-11-16 20:19:09 (9.20 MB/s) - ‘/tmp/new/test.gz’ saved [22452806/22452806]
```

14-*Прикрепите вывод lsblk.*
```
vagrant@vagrant:~$ lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdb2                 8:18   0  511M  0 part
  └─md1                9:1    0 1017M  0 raid0
    └─WG-lv1         253:2    0  100M  0 lvm   /tmp/new
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdc2                 8:34   0  511M  0 part
  └─md1                9:1    0 1017M  0 raid0
    └─WG-lv1         253:2    0  100M  0 lvm   /tmp/new
```

15-*Протестируйте целостность файла:*
```
vagrant@vagrant:~$ gzip -t /tmp/new/test.gz
vagrant@vagrant:~$ echo $?
0

```
16-*Используя pvmove, переместите содержимое PV с RAID0 на RAID1.*
```
vagrant@vagrant:~$ sudo pvmove /dev/md1 /dev/md0
  /dev/md1: Moved: 16.00%
  /dev/md1: Moved: 100.00%
```
17-*Сделайте --fail на устройство в вашем RAID1 md.*
```
vagrant@vagrant:~$ sudo mdadm --fail /dev/md0 /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md0
```
18-*Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.*
```
vagrant@vagrant:~$ dmesg | tail
[26250.223968] 20:29:53.247043 control  Session 0 is about to close ...
[26250.224484] 20:29:53.248014 control  Stopping all guest processes ...
[26250.224824] 20:29:53.248708 control  Closing all guest files ...
[26250.225220] 20:29:53.249111 control  vbglR3GuestCtrlDetectPeekGetCancelSupport: Supported (#1)
[26250.402143] e1000: eth0 NIC Link is Down
[26254.436763] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[26257.445956] 17:01:09.977729 timesync vgsvcTimeSyncWorker: Radical host time change: 73 879 439 000 000ns (HostNow=1 637 168 469 977 000 000 ns HostLast=1 637 094 590 538 000 000 ns)
[26267.448008] 17:01:19.979820 timesync vgsvcTimeSyncWorker: Radical guest time change: 73 879 510 734 000ns (GuestNow=1 637 168 479 979 807 000 ns GuestLast=1 637 094 600 469 073 000 ns fSetTimeLastLoop=true )
[26841.513188] md/raid1:md0: Disk failure on sdb1, disabling device.
               md/raid1:md0: Operation continuing on 1 devices.
```
19-*Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:*
```
vagrant@vagrant:~$ gzip -t /tmp/new/test.gz
vagrant@vagrant:~$ echo $?
0
```
20-*Погасите тестовый хост, vagrant destroy.*

done
