#!/bin/sh
apt-get update -y
sudo apt-get install -y software-properties-common python-software-properties debconf-utils
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
sudo apt-get install -y oracle-java8-installer
echo "mysql-server mysql-server/root_password password DontUseRoot" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password DontUseRoot" | debconf-set-selections
apt-get -y install mysql-server-5.7
usermod -d /var/lib/mysql/ mysql
sed -i 's/127\.0\.0\.1/0\.0\.0\.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf
mysql -uroot -pDontUseRoot -e 'USE mysql; UPDATE `user` SET `Host`="%" WHERE `User`="root" AND `Host`="localhost"; DELETE FROM `user` WHERE `Host` != "%" AND `User`="root"; FLUSH PRIVILEGES;'
service mysql restart
mkdir /mnt/myazure
mkdir /mnt/myazure/vpn
mkdir /var/log/vpn
touch /var/log/pptp.log
touch /var/log/auth.pptp.log
cd /tmp
chmod 777 /tmp/vpnsetup.sh
wget https://raw.githubusercontent.com/wangzhenjjcn/Auto_IPsecVPN_InstallBash/master/Bash/vpnsetup.sh  -O vpnsetup.sh && sudo sh vpnsetup.sh
rm /tmp/vpnsetup.sh
apt-get install -y nginx
apt-get install -y htop
apt-get install  -y python2.7
touch /mnt/swap
dd if=/dev/vda  of=/mnt/swap bs=1M count=4096
chmod 600 /mnt/swap
mkswap  /mnt/swap
swapon /mnt/swap
echo "" >>  /etc/fstab
echo "/mnt/swap none swap sw 0 0" >>  /etc/fstab
swapon -s
echo "echo \"---------------Logout--------------------------------------\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "#!/bin/sh" >>  /etc/ppp/ip-down
echo "echo \"#####################################\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "echo \"Now User $PEERNAME is disconnected!!!\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "echo \"#####################################\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "echo \"time: `date -d today +%F_%T`\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "echo \"clientIP: $6\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "echo \"username: $PEERNAME\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "echo \"device: $1\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "echo \"vpnIP: $4\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "echo \"assignIP: $5\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "echo \"connect time: $CONNECT_TIME s\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "echo \"bytes sent: $BYTES_SENT B\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "echo \"bytes rcvd: $BYTES_RCVD B\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "sum_bytes=$(($BYTES_SENT+$BYTES_RCVD))" >>  /etc/ppp/ip-down
echo "sum=`echo \"scale=2;$sum_bytes/1024/1024\"|bc`" >>  /etc/ppp/ip-down
echo "echo \"bytes sum: $sum MB\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "ave=`echo \"scale=2;$sum_bytes/1024/$CONNECT_TIME\"|bc`" >>  /etc/ppp/ip-down
echo "echo \"average speed: $ave KB/s\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "echo \"-----------------------------------------------------------\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "" >>  /etc/ppp/ip-down
echo "" >>  /etc/ppp/ip-down
echo "echo \"ESP traffic information pptpLinkLogout time=`TZ='Asia/Shanghai' date +%s`000  username=$PEERNAME  dataIn=$BYTES_SENT  dataOut=$BYTES_RCVD  clientIP=$6 time=$CONNECT_TIME  assignIP=$5 \" >> /var/log/auth.pptp.log" >>  /etc/ppp/ip-down
echo "" >>  /etc/ppp/ip-up
echo "echo \"---------------Login---------------------------------------\" >> /var/log/pptp.log" >>  /etc/ppp/ip-up
echo "echo \"##################################\" >> /var/log/pptp.log" >>  /etc/ppp/ip-up
echo "echo \"Now User $PEERNAME is connected!!!\" >> /var/log/pptp.log" >>  /etc/ppp/ip-up
echo "echo \"##################################\" >> /var/log/pptp.log" >>  /etc/ppp/ip-up
echo "echo \"time: `date -d today +%F_%T`\" >> /var/log/pptp.log" >>  /etc/ppp/ip-up
echo "echo \"clientIP: $6\" >> /var/log/pptp.log" >>  /etc/ppp/ip-up
echo "echo \"username: $PEERNAME\" >> /var/log/pptp.log" >>  /etc/ppp/ip-up
echo "echo \"device: $1\" >> /var/log/pptp.log" >>  /etc/ppp/ip-up
echo "echo \"vpnIP: $4\" >> /var/log/pptp.log" >>  /etc/ppp/ip-up
echo "echo \"assignIP: $5\" >> /var/log/pptp.log" >>  /etc/ppp/ip-up
echo "echo \"-----------------------------------------------------------\" >> /var/log/pptp.log" >>  /etc/ppp/ip-up
echo "" >>  /etc/ppp/ip-up
apt-get install -y  pptpd
echo "connections 222" >>   /etc/pptpd.conf
echo "localip 10.10.10.1" >>   /etc/pptpd.conf
echo "remoteip 10.10.10.2-10.10.10.245" >>   /etc/pptpd.conf
echo "ms-dns 8.8.8.8" >>    /etc/ppp/pptpd-options
echo "ms-dns 8.8.4.4" >>    /etc/ppp/pptpd-options
sed -i 's/net\.ipv4\.ip_forward=0/net\.ipv4\.ip_forward=1/g' /etc/sysctl.conf
sed -i 's/#net\.ipv4\.ip_forward=1/net\.ipv4\.ip_forward=1/g' /etc/sysctl.conf
sysctl -p
iptables -A INPUT -p gre -j ACCEPT 
iptables -A INPUT -p tcp --dport 1723 -j ACCEPT 
iptables -A INPUT -p tcp --dport 47 -j ACCEPT 
ifconfig|  grep HWaddr |cut -f 1 -d ' ' |xargs -I {}  iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o {} -j MASQUERADE
service pptpd restart
reboot