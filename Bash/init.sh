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
 



