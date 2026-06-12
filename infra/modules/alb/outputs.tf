output "dns_name" {
  value       = aws_lb.main.dns_name
  description = "The public DNS name of the ALB"
}

output "zone_id" {
  value       = aws_lb.main.zone_id
  description = "The Route 53 Hosted Zone ID of the ALB"
}

output "target_group_arn" {
  value       = aws_lb_target_group.app.arn  # ◄── Updated .main to .app
  description = "The ARN of the target group created inside the ALB module"
}
