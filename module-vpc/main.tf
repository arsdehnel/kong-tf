variable "application" {}
variable "environment" {}
variable "name_prefix" {}

################################
#  VPC                         #
################################
resource "aws_vpc" "main" {
  	cidr_block = "10.0.0.0/16"
	tags {
		Name = "${var.name_prefix}${var.application} - ${var.environment}"
		Application = "${var.application}"
		Environment = "${var.environment}"
    }
}

################################
#  IGW                         #
################################
resource "aws_internet_gateway" "main" {
	vpc_id = "${aws_vpc.main.id}"
	tags {
		Name = "${var.name_prefix}IGW"
		Application = "${var.application}"
        Environment = "${var.environment}"
    }
}

################################
#  ROUTE TABLE                 #
################################
resource "aws_route" "main" {
	route_table_id         = "${aws_vpc.main.main_route_table_id}"
	destination_cidr_block = "0.0.0.0/0"
	gateway_id             = "${aws_internet_gateway.main.id}"
}

################################
#  OUTPUT                      #
################################
output "vpc_id" {
    value = "${aws_vpc.main.id}"
}

output "main_route_table_id" {
	value = "${aws_route.main.route_table_id}"
}