#!/bin/bash
sudo wget -O kong.rpm downloadkong.org/aws.rpm
sudo yum install -y epel-release
sudo yum install -y kong.rpm --nogpgcheck

# # get cassandra instance details

# # jam that into /etc/kong/kong.yml
# # sed -i $'/# cassandra:/{r hosts\\n d}' /etc/kong/kong.yml",

# # start kong
# /usr/local/bin/kong start

# this is some basic stuff to prove the instance is up and running
# sudo yum -y update
# sudo yum -y install nginx
# sudo service nginx start    