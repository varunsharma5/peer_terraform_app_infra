resource "aws_instance" "my_vm" {
  count = var.instance_count
  ami = var.ami
  subnet_id = var.subnet_id
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  tags = var.tags

  provisioner "local-exec" {
    command = "sleep 90; knife bootstrap ${self.public_ip} -U centos -i ~/varun-chef-key.pem --sudo -N ${self.public_ip} --policy-name ${var.chef_policy_name} --policy-group staging -c ~/.chef/config.rb --ssh-verify-host-key=never --chef-license accept"
  }

  provisioner "remote-exec" {
    connection {
      host = self.public_ip
      type = "ssh"
      user = "centos"
      agent = false
      private_key = file("~/varun-chef-key.pem")
    }
    inline = [
      "sudo chef-client -l info"
    ]
 }

 provisioner "local-exec" {
  when = "destroy"
  command = "knife node delete -y ${self.public_ip} -c ~/.chef/config.rb --chef-license accept"
  on_failure = continue
 }

 provisioner "local-exec" {
  when = "destroy"
  command = "knife client delete -y ${self.public_ip} -c ~/.chef/config.rb --chef-license accept"
  on_failure = continue
 }
}
