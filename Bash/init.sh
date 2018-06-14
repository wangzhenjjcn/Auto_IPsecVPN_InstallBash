#!/bin/sh
mkdir /mnt/myazure
mkdir /mnt/myazure/vpn
mkdir /var/log/vpn
touch /var/log/pptp.log
touch /var/log/auth.pptp.log
touch /tmp/init.sql
apt-get update -y
apt-get install -y software-properties-common python-software-properties debconf-utils
add-apt-repository -y ppa:webupd8team/java
apt-get update
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
apt-get install -y oracle-java8-installer
echo "mysql-server mysql-server/root_password password DontUseRoot" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password DontUseRoot" | debconf-set-selections
apt-get -y install mysql-server-5.7
usermod -d /var/lib/mysql/ mysql
sed -i 's/127\.0\.0\.1/0\.0\.0\.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf
echo "USE mysql; " >>  /tmp/init.sql
echo "UPDATE user SET Host="%" WHERE User=\"root\" AND Host=\"localhost\"; " >>  /tmp/init.sql
echo "DELETE FROM user WHERE Host != \"%\" AND User=\"root\"; FLUSH PRIVILEGES;" >>  /tmp/init.sql
echo "CREATE DATABASE myazure_vpn;" >>  /tmp/init.sql
echo "USE myazure_vpn; " >>  /tmp/init.sql
echo "CREATE TABLE \`data\` (" >>  /tmp/init.sql
echo "  \`mKey\` varchar(500) NOT NULL," >>  /tmp/init.sql
echo "  \`mValue\` varchar(5000) NOT NULL," >>  /tmp/init.sql
echo "  PRIMARY KEY (\`mKey\`)" >>  /tmp/init.sql
echo ") ENGINE=InnoDB DEFAULT CHARSET=utf8;" >>  /tmp/init.sql
echo "INSERT INTO \`data\` (\`mKey\`, \`mValue\`) VALUES ('ILOVECHINA', '21h8930n5y3842d34u89SE7RV8989Y89HY789Y89hny780YN)789yN780Y780yn&*o(byn&*ybn&*)y&*)yne&*rerwer9IERYT8J9F53N')" >>  /tmp/init.sql
echo "CREATE USER 'vpn'@'localhost' IDENTIFIED BY '23457890';" >>  /tmp/init.sql
echo "GRANT SELECT, INSERT, UPDATE, REFERENCES, DELETE, CREATE, DROP, ALTER, INDEX, TRIGGER, CREATE VIEW, SHOW VIEW, EXECUTE, ALTER ROUTINE, CREATE ROUTINE, CREATE TEMPORARY TABLES, LOCK TABLES, EVENT ON \`myazure\_vpn\`.* TO 'vpn'@'localhost';" >>  /tmp/init.sql
echo "GRANT GRANT OPTION ON \`myazure\_vpn\`.* TO 'vpn'@'localhost';" >>  /tmp/init.sql
echo "CREATE USER 'vpn'@'127.0.0.1' IDENTIFIED BY '23457890';" >>  /tmp/init.sql
echo "GRANT SELECT, INSERT, UPDATE, REFERENCES, DELETE, CREATE, DROP, ALTER, INDEX, TRIGGER, CREATE VIEW, SHOW VIEW, EXECUTE, ALTER ROUTINE, CREATE ROUTINE, CREATE TEMPORARY TABLES, LOCK TABLES, EVENT ON \`myazure\_vpn\`.* TO 'vpn'@'127.0.0.1';" >>  /tmp/init.sql
echo "GRANT GRANT OPTION ON \`myazure\_vpn\`.* TO 'vpn'@'127.0.0.1';" >>  /tmp/init.sql
mysql -uroot -pDontUseRoot</tmp/init.sql
service mysql restart
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
swapon -s
apt-get install -y  pptpd
sed -i 's/net\.ipv4\.ip_forward=0/net\.ipv4\.ip_forward=1/g' /etc/sysctl.conf
sed -i 's/#net\.ipv4\.ip_forward=1/net\.ipv4\.ip_forward=1/g' /etc/sysctl.conf
sysctl -p
iptables -A INPUT -p gre -j ACCEPT 
iptables -A INPUT -p tcp --dport 1723 -j ACCEPT 
iptables -A INPUT -p tcp --dport 47 -j ACCEPT 
ifconfig|  grep HWaddr |cut -f 1 -d ' ' |xargs -I {}  iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o {} -j MASQUERADE

