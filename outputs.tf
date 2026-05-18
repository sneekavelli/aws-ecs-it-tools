output "vpc_id" {
  value = module.vpc.vpc_id
}
# Output the module's VPC ID so it can be used in other modules

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}
# Output the public subnet IDs so they can be used in other modules

output "igw_id" {
  value = module.vpc.igw_id
}
#output the Internet Gateway ID so it can be used in other modules if needed

output "ecr_repository_url" {
  value = module.ecr.repository_url # 'repository_url' must match the name in the module file above
}
# Output the ECR repository URL so it can be used in other modules
