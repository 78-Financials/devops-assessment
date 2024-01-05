resource "aws_ecs_cluster" "payaza_test_ecs_cluster" {
  name = "payaza-test-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = {
    "Name"        = "payaza-test-cluster"
    "Environment" = "dev"
  }
}

resource "aws_ecs_service" "simple_api" {
  name            = "simple-api-service"
  cluster         = aws_ecs_cluster.payaza_test_ecs_cluster.id
  task_definition = aws_ecs_task_definition.payaza_test-simple-api.id
  launch_type     = "FARGATE"
  desired_count   = 1
  load_balancer {
    target_group_arn = var.simple-api-target-group-arn
    container_name   = "simple-api"
    container_port   = 8000
  }
  network_configuration {
    subnets          = var.public_subnets
    assign_public_ip = true
    security_groups  = [var.simple-api-sg]
  }

  depends_on = [
    var.payaza_test_lb
  ]
}

resource "aws_ecs_task_definition" "payaza_test-simple-api" {
  family                = "payaza-test-simple-api"
  container_definitions = <<TASK_DEFINITION
[
        {
            "name": "simple-api",
            "image": "972440475321.dkr.ecr.eu-west-2.amazonaws.com/payaza-devops-assessment:latest",
            "cpu": 0,
            "portMappings": [
                {
                    "name": "simple-api-tg",
                    "containerPort": 8000,
                    "hostPort": 8000,
                    "protocol": "tcp",
                    "appProtocol": "http"
                }
            ],
            "essential": true,
            "environment": [
              {"name": "S3_BUCKET_NAME", "value": "payaza-devops-assessment-test-bucket"},
              {"name": "S3_FILE_KEY", "value": "assessment.json"}
            ],
            "mountPoints": [],
            "volumesFrom": [],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-create-group": "true",
                    "awslogs-group": "/ecs/payaza-test-simple-api",
                    "awslogs-region": "eu-west-2",
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ]
TASK_DEFINITION

  network_mode             = "awsvpc"
  execution_role_arn       = var.payaza_test_execution_role
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  task_role_arn            = var.payaza_test_execution_role
}
