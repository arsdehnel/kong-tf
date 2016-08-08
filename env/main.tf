provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.aws_region}"
}

module "vpc" {
    source                  = "../module-vpc"

    stack_name              = "${var.stack_name}"
    environment             = "${var.environment}"
    name_prefix             = "${var.name_prefix}"
}

module "public_subnet" {
    source                  = "../module-subnet"

    name                    = "public"
    stack_name              = "${var.stack_name}"
    environment             = "${var.environment}"

    cidr                    = "10.0.4.0/23"
    vpc_id                  = "${module.vpc.id}"
    route_table_id          = "${module.vpc.route_table_id}"
    public                  = true
    az                      = "us-west-2b"

}

module "dashboard" {
    source                  = "../module-dashboard"

    stack_name              = "${var.stack_name}"
    environment             = "${var.environment}"
    name_prefix             = "${var.name_prefix}"

    key_pair_id             = "kong"
    dashboard_ami           = "${lookup(var.aws_amis, var.aws_region)}"
    vpc_id                  = "${module.vpc.id}"
    public_subnet_id        = "${module.public_subnet.id}"
    private_key_path        = "${var.private_key_path}"
}

module "proxy" {
    source                  = "../module-proxy"

    stack_name              = "${var.stack_name}"
    environment             = "${var.environment}"
    name_prefix             = "${var.name_prefix}"

    key_pair_id             = "kong"
    proxy_ami               = "${lookup(var.aws_kong_amis, var.aws_region)}"
    vpc_id                  = "${module.vpc.id}"
    proxy_subnet_id         = "${module.public_subnet.id}"
    private_key_path        = "${var.private_key_path}"   
    elb_sec_grp_id          = "${module.elb.security_group_id}" 
    cassandra_dns           = "${module.cassandra.dns}"
}

module "cassandra" {
    source                  = "../module-cassandra"

    stack_name              = "${var.stack_name}"
    environment             = "${var.environment}"
    name_prefix             = "${var.name_prefix}"

    key_pair_id             = "kong"
    ami                     = "${lookup(var.aws_cassandra_amis, var.aws_region)}"
    version                 = "2.2.4"
    vpc_id                  = "${module.vpc.id}"
    subnet_id               = "${module.public_subnet.id}"
    private_key_path        = "${var.private_key_path}"   
    proxy_sec_grp_id        = "${module.proxy.security_group_id}"
    node_count              = "1"
}

module "elb" {
	source                  = "../module-elb"

    stack_name              = "${var.stack_name}"
	environment             = "${var.environment}"
    name_prefix             = "${var.name_prefix}"

    vpc_id                  = "${module.vpc.id}"
	public_subnet_id        = "${module.public_subnet.id}"
	proxy_instance_id       = "${module.proxy.instance_id}"
}