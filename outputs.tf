output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}
output "igw_id" {
  value = module.vpc.igw_id
}

output "ecr_repository_url" {
  value = module.ecr.repository_url # 'repository_url' must match the name in the module file above
}