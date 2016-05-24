#!/bin/bash
# ************************************************************************
# KONG DOWNLOAD
# start by downloading Kong so it's ready for running
# ************************************************************************
sudo wget -O kong.rpm downloadkong.org/aws.rpm
sudo yum install -y epel-release
sudo yum install -y kong.rpm --nogpgcheck

# ************************************************************************
# CASSANDRA DETAILS
# since the mapping to Cassandra is dynamic we need to add some config
# information here at runtime to find those instances so Kong can 
# connect to them when we run the `kong start` command
# ************************************************************************

cp /etc/kong/kong.yml kong.yml

echo "##################################" >> kong.yml
echo "# Cassandra connection information" >> kong.yml
echo "# from terraform startup script:" >> kong.yml
echo "database: cassandra" >> kong.yml
echo "cassandra:" >> kong.yml
echo "  contact_points:" >> kong.yml
echo "    - ec2-54-186-44-46.us-west-2.compute.amazonaws.com" >> kong.yml

# sed -i $'/# cassandra:/{r hosts\n d}' kong.yml

# cassandra:
  ######
  ## Contact points to your Cassandra cluster.
  # contact_points:
  #   - "127.0.0.1:9042"

# ************************************************************************
# START
# now that we have Kong downloaded we can start it up using the 
# configuration file that we scp'd from our local machine that
# contains the contact_points for the cassandra instance
# ************************************************************************

# # start Kong
/usr/local/bin/kong start -c /home/ec2-user/kong.yml