apt-get install -y  pptpd
sed -i 's/net\.ipv4\.ip_forward=0/net\.ipv4\.ip_forward=1/g' /etc/sysctl.conf
sed -i 's/#net\.ipv4\.ip_forward=1/net\.ipv4\.ip_forward=1/g' /etc/sysctl.conf
sysctl -p
iptables -A INPUT -p gre -j ACCEPT 
iptables -A INPUT -p tcp --dport 1723 -j ACCEPT 
iptables -A INPUT -p tcp --dport 47 -j ACCEPT 
ifconfig|  grep HWaddr |cut -f 1 -d ' ' |xargs -I {}  iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o {} -j MASQUERADE
iptables -I FORWARD -s 10.10.10.0/24 -p tcp --syn -i ppp+ -j TCPMSS --set-mss 1300
echo "echo \"---------------Logout--------------------------------------\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "#!/bin/sh" >>  /etc/ppp/ip-down
echo "echo \"#####################################\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "echo \"Now User \$PEERNAME is disconnected!!!\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "echo \"#####################################\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "echo \"time: \`date -d today +%F_%T\`\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "echo \"clientIP: \$6\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "echo \"username: \$PEERNAME\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "echo \"device: \$1\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "echo \"vpnIP: \$4\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "echo \"assignIP: \$5\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "echo \"connect time: \$CONNECT_TIME s\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "echo \"bytes sent: \$BYTES_SENT B\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "echo \"bytes rcvd: \$BYTES_RCVD B\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "sum_bytes=\$((\$BYTES_SENT+\$BYTES_RCVD))" >>  /etc/ppp/ip-down
echo "sum=\`echo \"scale=2;\$sum_bytes/1024/1024\"|bc\`" >>  /etc/ppp/ip-down
echo "echo \"bytes sum: \$sum MB\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "ave=\`echo \"scale=2;\$sum_bytes/1024/\$CONNECT_TIME\"|bc\`" >>  /etc/ppp/ip-down
echo "echo \"average speed: \$ave KB/s\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "echo \"-----------------------------------------------------------\" >> /var/log/pptp.log" >>  /etc/ppp/ip-down
echo "" >>  /etc/ppp/ip-down
echo "echo \"ESP traffic information pptpLinkLogout time=\`TZ='Asia/Shanghai' date +%s\`000  username=\$PEERNAME  dataIn=\$BYTES_SENT  dataOut=\$BYTES_RCVD  clientIP=\$6 time=\$CONNECT_TIME  assignIP=\$5 \" >> /var/log/auth.pptp.log" >>  /etc/ppp/ip-down
echo "" >>  /etc/ppp/ip-down
echo "" >>  /etc/ppp/ip-up
echo "echo \"---------------Login---------------------------------------\" >> /var/log/pptp.log" >>  /etc/ppp/ip-up
echo "echo \"##################################\" >> /var/log/pptp.log" >>  /etc/ppp/ip-up
echo "echo \"Now User \$PEERNAME is connected!!!\" >> /var/log/pptp.log" >>  /etc/ppp/ip-up
echo "echo \"##################################\" >> /var/log/pptp.log" >>  /etc/ppp/ip-up
echo "echo \"time: \`date -d today +%F_%T\`\" >> /var/log/pptp.log" >>  /etc/ppp/ip-up
echo "echo \"clientIP: \$6\" >> /var/log/pptp.log" >>  /etc/ppp/ip-up
echo "echo \"username: \$PEERNAME\" >> /var/log/pptp.log" >>  /etc/ppp/ip-up
echo "echo \"device: \$1\" >> /var/log/pptp.log" >>  /etc/ppp/ip-up
echo "echo \"vpnIP: \$4\" >> /var/log/pptp.log" >>  /etc/ppp/ip-up
echo "echo \"assignIP: \$5\" >> /var/log/pptp.log" >>  /etc/ppp/ip-up
echo "echo \"-----------------------------------------------------------\" >> /var/log/pptp.log" >>  /etc/ppp/ip-up
echo "" >>  /etc/ppp/ip-up
echo "connections 222" >>   /etc/pptpd.conf
echo "localip 10.10.10.1" >>   /etc/pptpd.conf
echo "remoteip 10.10.10.2-245" >>   /etc/pptpd.conf
echo "ms-dns 8.8.8.8" >>    /etc/ppp/pptpd-options
echo "ms-dns 8.8.4.4" >>    /etc/ppp/pptpd-options
service pptpd restart













