module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
}

module "ecr" {
  source = "./modules/ecr"
}

# 1. ALB Module (Creates the Load Balancer and Target Group)
module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = aws_security_group.alb_sg.id
  certificate_arn   = module.acm.certificate_arn # ✅ Still reads cleanly from your certificates.tf!
}

# 2. ECS Module consumes the Target Group FROM the ALB module output
module "ecs" {
  source             = "./modules/ecs"
  public_subnet_ids  = module.vpc.public_subnet_ids
  ecr_repository_url = module.ecr.repository_url
  ecs_sg_id          = aws_security_group.ecs_sg.id
  target_group_arn   = module.alb.target_group_arn 
  depends_on = [
    module.alb
  ]
}

# 3. DNS Module reads the ALB attributes
module "dns" {
  source       = "./modules/dns"
  alb_dns_name = module.alb.dns_name
  alb_zone_id  = module.alb.zone_id 
}

# 4. Fixed Root Output matching your actual ALB module outputs
output "alb_dns_name" {
  value = module.alb.dns_name 
}
module "acm" {
  source = "./modules/acm" # ◄── Points to your local custom module folder

  project_name = "it-tools"
  domain_name  = "it-tools.humblehotheads.com"
  zone_id      = "Z0681268194PMVM3PTLNZ" # Replace with your real Route 53 Zone ID

  subject_alternative_names = [
    "it-tools.humblehotheads.com"
  ]
}