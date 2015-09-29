# Vagrant

## Instructions

1. [Download](http://www.vagrantup.com/downloads) and [install](https://docs.vagrantup.com/v2/installation/index.html) Vagrant

2. [Download](https://www.virtualbox.org/wiki/Downloads) and install VirtualBox

3. Clone repo:

        git clone https://github.com/open-classifieds/vagrant.git
    
        cd vagrant/

4. Boot the environment:

        vagrant up

5. To prove that it is running, you can SSH into the machine: (Optional)

        vagrant ssh

6. Once the machine it's running, load this on your browser:

        http://reoc.lo:4567/install-openclassifieds.php

7. To destroy the virtual machine and remove all traces of the guest machine from your system, run: 

        vagrant destroy

Vagrant fails to remove temp files, so run this after vagrant destroy the virtual machine:

    sudo rm -f d20* vagrant20*


During the Open-Classifieds installation process, for DB Configuration use _Database name_: **openclassifieds** ,_User name_: **root** and _Password_: **1234**




