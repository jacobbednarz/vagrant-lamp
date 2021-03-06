#!/usr/bin/env bash

php_config_file="/etc/php5/apache2/php.ini"
xdebug_config_file="/etc/php5/mods-available/xdebug.ini"
xhprof_config_file="/etc/php5/mods-available/xhprof.ini"
mysql_config_file="/etc/mysql/my.cnf"

# Update the server.
apt-get update
apt-get -y upgrade

if [[ -e /var/lock/vagrant-provision ]]; then
    exit;
fi

################################################################################
# Everything below this line should only need to be done once
# To re-run full provisioning, delete /var/lock/vagrant-provision and run
#
#    $ vagrant provision
#
# From the host machine
################################################################################

IPADDR=$(/sbin/ifconfig eth0 | awk '/inet / { print $2 }' | sed 's/addr://')
sed -i "s/^${IPADDR}.*//" /etc/hosts
echo $IPADDR ubuntu.localhost >> /etc/hosts # Just to quiet down some error messages

# Install basic tools.
apt-get -y install build-essential binutils-doc git python-software-properties

# Use PHP 5.6 PPA
add-apt-repository ppa:ondrej/php5-5.6
apt-get update

# Install Apache.
apt-get -y install apache2
apt-get -y install php5 php5-dev php5-curl php5-mysql php5-sqlite php5-xdebug php-pear

sed -i "s/display_startup_errors = Off/display_startup_errors = On/g" ${php_config_file}
sed -i "s/display_errors = Off/display_errors = On/g" ${php_config_file}

cat << EOF > ${xdebug_config_file}
zend_extension=xdebug.so
xdebug.remote_enable=1
xdebug.remote_connect_back=1
xdebug.remote_port=9000
xdebug.remote_host=10.0.2.2
EOF

# Install xhprof.
sudo pecl install -f xhprof-beta
cat << EOF > ${xhprof_config_file}
[xhprof]
extension=xhprof.so
xhprof.output_dir="/tmp/xhprof"
EOF
php5enmod xhprof

# Install MySQL.
echo "mysql-server mysql-server/root_password password root" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password root" | sudo debconf-set-selections
apt-get -y install mysql-client mysql-server

sed -i "s/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" ${mysql_config_file}

# Allow root access from any host.
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION" | mysql -u root --password=root
echo "GRANT PROXY ON ''@'' TO 'root'@'%' WITH GRANT OPTION" | mysql -u root --password=root

# Restart services.
service apache2 restart
service mysql restart

# Cleanup the default HTML file created by Apache.
rm /var/www/html/index.html

# Mark the box as provisioned.
touch /var/lock/vagrant-provision
