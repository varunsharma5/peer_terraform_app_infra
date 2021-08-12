data "terraform_remote_state" "network_details" {
  backend = "s3"
  config = {
    bucket = "peer.review.02-varun-sharma-bucket"
    key = "peer.review.02-network-state"
    region = var.region
  } 
}

resource "random_string" "random" {
  length           = 5
  special          = true
  override_special = "-"
}

module "webserver" {
  source = "./modules/linux_node"
  instance_count = var.instance_count_webserver
  ami = var.web_instance_ami
  instance_type = "t3.micro"
  key_name = data.terraform_remote_state.network_details.outputs.ssh_key_pair
  subnet_id = data.terraform_remote_state.network_details.outputs.public_subnet
  vpc_security_group_ids = data.terraform_remote_state.network_details.outputs.webserver_security_group_id_array
  ssh_user_name = "centos"
  tags = {
    Name = "${var.webserver_prefix}-${random_string.random.result}"
    "X-Contact" = "varun.sharma@progress.com"
    "X-Dept" = "PS"
    "X-Production" = "No"
    "X-TTL" = "15"
    "X-Do-NOT-REMOVE" = "Yes"
  }
  chef_policy_name = "tomcat"
}

module "loadbalancer" {
  source = "./modules/linux_node"
  instance_count = var.instance_count_loadbalancer
  ami = var.lb_instance_ami
  instance_type = "t3.micro"
  key_name = data.terraform_remote_state.network_details.outputs.ssh_key_pair
  subnet_id = data.terraform_remote_state.network_details.outputs.public_subnet
  vpc_security_group_ids = data.terraform_remote_state.network_details.outputs.webserver_security_group_id_array
  ssh_user_name = "ubuntu"
  tags = {
    Name = "${var.loadbalancer_prefix}-${random_string.random.result}"
    "X-Contact" = "varun.sharma@progress.com"
    "X-Dept" = "PS"
    "X-Production" = "No"
    "X-TTL" = "15"
    "X-Do-NOT-REMOVE" = "Yes"
  }
  chef_policy_name = "haproxy_lb"
  depends_on = [module.webserver]
}

# module "web_docker_host" {
#   source = "./modules/linux_node"
#   instance_count = var.instance_count_web_docker_host
#   ami = var.instance_ami
#   instance_type = "t3.micro"
#   key_name = data.terraform_remote_state.network_details.outputs.ssh_key_pair
#   subnet_id = data.terraform_remote_state.network_details.outputs.my_subnet
#   vpc_security_group_ids = data.terraform_remote_state.network_details.outputs.security_group_id_array
#   tags = {
#     Name = var.web_docker_host_prefix
#   }
#   chef_policy_name = "web_docker_host"
# }

# module "lb_docker_host" {
#   source = "./modules/linux_node"
#   instance_count = 0
#   ami = var.instance_ami
#   instance_type = "t3.micro"
#   key_name = data.terraform_remote_state.network_details.outputs.ssh_key_pair
#   subnet_id = data.terraform_remote_state.network_details.outputs.my_subnet
#   vpc_security_group_ids = data.terraform_remote_state.network_details.outputs.security_group_id_array
#   tags = {
#     Name = var.lb_docker_host_prefix
#   }
#   chef_policy_name = "lb_docker_host"
#   depends_on = [module.web_docker_host]
# }

# module "k8s_control_plane" {
#   source = "./modules/linux_node"
#   instance_count = 0
#   ami = var.instance_ami
#   instance_type = "t2.medium"
#   key_name = data.terraform_remote_state.network_details.outputs.ssh_key_pair
#   subnet_id = data.terraform_remote_state.network_details.outputs.my_subnet
#   vpc_security_group_ids = data.terraform_remote_state.network_details.outputs.security_group_id_array
#   tags = {
#     Name = var.k8s_control_plane_host_prefix
#   }
#   chef_policy_name = "k8s_control_plane"
# }

# module "k8s_worker_node" {
#   source = "./modules/linux_node"
#   instance_count = 0
#   ami = var.instance_ami
#   instance_type = "t2.small"
#   key_name = data.terraform_remote_state.network_details.outputs.ssh_key_pair
#   subnet_id = data.terraform_remote_state.network_details.outputs.my_subnet
#   vpc_security_group_ids = data.terraform_remote_state.network_details.outputs.security_group_id_array
#   tags = {
#     Name = var.k8s_worker_node_host_prefix
#   }
#   chef_policy_name = "k8s_worker_node"
# }
