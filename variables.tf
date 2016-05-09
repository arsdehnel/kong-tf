variable key_name { 
	default = "kong-qa-tf"
}

variable "access_key" {}
variable "secret_key" {}
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