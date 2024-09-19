#First creating security group with modules
#Second attaching dependent ports to security group using aws Security group rule

module "db" {
source ="../../10.terraform-aws-securitygroup"
project_name = var.project_name
environment =  var.environment
sg_description = "SG for DB MySQL Instances"
vpc_id =  data.aws_ssm_parameter.vpc_id.value #We are getting the vpc_id from SSM parameter for DB Security group
common_tags = var.common_tags
sg_name = "db"
}
module "backend" {
source ="../../10.terraform-aws-securitygroup"
project_name = var.project_name
environment =  var.environment
sg_description = "SG for Backend Instances"
vpc_id =  data.aws_ssm_parameter.vpc_id.value #We are getting the vpc_id from SSM parameter for Backend Security group
common_tags = var.common_tags
sg_name = "backend"
}
module "frontend" {
source ="../../10.terraform-aws-securitygroup"
project_name = var.project_name
environment =  var.environment
sg_description = "SG for Frontend Instances"
vpc_id =  data.aws_ssm_parameter.vpc_id.value #We are getting the vpc_id from SSM parameter for Frontend Security group
common_tags = var.common_tags
sg_name = "frontend"
}
module "bastion" {
source ="../../10.terraform-aws-securitygroup"
project_name = var.project_name
environment =  var.environment
sg_description = "SG for Bastion Instances"
vpc_id =  data.aws_ssm_parameter.vpc_id.value #We are getting the vpc_id from SSM parameter for Bastion Security group
common_tags = var.common_tags
sg_name = "bastion"
}
module "ansible" {
source ="../../10.terraform-aws-securitygroup"
project_name = var.project_name
environment =  var.environment
sg_description = "SG for ansible Instances"
vpc_id =  data.aws_ssm_parameter.vpc_id.value #We are getting the vpc_id from SSM parameter for Ansible Security group
common_tags = var.common_tags
sg_name = "ansible"
}

#DB is accepting connections from backend
resource "aws_security_group_rule" "db_backend" {
    type = "ingress"
    from_port = 3306
    to_port =  3306
    protocol = "tcp"
    source_security_group_id = module.backend.sg_id # source is where you are getting traffic from.
    security_group_id = module.db.sg_id  
}
#DB is accepting connections from bastion
resource "aws_security_group_rule" "db_bastion" {
    type = "ingress"
    from_port = 3306
    to_port =  3306
    protocol = "tcp"
    source_security_group_id = module.bastion.sg_id # source is where you are getting traffic from.
    security_group_id = module.db.sg_id
}

#Backend is accepting connections from frontend
resource "aws_security_group_rule" "backend_frontend" {
    type = "ingress"
    from_port = 8080
    to_port =  8080
    protocol = "tcp"
    source_security_group_id = module.frontend.sg_id # source is where you are getting traffic from.
    security_group_id = module.backend.sg_id
}
#Backend is accepting connections from bastion
resource "aws_security_group_rule" "backend_bastion" {
    type = "ingress"
    from_port = 22
    to_port =  22
    protocol = "tcp"
    source_security_group_id = module.bastion.sg_id # source is where you are getting traffic from.
    security_group_id = module.backend.sg_id
}
#Backend is accepting connections from ansible
resource "aws_security_group_rule" "backend_ansible" {
    type = "ingress"
    from_port = 22
    to_port =  22
    protocol = "tcp"
    source_security_group_id = module.ansible.sg_id # source is where you are getting traffic from.
    security_group_id = module.backend.sg_id
}

#Frontend is accepting connections from public
resource "aws_security_group_rule" "frontend_public" {
    type = "ingress"
    from_port = 80
    to_port =  80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.frontend.sg_id
}
#Frontend is accepting connections from bastion
resource "aws_security_group_rule" "frontend_bastion" {
    type = "ingress"
    from_port = 22
    to_port =  22
    protocol = "tcp"
     source_security_group_id = module.bastion.sg_id # source is where you are getting traffic from.
    security_group_id = module.frontend.sg_id
}
#Frontend is accepting connections from ansible
resource "aws_security_group_rule" "frontend_ansible" {
    type = "ingress"
    from_port = 22
    to_port =  22
    protocol = "tcp"
     source_security_group_id = module.ansible.sg_id # source is where you are getting traffic from.
    security_group_id = module.frontend.sg_id
}
#bastion is accepting connections from public
resource "aws_security_group_rule" "bastion_public" {
    type = "ingress"
    from_port = 22
    to_port =  22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.bastion.sg_id
}
#Frontend is accepting connections from public
resource "aws_security_group_rule" "ansible_public" {
    type = "ingress"
    from_port = 22
    to_port =  22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.ansible.sg_id
}
