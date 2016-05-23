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

# echo "##################################" >> hosts
# echo "# Cassandra connection information" >> hosts
# echo "# from terraform startup script:" >> hosts
# echo "database: cassandra" >> hosts
# echo "cassandra:" >> hosts
# echo "  contact_points:" >> hosts
# sed -i $'/# cassandra:/{r hosts\n d}' /etc/kong/kong.yml

# cassandra:
  ######
  ## Contact points to your Cassandra cluster.
  # contact_points:
  #   - "127.0.0.1:9042"

# # get cassandra instance details

# # jam that into /etc/kong/kong.yml
# # sed -i $'/# cassandra:/{r hosts\\n d}' /etc/kong/kong.yml",


# ************************************************************************
# START
# now that we have Kong downloaded we can start it up using the 
# configuration file that we scp'd from our local machine that
# contains the contact_points for the cassandra instance
# ************************************************************************

# # start Kong
# /usr/local/bin/kong start -c /home/ec2-user/kong.yml

# this is some basic stuff to prove the instance is up and running
# sudo yum -y update
# sudo yum -y install nginx
# sudo service nginx start    



                # "echo \"database: cassandra\" >> hosts\n",
                # "echo \"cassandra:\" >> hosts\n",
                # "echo \"  contact_points:\" >> hosts\n",
                # "cassandra_hosts=",
                # {
                #   "Fn::GetAtt": [
                #     "CassandraWaitCondition",
                #     "Data"
                #   ]
                # },
                # "\n",
                # "cassandra_hosts=$(echo $cassandra_hosts | awk -F\"{\" '{print $2}')\n",
                # "cassandra_hosts=$(echo $cassandra_hosts | awk -F\"}\" '{print $1}')\n",
                # "IFS=', ' read -a host_array <<< \"$cassandra_hosts\"\n",
                # "for i in \"${host_array[@]}\"\n",
                # "do\n",
                # "   hostName=$(echo $i | awk -F\":\" '{print $1}')\n",
                # "   echo -e \"    - $hostName\"  >> hosts\n",
                # "done;\n",
                # "sed -i $'/# cassandra:/{r hosts\\n d}' /etc/kong/kong.yml\n",
