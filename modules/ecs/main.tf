resource "aws_ecs_cluster" "main" {
  name = "it-tools-cluster"
}

resource "aws_ecs_service" "main" {
  name            = "it-tools-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = true  # <--- PLACE IT HERE
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "it-tools"
    container_port   = 8080
  }
}


resource "aws_ecs_task_definition" "app" {
  family                   = "it-tools-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  
  # This line tells the task which "ID card" (Role) to use to pull the image
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "it-tools"
    image     = "${var.ecr_repository_url}:latest"
    essential = true
    portMappings = [{
      containerPort = 8080
      hostPort      = 8080
    }]
  }])
}

resource "aws_iam_role" "ecs_task_execution_role" {
  # This name is what AWS sees in the console
  name = "it-tools-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

# This attaches the standard AWS managed policy for ECR pulling to your role
resource "aws_iam_role_policy_attachment" "ecs_execution_role_ecr" {
  role       = "it-tools-ecs-execution-role" # Make sure this matches your role name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}