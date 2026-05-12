variable "project_name" {
  default = "tm"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "azs" {
  default = ["eu-west-2a", "eu-west-2b"]
}