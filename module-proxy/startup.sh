#!/bin/bash


sudo wget -O kong.rpm downloadkong.org/aws.rpm

    # "yum install -y epel-release\n",
sudo yum install -y epel-release

    # "yum install -y kong.rpm --nogpgcheck\n",
sudo yum install -y kong.rpm --nogpgcheck

# # get cassandra instance details

# # jam that into /etc/kong/kong.yml
# # sed -i $'/# cassandra:/{r hosts\\n d}' /etc/kong/kong.yml",

# # start kong
# /usr/local/bin/kong start

# this is some basic stuff to prove the instance is up and running
sudo yum -y update
sudo yum -y install nginx
sudo service nginx start    

####################################################################
# Copied the indented bits below from the CloudFormation script    #
# the unindented lines are the new versions                        #
####################################################################

    # "#!/bin/bash\n",
    # "yum update -y aws-cfn-bootstrap\n",
    # "echo '* soft nofile 65000' >> /etc/security/limits.conf\n",
    # "echo '* hard nofile 65000' >> /etc/security/limits.conf\n",
    # "kong_version=",
    # {
    #   "Ref": "KongVersion"
    # },
    # "\n",
    # "if [ -z $kong_version ]\n",
    # "then\n",
    # "   wget -O kong.rpm downloadkong.org/aws.rpm\n",
    # "else\n",
    # "   wget -O kong.rpm downloadkong.org/aws.rpm?version=$kong_version\n",
    # "fi\n",
    # "if [ -e \"./kong.rpm\" ]\n",
    # "then\n",
    # "   echo \"Installing Kong...\" \n",
    # "else\n",
    # "   /opt/aws/bin/cfn-signal -e 1 --stack ",
    # {
    #   "Ref": "AWS::StackName"
    # },
    # " --resource KongScalingGroup ",
    # " --region ",
    # {
    #   "Ref": "AWS::Region"
    # },
    # " --reason \"Failed to download Kong\" \n",
    # "   echo \"failed to download kong, exiting...\" \n",
    # "   exit\n",
    # "fi\n",









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
    # "sleep `echo $(( RANDOM % ( 120 - 30 + 1 ) + 30 ))`\n",
    # "COUNTER=0\n",
    # "while [ $COUNTER -lt 4 ]; do\n",
    # "   /usr/local/bin/kong status\n",
    # "   if [[ $? -ne 0 ]]; then\n",
    # "      echo \"trying to start kong..\"\n",
    # "      su -s /bin/sh -c \"/usr/local/bin/kong start\" ec2-user\n",
    # "      let COUNTER=COUNTER+1\n",
    # "      sleep `echo $(( RANDOM % ( 120 - 30 + 1 ) + 30 ))`\n",
    # "   else\n",
    # "      /opt/aws/bin/cfn-signal -e 0 --stack ",
    # {
    #   "Ref": "AWS::StackName"
    # },
    # " --resource KongScalingGroup ",
    # " --region ",
    # {
    #   "Ref": "AWS::Region"
    # },
    # " --reason \"Kong setup completed\" \n",
    # "      break \n",
    # "   fi\n",
    # "done\n",
    # "if ! /usr/local/bin/kong status; then\n",
    # "   echo \"failed to start kong, exiting...\" \n",
    # "   /opt/aws/bin/cfn-signal -e 1 --stack ",
    # {
    #   "Ref": "AWS::StackName"
    # },
    # " --resource KongScalingGroup ",
    # " --region ",
    # {
    #   "Ref": "AWS::Region"
    # },
    # " --reason \"Failed to start Kong\" \n",
    # "fi\n"

