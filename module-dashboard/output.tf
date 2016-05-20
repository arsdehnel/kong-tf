output "public_ip" {
	value = "${aws_instance.dashboard.public_ip}"
}