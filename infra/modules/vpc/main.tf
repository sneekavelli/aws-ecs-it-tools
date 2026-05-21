resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags       = { Name = "it-tools-vpc" }
}
# This resource creates a Virtual Private Cloud (VPC) in AWS with the CIDR block specified by var.vpc_cidr. The VPC serves as the foundational network layer for your infrastructure, allowing you to create subnets, route tables, and other networking components that will host your ECS services and ALB. The tags help identify the VPC in the AWS console.

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags       = { Name = "it-tools-igw" }
}
# This resource creates an Internet Gateway and attaches it to the VPC. The Internet Gateway allows resources within the VPC to communicate with the internet, which is essential for your ALB to receive traffic from users and for your ECS tasks to access external services if needed.

resource "aws_subnet" "public" {
  for_each          = var.public_subnet_numbers
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${each.value}.0/24"
  availability_zone = each.key
  tags              = { Name = "public-${each.key}" }
}

# This resource creates public subnets in the VPC. The for_each loop iterates over the var.public_subnet_numbers variable, which should be a map of availability zones to subnet numbers (e.g., { "eu-west-2a" = 1, "eu-west-2b" = 2 }). Each subnet is assigned a CIDR block based on the subnet number and is tagged for identification. These public subnets will host the ALB and allow it to receive traffic from the internet.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "public-rt" }
}


resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# This resource creates a route table for the public subnets and defines a route that directs all outbound traffic (