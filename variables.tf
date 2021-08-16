variable "region" {
  default = "ap-south-1"
}
variable "instance_count_webserver" {
  default = "1"
}
variable "instance_count_loadbalancer" {
  default = "1"
}
variable "instance_count_mysqlserver" {
  default = "0"
}
variable "web_instance_ami" {
  default = "ami-0b1fd547bf5aae708" # x86_64 CentOS_7
}
variable "lb_instance_ami" {
  default = "ami-0aea2242760765801" # x86_64 CentOS_7
}
variable "webserver_prefix" {
  default = "peer.review.02-webserver-vm-centos-2"
}
variable "loadbalancer_prefix" {
  default = "peer.review.02-loadbalancer-vm"
}
variable "mysqlserver_prefix" {
  default = "peer.review.02-mysqlserver-vm"
}
variable "host_zone_id" {
  default = "Z085947422RTR2LQUT9Q"
}
variable "route53_a_record_name" {
  default = "webserver.varun.chefsuccess.io"
}
