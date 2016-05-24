provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.aws_region}"
}

module "dashboard" {
    source           = "module-dashboard"

    environment      = "${var.environment}"
    stack_name       = "${var.stack_name}"
    key_pair_id      = "kong"
    dashboard_ami    = "${lookup(var.aws_amis, var.aws_region)}"
    vpc_id           = "vpc-7a02bb1e"
    public_subnet_id = "subnet-fbf5719f"
    private_key_path = "${var.private_key_path}"
    name_prefix      = "${var.name_prefix}"
}

module "proxy" {
    source                  = "module-proxy"

    # depends_on              = "${module.cassandra.id}"
    environment             = "${var.environment}"
    stack_name              = "${var.stack_name}"
    key_pair_id             = "kong"
    proxy_ami               = "${lookup(var.aws_kong_amis, var.aws_region)}"
    vpc_id                  = "vpc-7a02bb1e"
    proxy_subnet_id         = "subnet-fbf5719f"
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
    key_pair_id             = "kong"
    cassandra_ami           = "${lookup(var.aws_cassandra_amis, var.aws_region)}"
    vpc_id                  = "vpc-7a02bb1e"
    cassandra_subnet_id     = "subnet-fbf5719f"
    private_key_path        = "${var.private_key_path}"   
    proxy_sec_grp_id        = "${module.proxy.security_group_id}"
    name_prefix             = "${var.name_prefix}"
}

module "elb" {
	source                  = "module-elb"

	environment             = "${var.environment}"
	stack_name              = "${var.stack_name}"
    vpc_id                  = "vpc-7a02bb1e"
	public_subnet_id        = "subnet-fbf5719f"
	proxy_instance_id       = "${module.proxy.instance_id}"
    name_prefix             = "${var.name_prefix}"
}