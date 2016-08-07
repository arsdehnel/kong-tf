output "proxy_ip" {
    value = "${module.proxy.public_ip}"
}
output "kong_dns" {
	value = "${module.elb.dns_name}"
}
output "dashboard_ip" {
  value = "${module.dashboard.public_ip}"
}