output "repository_url" {
  description = "The URL of the repository to be used in Docker push/pull"
  value       = aws_ecr_repository.app.repository_url
}

output "repository_arn" {
  value = aws_ecr_repository.app.arn
}
# These outputs provide the repository URL and ARN of the ECR repository created in this module. The repository URL is essential for pushing Docker images to ECR and for referencing the image in your ECS task definitions. The ARN can be useful for permissions and other references in your infrastructure.

