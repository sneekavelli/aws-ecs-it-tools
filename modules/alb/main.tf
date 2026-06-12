

resource "aws_lb" "main" {
  name               = "it-tools-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  tags = { Name = "it-tools-alb" }
}
# This resource creates an Application Load Balancer (ALB) in AWS. The ALB is set to be internet-facing (internal = false) and is associated with the security group specified by var.alb_sg_id. It is also placed in the public subnets specified by var.public_subnet_ids. The ALB will be used to route traffic to the ECS service running your application.

resource "aws_lb_target_group" "app" {
  name        = "it-tools-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/" # ◄── CHANGED FROM "/index.html" TO "/"
    port                = "8080"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200-399" # Accept any standard successful redirect or asset load
  }
}
# This resource creates a Target Group for the ALB. The Target Group is configured to listen on port 8080 and uses the HTTP protocol. It is associated with the VPC specified by var.vpc_id. The target type is set to "ip", which means that the ALB will route traffic to IP addresses (in this case, the IPs of the ECS tasks). The health check configuration ensures that the ALB can monitor the health of the targets and route traffic only to healthy instances.
r# 2. Automatically link your certificate to your HTTPS listener dynamically
# 2. Automatically link your certificate to your HTTPS listener dynamically
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    # ◄── UPDATE THIS SPECIFIC LINE RIGHT HERE ──►
    target_group_arn = aws_lb_target_group.app.arn
  }
}