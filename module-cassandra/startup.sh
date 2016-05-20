#!/bin/bash

####################################################################
# Copied the indented bits below from the CloudFormation script    #
# the unindented lines are the new versions                        #
####################################################################


    #                 "apt-get -y install python-setuptools\n",
sudo apt-get -y install python-setuptools

    #                 "easy_install https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz\n",
    #                 "publicip=`curl http://169.254.169.254/latest/meta-data/public-ipv4`\n",
    #                 "publichost=`curl http://169.254.169.254/latest/meta-data/public-hostname`\n",
    #                 "cfn-signal -e 0 --data $publicip --id $publichost --reason \"Kong setup completed\" '",
    #                 {
    #                   "Ref": "CassandraWaitHandle"
    #                 },
    #                 "'\n",
    #                 "--clustername ",
    #                 {
    #                   "Ref": "CassandraClusterName"
    #                 },
    #                 " --totalnodes ",
    #                 {
    #                   "Ref": "CassandraFleetSize"
    #                 },
    #                 " --version ",
    #                 {
    #                   "Ref": "CassandraClusterVersion"
    #                 },
    #                 " --release ",
    #                 {
    #                   "Ref": "CassandraVersion"
    #                 },
    #                 "\n"

# this is some basic stuff to prove the instance is up and running
# sudo apt-get -y update
# sudo apt-get -y install nginx
# sudo service nginx start       