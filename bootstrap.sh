#!/bin/bash

# Updating repository
sudo apt-get -y update

# Installing Apache
sudo apt-get -y install apache2 -y

# Installing PHP and it's dependencies

# sudo apt-get install python-software-properties
# sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
# sudo apt-get update
# sudo apt-get install php7.0 php7.0-fpm php7.0-mysql -y

sudo apt-add-repository ppa:ondrej/php -y
sudo apt-get update
sudo apt-get install -y php7.0 -y

sudo apt-get install php7.0-curl -y

sudo apt-get install php7.0-apc -y

sudo apt-get install php7.0-gd -y

sudo apt-get install php7.0-fpm -y
sudo a2enmod proxy_fcgi setenvif
sudo service apache2 restart
sudo a2enconf php7.0-fpm
sudo service apache2 reload

sudo apt-get install php7.0-mbstring -y

sudo apt-get install php7.0-mcrypt -y

sudo apt-get install php7.0-mysql -y

sudo apt-get install php7.0-xml -y

sudo apt-get install php7.0-zip -y

sudo apt-get install php-soap -y

sudo service apache2 restart

sudo sed -i 's/short_open_tag = Off/short_open_tag = On/g' /etc/php/7.0/cli/php.ini
sudo sed -i 's/short_open_tag = Off/short_open_tag = On/g' /etc/php/7.0/fpm/php.ini
sudo sed -i 's/short_open_tag = Off/short_open_tag = On/g' /etc/php/7.0/apache2/php.ini
sudo service apache2 restart

cd /var/www/html/
sudo wget https://raw.githubusercontent.com/yclas/yclas/master/install-yclas.php
sudo rm -rf index.html

# Set www-data permissions
sudo chown -R root:root /var/www
sudo chown -R www-data:www-data /var/www/*
sudo chmod -R 755 /var/www/*

# Preparing MySQL
sudo apt-get install debconf-utils -y > /dev/null
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password 1234"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password 1234"

# Installing MySQL
sudo apt-get install mysql-server -y > /dev/null

# Create database
echo "CREATE DATABASE openclassifieds" | mysql -u root -p'1234'


# Cleaning the directory from temp files that vagrant fails to delete
cd vagrant
sudo rm -rf d20* vagrant20*

# Enable mod_rewrite
sudo a2enmod rewrite
sudo service apache2 restart
cd ..
sudo cp /vagrant/000-default.conf /etc/apache2/sites-available/
sudo service apache2 restart

sudo cp /vagrant/reoc.lo.conf /etc/apache2/sites-available/
sudo a2ensite reoc.lo.conf
sudo service apache2 restart

# Install postfix
debconf-set-selections <<< "postfix postfix/mailname string reoc.lo"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
sudo apt-get install postfix -y
sudo service postfix reload

# Install Unzip
sudo apt-get install unzip

