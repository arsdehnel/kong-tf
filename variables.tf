# initialize these but they really get their values from the terraform.tfvars
variable "access_key" {}
variable "secret_key" {}
variable "key_name" {}
variable "key_file" {}
variable "stack_name" {
    default = "terraform-kong"
}

variable "aws_region" {
    default = "us-west-2"
}
variable "aws_amis" {
    default = {
        us-east-1 = "ami-b8b061d0"
        us-west-2 = "ami-ef5e24df"
    }
}

variable "aws_kong_amis" {
	default = {
		us-west-2 = "ami-e7527ed7"
	}
}

variable "aws_cassandra_amis" {
	default = {
		us-west-2 = "ami-1cff962c"
	}
}
