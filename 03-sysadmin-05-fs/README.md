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



5-*Используя sfdisk, перенесите данную таблицу разделов на второй диск.*

6-*Соберите mdadm RAID1 на паре разделов 2 Гб.*

7-*Соберите mdadm RAID0 на второй паре маленьких разделов.*

8-*Создайте 2 независимых PV на получившихся md-устройствах.*

9-*Создайте общую volume-group на этих двух PV.*

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

