output "instance_id" {
	value = "${aws_instance.proxy.id}"
}
output "public_ip" {
	value = "${aws_instance.proxy.public_ip}"
}
output "security_group_id" {
	value = "${aws_security_group.proxy.id}"
}