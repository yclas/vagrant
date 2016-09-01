#!/bin/bash

# Updating repository
echo -e '\n****************\nUpdating repository';
sudo apt-get -y update

# Installing Apache
echo -e '\n****************\nInstalling Apache';
sudo apt-get -y install apache2 -y

# Installing PHP and it's dependencies
echo -e "\n****************\nInstalling PHP and it's dependencies";
# sudo apt-get -y install php5 libapache2-mod-php5 php5-mcrypt

sudo apt-get install python-software-properties -y > /dev/null
sudo add-apt-repository ppa:ondrej/php5-5.6 -y > /dev/null
sudo apt-get update > /dev/null
sudo apt-get install -y php5 > /dev/null

#echo "Installing PHP"
sudo apt-get install php5-common php5-dev php5-cli php5-fpm -y > /dev/null

# Installing git
# echo -e '\n****************\nInstalling git';
# sudo apt-get install git -y

# Cloning openclassifieds2 from git
# echo -e "\n****************\nCloning openclassifieds2 from git";
# cd ../..
# cd var/www/
# sudo git clone https://github.com/open-classifieds/openclassifieds2
# cd openclassifieds2/oc
# sudo git clone https://github.com/open-classifieds/common
# cd ../..
# sudo cp -r openclassifieds2/* html/
# sudo rm -rf html/index.html
cd /var/www/html/
sudo wget https://raw.githubusercontent.com/open-classifieds/openclassifieds2/master/install-openclassifieds.php
sudo rm -rf index.html

# Enable short_open_tag
echo -e "\n****************\nEnable short_open_tag";
cd ../../../
sudo sed -i 's/short_open_tag = Off/short_open_tag = On/g' /etc/php5/cli/php.ini
sudo sed -i 's/short_open_tag = Off/short_open_tag = On/g' /etc/php5/apache2/php.ini
sudo service apache2 restart

# Install cURL
echo -e "\n****************\nInstall cURL";
sudo apt-get install curl php5-curl -y
sudo service apache2 restart

# Install GD
echo -e "\n****************\nInstall GD";
sudo apt-get install php5-gd -y
sudo service apache2 restart

# Install mysqli
echo -e "\n****************\nInstall mysqli";
sudo apt-get install php5-mysql -y
sudo service apache2 restart

# Install mcrypt
echo -e "\n****************\nInstall mcrypt";
sudo apt-get install php5-mcrypt -y
sudo mv -i /etc/php5/apache2/conf.d/20-mcrypt.ini /etc/php5/mods-available/
php5enmod mcrypt
service apache2 restart

# Set www-data permissions
echo -e "\n****************\nSet www-data permissions";
sudo chown -R root:root /var/www
sudo chown -R www-data:www-data /var/www/*
sudo chmod -R 755 /var/www/*

# Preparing MySQL
echo -e "\n****************\nPreparing MySQL";
sudo apt-get install debconf-utils -y > /dev/null
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password 1234"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password 1234"

# Installing MySQL
echo -e "\n****************\nInstalling MySQL";
sudo apt-get install mysql-server -y > /dev/null

# Create database
#echo "\n\n********\nCreate database openclassifieds";
echo "CREATE DATABASE openclassifieds" | mysql -u root -p'1234'


# Cleaning the directory from temp files that vagrant fails to delete
echo -e "\n****************\nCleaning the directory from temp files that vagrant fails to delete";
cd vagrant
sudo rm -rf d20* vagrant20*

# Enable mod_rewrite
echo -e "\n****************\nEnable mod_rewrite";
sudo a2enmod rewrite
sudo service apache2 restart
cd ..
sudo cp /vagrant/000-default.conf /etc/apache2/sites-available/
sudo service apache2 restart

sudo cp /vagrant/reoc.lo.conf /etc/apache2/sites-available/
sudo a2ensite reoc.lo.conf
sudo service apache2 restart

echo -e "\n****************\nInstall postfix";
debconf-set-selections <<< "postfix postfix/mailname string reoc.lo"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
sudo apt-get install postfix -y
sudo service postfix reload

echo -e "\n****************\nInstall Unzip";
sudo apt-get install unzip



