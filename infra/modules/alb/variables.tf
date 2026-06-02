variable "vpc_id" {}
variable "public_subnet_ids" { type = list(string) }
variable "alb_sg_id" {}

# These variables are required for the ALB module to create the Application Load Balancer and its associated resources. The vpc_id is needed to associate the ALB with the correct VPC, public_subnet_ids are needed to place the ALB in the correct subnets, and alb_sg_id is needed to associate the ALB with the correct security group.