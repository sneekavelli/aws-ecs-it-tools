# 1. ALB Security Group (Allows web traffic from the world)
resource "aws_security_group" "alb_sg" {
  name        = "it-tools-alb-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "HTTP from everywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # Allow all outbound traffic
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

# 2. ECS Security Group (Only allows traffic FROM the ALB)
resource "aws_security_group" "ecs_sg" {
  name        = "it-tools-ecs-sg"
  description = "Allow traffic only from ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 8080 # The port your app runs on
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # The "Senior Move" mentioned earlier
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}