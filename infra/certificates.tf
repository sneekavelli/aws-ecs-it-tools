data "aws_route53_zone" "primary" {
  name         = "humblehotheads.com"
  private_zone = false
}
