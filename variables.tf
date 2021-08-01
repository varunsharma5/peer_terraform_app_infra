variable "region" {
  default = "ap-south-1"
}

variable "instance_count_webserver" {
  default = "1"
}
variable "instance_count_loadbalancer" {
  default = "0"
}
# variable "instance_count_web_docker_host" {
#   default = "0"
# }
variable "instance_ami" {
  default = "ami-0b1fd547bf5aae708" # x86_64 CentOS_7
}
variable "webserver_prefix" {
  default = "peer.review.02-webserver-vm-centos-2"
}
# variable "loadbalancer_prefix" {
#   default = "student.201-loadbalancer-vm"
# }
# variable "web_docker_host_prefix" {
#   default = "student.201-web_docker_host"
# }
# variable "lb_docker_host_prefix" {
#   default = "student.201-lb_docker_host"
# }
# variable "k8s_control_plane_host_prefix" {
#   default = "student.201-k8s_control_plane"
# }
# variable "k8s_worker_node_host_prefix" {
#   default = "student.201-k8s_worker_node"
# }
