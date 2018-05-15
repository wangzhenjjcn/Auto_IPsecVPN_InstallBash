#!/bin/sh

apt-get update
apt-get upgrade
mkdir /mnt/myazure
mkdir /mnt/myazure/vpn
cd /mnt/myazure/vpn

wget https://raw.githubusercontent.com/wangzhenjjcn/Auto_IPsecVPN_InstallBash/master/Bash/vpnsetup.sh  -O vpnsetup.sh && sudo sh 
vpnsetup.sh
apt-get install -y nginx
apt-get install -y htop
add-apt-repository  -y ppa:webupd8team/java
apt-get update
apt-get install  -y python2.7
touch /mnt/swap
dd if=/dev/vda  of=/mnt/swap bs=1M count=2048
chmod 600 /mnt/swap
mkswap  /mnt/swap
swapon /mnt/swap
/mnt/swap none swap sw 0 0