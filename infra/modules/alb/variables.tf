variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "The public subnet IDs for the ALB"
}

variable "alb_sg_id" {
  type        = string
  description = "The security group ID for the ALB"
}

variable "certificate_arn" {
  type        = string
  description = "The ARN of the validated ACM certificate"
}

variable "target_group_arn" {
  type        = string
  default     = ""
  description = "Optional target group ARN if passed from outside"
}
