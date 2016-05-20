output "security_group_id" {
  value = "${aws_security_group.elb.id}"
}
output "dns_name" {
	value = "${aws_elb.elb.dns_name}"
}