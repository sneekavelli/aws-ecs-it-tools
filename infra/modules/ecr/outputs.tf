output "repository_url" {
  description = "The URL of the repository to be used in Docker push/pull"
  value       = aws_ecr_repository.app.repository_url
}

output "repository_arn" {
  value = aws_ecr_repository.app.arn
}

