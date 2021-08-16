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
    "Tier" = "web"
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
    "Tier" = "lb"
  }
  chef_policy_name = "haproxy_lb"
  depends_on = [module.webserver]
}

module "mysqlserver" {
  source = "./modules/linux_node"
  instance_count = var.instance_count_mysqlserver
  ami = var.lb_instance_ami
  instance_type = "t3.micro"
  key_name = data.terraform_remote_state.network_details.outputs.ssh_key_pair
  subnet_id = data.terraform_remote_state.network_details.outputs.public_subnet
  vpc_security_group_ids = data.terraform_remote_state.network_details.outputs.mysqlserver_security_group_id_array
  ssh_user_name = "ubuntu"
  tags = {
    Name = "${var.mysqlserver_prefix}-${random_string.random.result}"
    "X-Contact" = "varun.sharma@progress.com"
    "X-Dept" = "PS"
    "X-Production" = "No"
    "X-TTL" = "15"
    "X-Do-NOT-REMOVE" = "Yes"
    "Tier" = "database"
  }
  chef_policy_name = "mysql_config"
}

resource "aws_route53_record" "dns_record" {
  zone_id = var.host_zone_id
  name    = var.route53_a_record_name
  type    = "A"
  ttl     = "300"
  records = [module.loadbalancer.public_ip.0]

  depends_on = [module.loadbalancer]
}