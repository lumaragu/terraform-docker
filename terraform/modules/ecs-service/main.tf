variable "cluster_id" {}
variable "private_subnets" {
  type = list(string)
}
variable "ecr_repository_url" {}

resource "aws_ecs_task_definition" "main" {
  family                   = "my-ecs-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name  = "my-container",
    image = var.ecr_repository_url,
    portMappings = [{
      containerPort = 80,
      hostPort      = 80,
    }],
  }])
}

resource "aws_ecs_service" "main" {
  name            = "my-ecs-service"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.main.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets = var.private_subnets
  }

  depends_on = [aws_ecs_task_definition.main]
}
