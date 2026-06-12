# 1.update Route 53 Data source to target your real domain
data "aws_route53_zone" "primary" {
  name         = "humblehotheads.com." # Notice the trailing dot—Route 53 requires this format!
  private_zone = false
}

# 2. Update your record mapping to use your real hosted subdomain URL
resource "aws_route53_record" "app_dns" {
  zone_id = "Z0681268194PMVM3PTLNZ" # Plugs your exact Hosted Zone ID straight into Terraform
  name    = "it-tools.humblehotheads.com" # This will be the live public URL for your application!
  type    = "A"

 alias {
    name                   = var.alb_dns_name  
    zone_id                = var.alb_zone_id   
    evaluate_target_health = true
  }
}