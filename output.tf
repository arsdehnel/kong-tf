# output "cassandra_ip" {
#     value = "${aws_instance.cassandra.public_ip}"
# }
output "proxy_ip" {
    value = "${module.proxy.public_ip}"
}
output "kong_dns" {
	value = "${module.elb.dns_name}"
}
# output "bastion_ip" {
#   value = "${module.bastion.public_ip}"
# }
output "dashboard_ip" {
  value = "${module.dashboard.public_ip}"
}