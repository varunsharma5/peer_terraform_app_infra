variable "region" {
  default = "ap-south-1"
}
variable "instance_count_webserver" {
  default = "0"
}
variable "instance_count_loadbalancer" {
  default = "0"
}
variable "instance_count_mysqlserver" {
  default = "1"
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
