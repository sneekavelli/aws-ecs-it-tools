resource "aws_ecs_cluster" "main" {
  name = "it-tools-cluster"
}
# This resource creates an ECS cluster named "it-tools-cluster" where your ECS services and tasks will run. The cluster is a logical grouping of resources that allows you to manage and scale your containerized applications effectively.

resource "aws_ecs_service" "main" {
  name            = "it-tools-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = true 
  }
# This block configures the network settings for the ECS service. It specifies that the service should run in the public subnets defined by var.public_subnet_ids, use the security group defined by var.ecs_sg_id, and assigns a public IP address to each task so they can communicate with the ALB and the internet if needed.
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "it-tools"
    container_port   = 8080
  }
}
# This block configures the load balancer settings for the ECS service. It specifies that the service should be registered with the target group defined by var.target_group_arn, and that the container named "it-tools" should listen on port 8080 for incoming traffic from the ALB. This allows the ALB to route traffic to the ECS tasks running your application.

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
# This resource defines the ECS task that will run your application. It specifies the family name, network mode, compatibility with Fargate, CPU and memory requirements, and the execution role for pulling the container image from ECR. The container definitions specify the name of the container, the image to use (with the latest tag from the ECR repository), and the port mappings to allow traffic on port 8080.

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
# This resource creates an IAM role that ECS tasks will assume when they need to pull the container image from ECR. The assume_role_policy allows the ECS tasks service to assume this role, which is necessary for the tasks to have the permissions needed to access ECR and other AWS services if required.

# This attaches the standard AWS managed policy for ECR pulling to your role
resource "aws_iam_role_policy_attachment" "ecs_execution_role_ecr" {
  role       = "it-tools-ecs-execution-role" # Make sure this matches your role name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# This attachment gives your ECS tasks the necessary permissions to pull images from ECR and perform other actions required for task execution. The AmazonECSTaskExecutionRolePolicy includes permissions for ECR, CloudWatch Logs, and other services that ECS tasks commonly interact with during execution.