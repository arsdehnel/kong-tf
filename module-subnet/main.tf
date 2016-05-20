variable "name" {}
variable "stack_name" {}
variable "environment" {}
variable "cidr" {}
variable "vpc_id" {}
variable "route_table_id" {}
variable "public" {}
variable "az" {}

resource "aws_subnet" "standard" {
	vpc_id                  = "${var.vpc_id}"
	cidr_block              = "${var.cidr}"
	map_public_ip_on_launch = "${var.public}"
	availability_zone       = "${var.az}"

	tags {
		Name = "${var.name}"
		stack_name = "${var.stack_name}"
		environment = "${var.environment}"
    }
}

resource "aws_route_table_association" "public_qa_route_table_assoc" {
    subnet_id = "${aws_subnet.standard.id}"
    route_table_id = "${var.route_table_id}"
}

output "id" {
	value = "${aws_subnet.standard.id}"
}
output "az" {
	value = "${aws_subnet.standard.availability_zone}"
}