provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.aws_region}"
}

resource "aws_key_pair" "kong" {
    key_name = "${var.key_name}"
    public_key = "${file(var.public_key_path)}"
}

module "vpc" {
    source           = "module-vpc"

    environment      = "${var.environment}"
    stack_name       = "${var.stack_name}"
    name_prefix      = "${var.name_prefix}"
}

module "public_subnet" {
    source           = "module-subnet"

    vpc_id           = "${module.vpc.vpc_id}"
    cidr             = "10.0.0.0/24"
    route_table_id   = "${module.vpc.main_route_table_id}"
    az               = "${var.aws_az}"
    environment      = "${var.environment}"
    stack_name       = "${var.stack_name}"
    name             = "${var.name_prefix}Public"
    public           = true
}

module "proxy_subnet" {
    source           = "module-subnet"

    vpc_id           = "${module.vpc.vpc_id}"
    cidr             = "10.0.1.0/24"
    route_table_id   = "${module.vpc.main_route_table_id}"
    az               = "${module.public_subnet.az}"
    environment      = "${var.environment}"
    stack_name       = "${var.stack_name}"
    name             = "${var.name_prefix}Proxy"
    public           = true
}

module "cassandra_subnet" {
    source           = "module-subnet"

    vpc_id           = "${module.vpc.vpc_id}"
    cidr             = "10.0.2.0/24"
    route_table_id   = "${module.vpc.main_route_table_id}"
    az               = "${module.public_subnet.az}"
    environment      = "${var.environment}"
    stack_name       = "${var.stack_name}"
    name             = "${var.name_prefix}Cassandra"
    public           = true
}

module "bastion" {
    source           = "module-bastion"

    environment      = "${var.environment}"
    stack_name       = "${var.stack_name}"
    key_pair_id      = "${aws_key_pair.kong.id}"
    bastion_ami      = "${lookup(var.aws_amis, var.aws_region)}"
    vpc_id           = "${module.vpc.vpc_id}"
    public_subnet_id = "${module.public_subnet.id}"
    name_prefix      = "${var.name_prefix}"
}

module "dashboard" {
    source           = "module-dashboard"

    environment      = "${var.environment}"
    stack_name       = "${var.stack_name}"
    key_pair_id      = "${aws_key_pair.kong.id}"
    dashboard_ami    = "${lookup(var.aws_amis, var.aws_region)}"
    vpc_id           = "${module.vpc.vpc_id}"
    public_subnet_id = "${module.public_subnet.id}"
    private_key_path = "${var.private_key_path}"
    name_prefix      = "${var.name_prefix}"
}

module "proxy" {
    source                  = "module-proxy"

    # depends_on              = "${module.cassandra.id}"
    environment             = "${var.environment}"
    stack_name              = "${var.stack_name}"
    key_pair_id             = "${aws_key_pair.kong.id}"
    proxy_ami               = "${lookup(var.aws_kong_amis, var.aws_region)}"
    vpc_id                  = "${module.vpc.vpc_id}"
    proxy_subnet_id         = "${module.proxy_subnet.id}"
    private_key_path        = "${var.private_key_path}"   
    elb_sec_grp_id          = "${module.elb.security_group_id}" 
    name_prefix             = "${var.name_prefix}"
    cassandra_instance_id   = "${module.cassandra.id}"
    depends_id              = "${module.cassandra.depends_id}"
}

module "cassandra" {
    source                  = "module-cassandra"

    environment             = "${var.environment}"
    stack_name              = "${var.stack_name}"
    key_pair_id             = "${aws_key_pair.kong.id}"
    cassandra_ami           = "${lookup(var.aws_cassandra_amis, var.aws_region)}"
    vpc_id                  = "${module.vpc.vpc_id}"
    cassandra_subnet_id     = "${module.cassandra_subnet.id}"
    private_key_path        = "${var.private_key_path}"   
    proxy_sec_grp_id        = "${module.proxy.security_group_id}"
    name_prefix             = "${var.name_prefix}"
}

module "elb" {
	source                  = "module-elb"

	environment             = "${var.environment}"
	stack_name              = "${var.stack_name}"
    vpc_id                  = "${module.vpc.vpc_id}"
	public_subnet_id        = "${module.public_subnet.id}"
	proxy_instance_id       = "${module.proxy.instance_id}"
    name_prefix             = "${var.name_prefix}"
}