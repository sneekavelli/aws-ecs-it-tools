module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  # variables VPC module needs...
}


module "ecr" {
  source = "./modules/ecr"
}

module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = aws_security_group.alb_sg.id
}
#alb needs the ALB security group ID, which is created in security.tf and referenced here as aws_security_group.alb_sg.id

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
#alb_dns_name is the output from the ALB module, which we can reference here to output it at the root level.

module "ecs" {
  source             = "./modules/ecs"
  public_subnet_ids  = module.vpc.public_subnet_ids
  ecr_repository_url = module.ecr.repository_url
  ecs_sg_id          = aws_security_group.ecs_sg.id
  target_group_arn   = module.alb.target_group_arn
}
#ecs needs the public subnet IDs, ECR repository URL, ECS security group ID, and ALB target group ARN. We pass all of these in as variables to the ECS module.