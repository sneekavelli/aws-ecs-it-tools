output "vpc_id" {
  value = aws_vpc.main.id
}
# This output provides the ID of the VPC created in this module. The VPC ID is essential for referencing the VPC in other modules (e.g., when creating subnets, security groups, or when associating resources with the VPC).
output "public_subnet_ids" {
  value = [for s in aws_subnet.public : s.id]
}

# This output provides a list of IDs for the public subnets created in this module. These IDs are essential for referencing the subnets in other modules (e.g., when creating security groups or route tables).

output "igw_id" {
  value = aws_internet_gateway.igw.id
}
