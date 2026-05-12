variable "ecr_repository_url" {
  description = "The URL of the ECR repository"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "ecs_sg_id" {
  description = "The security group ID for the ECS tasks"
  type        = string
}

variable "target_group_arn" {
  description = "The ARN of the Load Balancer target group"
  type        = string
}

# Add any other variables below ONLY if they aren't already listed above