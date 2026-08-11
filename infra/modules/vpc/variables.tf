variable "infra_env" {
  type        = string
  default     = ""
  description = "infrastructure environment"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "The range to use for the VPC, in CIDR notation. Default is 10.0.0.0/16"
}

variable "public_subnet_numbers" {
  type = map(number)
  default = {
    "eu-west-2a" = 1
    "eu-west-2b" = 2
  }
  description = "Map of availability zones to public subnet numbers."
}

variable "private_subnet_numbers" {
  type = map(number)
  default = {
    "eu-west-2a" = 3
    "eu-west-2b" = 4
  }
  description = "Map of availability zones to private subnet numbers."
}

variable "private_subnet_cidrs" {
  type = map(string)

  default = {
    "eu-west-2a" = "10.0.3.0/24"
    "eu-west-2b" = "10.0.4.0/24"
  }

  description = "Map of availability zones to CIDR blocks for private subnets."
}
