# initialize these but they really get their values from the terraform.tfvars
variable "access_key" {}
variable "secret_key" {}
variable "public_key_path" {}
variable "private_key_path" {}
variable "name_prefix" {}
variable "key_name" {}
variable "environment" {}

variable "stack_name" {
	default = "tf-kong"
}

variable "aws_region" {
    default = "us-west-2"
}
variable "aws_az" {
	default = "us-west-2a"
}

# Basic AMIs that are currently just used for the Bastion
variable "aws_amis" {
    default = {
        us-east-1 = "ami-b8b061d0"
        us-west-2 = "ami-ef5e24df"
    }
}

# this is just a base Amazon Linux AMI
variable "aws_kong_amis" {
	default = {
		us-east-1 = "ami-1ecae776"
		us-west-1 = "ami-d114f295"
		us-west-2 = "ami-e7527ed7"
		eu-west-1 = "ami-a10897d6"
		ap-northeast-1 = "ami-cbf90ecb"
		ap-southeast-1 = "ami-68d8e93a"
		ap-southeast-2 = "ami-fd9cecc7"
		sa-east-1 = "ami-b52890a8"
	}
}

# these are the datastax cassandra AMIs that come preconfigured with Cassandra
variable "aws_cassandra_amis" {
	default = {
		us-east-1 = "ami-ada2b6c4"
		us-west-1 = "ami-3cf7c979"
		us-west-2 = "ami-1cff962c"
		eu-west-1 = "ami-7f33cd08"
		ap-northeast-1 = "ami-714a3770"
		ap-southeast-1 = "ami-b47828e6"
		ap-southeast-2 = "ami-55d54d6f"
		sa-east-1 = "ami-1dda7800"
	}
}
