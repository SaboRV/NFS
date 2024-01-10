export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y nfs-common
apt-get install -y mc
mkdir -p /mnt/nfs_clientshare
echo "192.168.56.20:/srv/share/ /mnt/nfs_clientshare nfs vers=3,proto=udp,noauto,x-systemd.automount 0 0" >> /etc/fstab
mount -a
sudo ufw enable
ufw allow 2222
ufw allow 22
yes | sudo ufw enable
reboot
