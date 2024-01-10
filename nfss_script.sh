export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y nfs-kernel-server
apt-get install -y mc
mkdir -p /srv/share/upload 
chown -R nobody:nogroup /srv/share/upload 
chmod 777 /srv/share/upload
touch /srv/share/upload/check_file
cat << EOF > /etc/exports 
/srv/share 192.168.56.21/32(rw,sync,root_squash,no_subtree_check)
EOF
exportfs -r
systemctl restart nfs-kernel-server
sudo ufw allow 111/tcp
sudo ufw allow 111/udp
sudo ufw allow 2049/tcp
sudo ufw allow 2049/udp
sudo ufw allow 33333/tcp
sudo ufw allow 33333/udp
ufw allow 2222
ufw allow 22
yes | sudo ufw enable
sudo cat /dev/null > /etc/nfs.conf
echo "[mountd]
port=33333
[nfsd]
udp=y" >> /etc/nfs.conf
reboot
