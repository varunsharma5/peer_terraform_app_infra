output "webserver_vm_public_ip" {
  value = module.webserver.*.public_ip
}
output "lb_vm_public_ip" {
  value = module.loadbalancer.*.public_ip
}
output "mysqlserver_vm_public_ip" {
  value = module.mysqlserver.*.public_ip
}
output "lb_dnsname" {
  value = aws_route53_record.dns_record.name
}