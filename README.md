## Цель домашнего задания
- Научиться самостоятельно развернуть сервис NFS и подключить к нему клиента
## Описание домашнего задания
Основная часть:
- `vagrant up` должен поднимать 2 настроенных виртуальных машины (сервер NFS и клиента) без дополнительных ручных действий; - на сервере NFS должна быть подготовлена и экспортирована директория;
- в экспортированной директории должна быть поддиректория с именем __upload__ с правами на запись в неё;
- экспортированная директория должна автоматически монтироваться на клиенте при старте виртуальной машины (systemd, autofs или fstab -  любым способом);
- монтирование и работа NFS на клиенте должна быть организована с использованием NFSv3 по протоколу UDP;
- firewall должен быть включен и настроен как на клиенте, так и на сервере.

## Решение
Устанавливаются две системы:
1. Ubuntu Server
Linux nfss 5.15.0-91-generic #101-Ubuntu SMP Tue Nov 14 13:30:08 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux
2. Ubuntu Client
Linux nfsc 5.4.0-167-generic #184-Ubuntu SMP Tue Oct 31 09:21:49 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux

#### На сервере автоматически создается и монтируется папка общего доступа:
root@nfss:~# exportfs -s
/srv/share  192.168.56.21/32(sync,wdelay,hide,sec=sys,rw,secure,root_squash,no_all_squash)

#### На клиенте мавтоматически монтируется общая папка с использованием NFSv3 по протоколу UDP:
root@nfsc:~# mount|grep mnt
systemd-1 on /mnt/nfs_clientshare type autofs (rw,relatime,fd=60,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=16906)
nsfs on /run/snapd/ns/lxd.mnt type nsfs (rw)
192.168.56.20:/srv/share/ on /mnt/nfs_clientshare type nfs (rw,relatime,vers=3,rsize=32768,wsize=32768,namlen=255,hard,proto=udp,timeo=11,retrans=3,sec=sys,mountaddr=192.168.56.20,mountvers=3,mountport=33333,mountproto=udp,local_lock=none,addr=192.168.56.20)


root@nfsc:~# df -h
Filesystem                 Size  Used Avail Use% Mounted on
udev                       969M     0  969M   0% /dev
tmpfs                      198M 1008K  197M   1% /run
/dev/sda1                   39G  1.7G   38G   5% /
tmpfs                      986M     0  986M   0% /dev/shm
tmpfs                      5.0M     0  5.0M   0% /run/lock
tmpfs                      986M     0  986M   0% /sys/fs/cgroup
/dev/loop0                  41M   41M     0 100% /snap/snapd/20290
/dev/loop2                  92M   92M     0 100% /snap/lxd/24061
/dev/loop1                  64M   64M     0 100% /snap/core20/2015
tmpfs                      198M     0  198M   0% /run/user/1000
192.168.56.20:/srv/share/  122G  7.0G  109G   7% /mnt/nfs_clientshare

#### Firewall включен на обеих станциях:

root@nfss:~# yes | sudo ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? Firewall is active and enabled on system startup
root@nfss:~# sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 111/tcp                    ALLOW IN    Anywhere                  
[ 2] 111/udp                    ALLOW IN    Anywhere                  
[ 3] 2049/tcp                   ALLOW IN    Anywhere                  
[ 4] 2049/udp                   ALLOW IN    Anywhere                  
[ 5] 33333/tcp                  ALLOW IN    Anywhere                  
[ 6] 33333/udp                  ALLOW IN    Anywhere                  
[ 7] 2222                       ALLOW IN    Anywhere                  
[ 8] 22                         ALLOW IN    Anywhere                  
[ 9] 111/tcp (v6)               ALLOW IN    Anywhere (v6)             
[10] 111/udp (v6)               ALLOW IN    Anywhere (v6)             
[11] 2049/tcp (v6)              ALLOW IN    Anywhere (v6)             
[12] 2049/udp (v6)              ALLOW IN    Anywhere (v6)             
[13] 33333/tcp (v6)             ALLOW IN    Anywhere (v6)             
[14] 33333/udp (v6)             ALLOW IN    Anywhere (v6)             
[15] 2222 (v6)                  ALLOW IN    Anywhere (v6)             
[16] 22 (v6)                    ALLOW IN    Anywhere (v6)             


oot@nfsc:~# yes | sudo ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? Firewall is active and enabled on system startup
root@nfsc:~# sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 2222                       ALLOW IN    Anywhere                  
[ 2] 22                         ALLOW IN    Anywhere                  
[ 3] 2222 (v6)                  ALLOW IN    Anywhere (v6)             
[ 4] 22 (v6)                    ALLOW IN    Anywhere (v6)  
