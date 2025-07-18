
module "backend" {
    source  = "terraform-aws-modules/ec2-instance/aws"
    name ="${var.project_name}-${var.environment}-backend"
    instance_type = "t3.micro"
    vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id.value]

    #Convert StringList to list and get first element
    #subnet_id = element(split(",",data.aws_ssm_parameter.public_subnet_ids.value),0)
    subnet_id = local.private_subnet_id

    ami   = data.aws_ami.ami_info.id
    tags =merge(
        var.common_tags,
        {
            name ="${var.project_name}-${var.environment}-backend"
        }
    )
}
module "frontend" {
    source  = "terraform-aws-modules/ec2-instance/aws"
    name ="${var.project_name}-${var.environment}-frontend"
    instance_type = "t3.micro"
    vpc_security_group_ids = [data.aws_ssm_parameter.frontend_sg_id.value]

    #Convert StringList to list and get first element
    #subnet_id = element(split(",",data.aws_ssm_parameter.public_subnet_ids.value),0)
    subnet_id = local.public_subnet_id

    ami   = data.aws_ami.ami_info.id
    tags =merge(
        var.common_tags,
        {
            name ="${var.project_name}-${var.environment}-frontend"
        }
    )
}
module "ansible" {
    source  = "terraform-aws-modules/ec2-instance/aws"
    name ="${var.project_name}-${var.environment}-ansible"
    instance_type = "t3.micro"
    vpc_security_group_ids = [data.aws_ssm_parameter.ansible_sg_id.value]

    #Convert StringList to list and get first element
    #subnet_id = element(split(",",data.aws_ssm_parameter.public_subnet_ids.value),0)
    subnet_id = local.public_subnet_id
    #user_data = file("expense.sh")
    user_data = file("${path.module}/expense.sh")

    ami   = data.aws_ami.ami_info.id
    tags =merge(
        var.common_tags,
        {
            name ="${var.project_name}-${var.environment}-ansible"
        }
    )
    depends_on = [ module.frontend,module.backend ]
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 3.0"

  zone_name = var.zone_name

  records = [
    {
      name    = "backend"
      type    = "A"
       ttl     = 1
      records = [
        module.backend.private_ip
      ]
    },
    {
      name    = "frontend"
      type    = "A"
       ttl     = 1
      records = [
        module.frontend.public_ip
      ]
    }
    # ,
    #  {
    #   name    = "" # we will get here public ip i.e lingaiah.online
    #   type    = "A"
    #    ttl     = 1
    #   records = [
    #     module.frontend.public_ip
    #   ]
    # }
  ]
}