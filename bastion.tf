resource "aws_security_group" "bastion" {
  name = "${var.stack_name}_bastion"
  description = "Allow SSH traffic from the internet"
  vpc_id = "${aws_vpc.kong_qa.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_access_from_bastion" {
  name = "${var.stack_name}-allow-access-from-bastion"
  description = "Grants access to SSH from bastion server"
  vpc_id = "${aws_vpc.kong_qa.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = ["${aws_security_group.bastion.id}"]
  }
}

resource "aws_instance" "bastion" {
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  depends_on = ["aws_security_group.bastion"]
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public_qa_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]

  tags {
    Name = "${var.stack_name}-bastion"
    Application = "Kong"
    Environment = "QA"
  }
}

resource "aws_eip" "bastion" {
  instance = "${aws_instance.bastion.id}"
  depends_on = ["aws_instance.bastion"]
  vpc = true
}
