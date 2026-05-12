resource "aws_ecr_repository" "app" {
  name                 = "it-tools-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true # Automatically checks your code for vulnerabilities
  }
}