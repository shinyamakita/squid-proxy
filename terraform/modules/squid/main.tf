module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 5.0"

  cluster_name = local.cluster_name

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }

  tags = local.common_tags
}

resource "aws_ecs_task_definition" "squid" {
  family                   = local.task_family_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  task_role_arn           = aws_iam_role.ecs_task_role.arn
  execution_role_arn      = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "squid"
      image     = var.container_image
      essential = true
      task_role_arn      = aws_iam_role.ecs_task_role.arn
      execution_role_arn = aws_iam_role.ecs_execution_role.arn
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "PROXY_IP"
          value = aws_eip.squid.public_ip
        }
      ]
      healthCheck = {
        command     = ["CMD-SHELL", "nc -z localhost 3128 || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.squid.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "squid"
        }
      }
    }
  ])

  tags = local.common_tags
}

resource "aws_ecs_service" "squid" {
  name            = local.service_name
  cluster         = module.ecs_cluster.cluster_id
  task_definition = aws_ecs_task_definition.squid.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  health_check_grace_period_seconds = 60  # ヘルスチェックの猶予期間を追加

  network_configuration {
    subnets          = [var.subnet_id]
    security_groups  = [var.security_group_id]
    assign_public_ip = true
  }

  tags = local.common_tags
}