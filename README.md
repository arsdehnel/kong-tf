# Kong Terraform

This uses (Terraform)[http://terraform.io] to create an AWS environment for (Kong)[http://getkong.org].  As of this original posting it's definitely not done but getting close enough that it's hopefully something for others to start from, reference or work on as a community.  

## Creator's Note

I'm quite new to Terraform, AWS and Kong so this is combining a lot of new things for me.  Please let me know if there is a best practice I should be following that I'm not but please also be nice about it.

## Assumptions

As of the initial version, this configuration assumes you're creating Kong in AWS into it's own VPC and you'll be using a (Bastion)[https://blogs.aws.amazon.com/security/post/Tx3N8GFK85UN1G6/Securely-connect-to-Linux-instances-running-in-a-private-Amazon-VPC] to control SSH access into your network.