output "alb_dns_name" {
    value       = aws_lb.main.dns_name
    description = "The DNS name of the load balancer"
}
# Output the DNS name of the ALB so it can be used in other modules or output at the root level
output "target_group_arn" {
  value = aws_lb_target_group.app.arn
}
# Output the ARN of the Target Group so it can be used in other modules (e.g., to register ECS tasks as targets)

