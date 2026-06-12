module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  # Any other variables your VPC module needs...
}


module "ecr" {
  source = "./modules/ecr"
}

module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = aws_security_group.alb_sg.id
  certificate_arn  = module.acm.certificate_arn  # ◄── Updated this line here!
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

module "ecs" {
  source             = "./modules/ecs"
  public_subnet_ids  = module.vpc.public_subnet_ids
  ecr_repository_url = module.ecr.repository_url
  ecs_sg_id          = aws_security_group.ecs_sg.id
  target_group_arn   = module.alb.target_group_arn
}