output "vpc_id" {
  value = aws_vpc.main.id
}
# This output provides the ID of the VPC created in this module. The VPC ID is essential for referencing the VPC in other modules (e.g., when creating subnets, security groups, or when associating resources with the VPC).
output "public_subnet_ids" {
  value = [for s in aws_subnet.public : s.id]
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}
