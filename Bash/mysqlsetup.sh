echo "mysql-server mysql-server/root_password password DontUseRoot" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password DontUseRoot" | debconf-set-selections
apt-get -y install mysql-server-5.7
usermod -d /var/lib/mysql/ mysql
sed -i 's/127\.0\.0\.1/0\.0\.0\.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf
echo "USE mysql; " >>  /tmp/init.sql
echo "UPDATE user SET Host=\"%\" WHERE User=\"root\" AND Host=\"localhost\"; " >>  /tmp/init.sql
echo "DELETE FROM user WHERE Host != \"%\" AND User=\"root\"; FLUSH PRIVILEGES;" >>  /tmp/init.sql
echo "CREATE DATABASE myazure_vpn;" >>  /tmp/init.sql
echo "USE myazure_vpn; " >>  /tmp/init.sql
echo "CREATE TABLE \`data\` (" >>  /tmp/init.sql
echo "  \`mKey\` varchar(500) NOT NULL," >>  /tmp/init.sql
echo "  \`mValue\` varchar(5000) NOT NULL," >>  /tmp/init.sql
echo "  PRIMARY KEY (\`mKey\`)" >>  /tmp/init.sql
echo ") ENGINE=InnoDB DEFAULT CHARSET=utf8;" >>  /tmp/init.sql
echo "INSERT INTO \`data\` (\`mKey\`, \`mValue\`) VALUES ('ILOVECHINA', '21h8930n5y3842d34u89SE7RV8989Y89HY789Y89hny780YN)789yN780Y780yn&*o(byn&*ybn&*)y&*)yne&*rerwer9IERYT8J9F53N');" >>  /tmp/init.sql
echo "CREATE USER 'vpn'@'localhost' IDENTIFIED BY '23457890';" >>  /tmp/init.sql
echo "GRANT SELECT, INSERT, UPDATE, REFERENCES, DELETE, CREATE, DROP, ALTER, INDEX, TRIGGER, CREATE VIEW, SHOW VIEW, EXECUTE, ALTER ROUTINE, CREATE ROUTINE, CREATE TEMPORARY TABLES, LOCK TABLES, EVENT ON \`myazure\_vpn\`.* TO 'vpn'@'localhost';" >>  /tmp/init.sql
echo "GRANT GRANT OPTION ON \`myazure\_vpn\`.* TO 'vpn'@'localhost';" >>  /tmp/init.sql
echo "CREATE USER 'vpn'@'127.0.0.1' IDENTIFIED BY '23457890';" >>  /tmp/init.sql
echo "GRANT SELECT, INSERT, UPDATE, REFERENCES, DELETE, CREATE, DROP, ALTER, INDEX, TRIGGER, CREATE VIEW, SHOW VIEW, EXECUTE, ALTER ROUTINE, CREATE ROUTINE, CREATE TEMPORARY TABLES, LOCK TABLES, EVENT ON \`myazure\_vpn\`.* TO 'vpn'@'127.0.0.1';" >>  /tmp/init.sql
echo "GRANT GRANT OPTION ON \`myazure\_vpn\`.* TO 'vpn'@'127.0.0.1';" >>  /tmp/init.sql
mysql -uroot -pDontUseRoot</tmp/init.sql
service mysql restart