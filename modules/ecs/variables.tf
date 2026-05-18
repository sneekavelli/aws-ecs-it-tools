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

# These variables are required for the ECS module to create the ECS cluster, service, and task definition. The ecr_repository_url is needed to specify the container image in the task definition, public_subnet_ids are needed to place the ECS tasks in the correct subnets, ecs_sg_id is needed to associate the ECS tasks with the correct security group, and target_group_arn is needed to register the ECS service with the ALB target group for load balancing.