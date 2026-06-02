variable "project_name" {
  default = "tm"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "azs" {
  default = ["eu-west-2a", "eu-west-2b"]
}
# These variables define the project name, VPC CIDR block, and availability zones for your infrastructure. The project_name can be used for naming resources consistently across your modules. The vpc_cidr defines the IP address range for your VPC, and the azs variable specifies which availability zones to use for creating subnets and other resources, ensuring high availability and fault tolerance.f