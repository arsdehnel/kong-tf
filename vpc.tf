################################
#  VPC                         #
################################
resource "aws_vpc" "kong_qa" {
  	cidr_block = "10.0.0.0/16"
	tags {
		Name = "${var.stack_name}_VPC"
		Application = "Kong"
		Environment = "QA"
    }
}

################################
#  IGW                         #
################################
resource "aws_internet_gateway" "kong_qa" {
	vpc_id = "${aws_vpc.kong_qa.id}"
	tags {
		Name = "${var.stack_name}_IGW"
		Application = "Kong"
        Environment = "QA"
    }
}

################################
#  ROUTE TABLE                 #
################################
resource "aws_route" "internet_access_qa" {
	route_table_id         = "${aws_vpc.kong_qa.main_route_table_id}"
	destination_cidr_block = "0.0.0.0/0"
	gateway_id             = "${aws_internet_gateway.kong_qa.id}"
}

################################
#  PUBLIC SUBNET               #
################################
resource "aws_subnet" "public_qa_subnet" {
	vpc_id                  = "${aws_vpc.kong_qa.id}"
	cidr_block              = "10.0.3.0/24"
	tags {
		Name = "${var.stack_name}_public"
		Application = "Kong"
		Environment = "QA"
    }
}
resource "aws_route_table_association" "public_qa_route_table_assoc" {
    subnet_id = "${aws_subnet.public_qa_subnet.id}"
    route_table_id = "${aws_vpc.kong_qa.main_route_table_id}"
}

################################
#  KONG SUBNET                 #
################################
resource "aws_subnet" "proxy_qa_subnet" {
	vpc_id                  = "${aws_vpc.kong_qa.id}"
	cidr_block              = "10.0.1.0/24"
	tags {
		Name = "${var.stack_name}_proxy"
		Application = "Kong"
		Environment = "QA"
    }
}
resource "aws_route_table_association" "proxy_qa_route_table_assoc" {
    subnet_id = "${aws_subnet.proxy_qa_subnet.id}"
    route_table_id = "${aws_vpc.kong_qa.main_route_table_id}"
}

################################
#  CASSANDRA SUBNET            #
################################
resource "aws_subnet" "cassandra_qa_subnet" {
	vpc_id                  = "${aws_vpc.kong_qa.id}"
	cidr_block              = "10.0.2.0/24"
	tags {
		Name = "${var.stack_name}_cassandra"
		Application = "Kong"
		Environment = "QA"
    }
}
resource "aws_route_table_association" "cassandra_qa_route_table_assoc" {
    subnet_id = "${aws_subnet.cassandra_qa_subnet.id}"
    route_table_id = "${aws_vpc.kong_qa.main_route_table_id}"
}
