resource "aws_ecr_repository" "app" {
  name                 = "it-tools-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true # Automatically checks your code for vulnerabilities
  }
}
# This resource creates an ECR repository named "it-tools-app" with mutable image tags and enables automatic vulnerability scanning on image push. The repository URL will be outputted for use in other modules, such as the ECS task definition where you specify the container image.