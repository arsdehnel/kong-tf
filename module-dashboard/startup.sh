#!/bin/bash
# THIS IS THE NODE VERSION WHICH WAS FAILING
# sudo curl --silent --location https://rpm.nodesource.com/setup_4.x | sudo bash -
# sudo yum -y install nodejs
# # the nodesource curl and install mentioned this as maybe something we might need
# # yum install -y gcc-c++ make 
# sudo npm install -g kong-dashboard
# # sudo kong-dashboard start -p 80
# npm start

# # VAGRANT
# sudo apt-get -y update
# sudo apt-get -y install virtualbox
# sudo apt-get -y install vagrant
# sudo apt-get -y install virtualbox-dkms
# sudo apt-get -y install git
# git clone https://github.com/PGBI/kong-dashboard.git
# cd kong-dashboard


# NPM
# sudo apt-get -y install nodejs
# sudo apt-get -y install npm
# npm install -g kong-dashboard




# # Pull repository
# git clone https://github.com/PGBI/kong-dashboard.git
# cd kong-dashboard

# # Start VM
# vagrant up

# # Ssh into VM
# vagrant ssh

# # Start Kong dashboard
# cd /vagrant
# npm start








# sudo curl --silent --location https://releases.hashicorp.com/vagrant/1.8.1/vagrant_1.8.1_x86_64.rpm
# sudo curl --silent --location https://releases.hashicorp.com/vagrant/1.8.1/vagrant_1.8.1_x86_64.deb

# git clone https://github.com/PGBI/kong-dashboard.git
# cd kong-dashboard

# # Start VM
# vagrant up

# # Ssh into VM
# vagrant ssh

# # Start Kong dashboard
# cd /vagrant
# npm start






##############################
# FROM SOURCE                #
##############################
# sudo curl --silent --location https://rpm.nodesource.com/setup_4.x | sudo bash -
# sudo yum -y install nodejs
# sudo yum -y install git
# git clone https://github.com/PGBI/kong-dashboard.git
# cd kong-dashboard
# sudo npm install -g bower
# bower update
# npm install
# # npm install forever -g
# npm start
# # forever start
# sudo apt-get -y update
# sudo apt-get -y install nginx
# sudo service nginx start


# sudo apt-get -y install nodejs
# sudo npm install -g kong-dashboard

# might need to install bower globally for this to work
sudo apt-get -y update
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get -y install git
sudo apt-get -y install nodejs
sudo apt-get -y install npm
sudo npm install -g forever
git clone https://github.com/PGBI/kong-dashboard.git
cd kong-dashboard
npm install
# npm start
forever start ./bin/kong-dashboard.js start