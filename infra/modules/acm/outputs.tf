output "certificate_arn" {
  value       = aws_acm_certificate_validation.this.certificate_arn
  description = "The ARN of the fully validated SSL certificate"
}