echo "" >>  /etc/fstab
echo "/mnt/swap none swap sw 0 0" >>  /etc/fstab
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
echo "" >   /etc/nginx/sites-enabled/default
echo "" >  /etc/nginx/sites-enabled/vpn.conf
echo "server" >>  /etc/nginx/sites-enabled/vpn.conf
echo "{" >>  /etc/nginx/sites-enabled/vpn.conf
echo "listen             80;" >>  /etc/nginx/sites-enabled/vpn.conf
echo "            server_name  vpn.*  ;" >>  /etc/nginx/sites-enabled/vpn.conf
echo "            index index.php index.html index.htm index.jsp;" >>  /etc/nginx/sites-enabled/vpn.conf
echo "            root   html;" >>  /etc/nginx/sites-enabled/vpn.conf
echo "                location ~ ^/NginxStatus/ {" >>  /etc/nginx/sites-enabled/vpn.conf
echo "                        stub_status on;" >>  /etc/nginx/sites-enabled/vpn.conf
echo "                        access_log on;" >>  /etc/nginx/sites-enabled/vpn.conf
echo "                 }" >>  /etc/nginx/sites-enabled/vpn.conf
echo "         location / {" >>  /etc/nginx/sites-enabled/vpn.conf
echo "              root    html;" >>  /etc/nginx/sites-enabled/vpn.conf
echo "             proxy_redirect off ;" >>  /etc/nginx/sites-enabled/vpn.conf
echo "             proxy_set_header Host \$host;" >>  /etc/nginx/sites-enabled/vpn.conf
echo "             proxy_set_header X-Real-IP \$remote_addr;" >>  /etc/nginx/sites-enabled/vpn.conf
echo "             proxy_set_header REMOTE-HOST \$remote_addr;" >>  /etc/nginx/sites-enabled/vpn.conf
echo "             proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;" >>  /etc/nginx/sites-enabled/vpn.conf
echo "             client_max_body_size 250m;" >>  /etc/nginx/sites-enabled/vpn.conf
echo "             client_body_buffer_size 1m;" >>  /etc/nginx/sites-enabled/vpn.conf
echo "             proxy_connect_timeout 3000;" >>  /etc/nginx/sites-enabled/vpn.conf
echo "             proxy_send_timeout 1200;" >>  /etc/nginx/sites-enabled/vpn.conf
echo "             proxy_read_timeout 1200;" >>  /etc/nginx/sites-enabled/vpn.conf
echo "             proxy_buffer_size 256k;" >>  /etc/nginx/sites-enabled/vpn.conf
echo "             proxy_buffers 4 256k;" >>  /etc/nginx/sites-enabled/vpn.conf
echo "             proxy_busy_buffers_size 256k;" >>  /etc/nginx/sites-enabled/vpn.conf
echo "             proxy_temp_file_write_size 256k;" >>  /etc/nginx/sites-enabled/vpn.conf
echo "             proxy_next_upstream error timeout invalid_header http_500 http_503 http_404;" >>  /etc/nginx/sites-enabled/vpn.conf
echo "             proxy_max_temp_file_size 256m;" >>  /etc/nginx/sites-enabled/vpn.conf
echo "             proxy_pass    http://127.0.0.1:8888/;" >>  /etc/nginx/sites-enabled/vpn.conf
echo "            }" >>  /etc/nginx/sites-enabled/vpn.conf
echo "}" >>  /etc/nginx/sites-enabled/vpn.conf
service nginx restart
service pptpd restart
service ipsec restart
cd /mnt/myazure/vpn



wget https://github.com/wangzhenjjcn/IPSEC_USER_MANAGEMENT/releases/download/v2.0.0.2/V2.0.1.1  -O vpn-v2.0.0.2.jar
nohup java  -jar /mnt/myazure/vpn/vpn-v2.0.0.2.jar > /var/log/vpn/wvpn.log &



