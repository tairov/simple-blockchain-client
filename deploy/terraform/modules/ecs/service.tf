data "template_file" "client_service_template" {
  template = file("client-service.json.tpl")

  vars = {
    region  = var.region
    project = var.project
    env     = var.env
    image   = var.image
    tag     = var.tag
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  container_definitions    = data.template_file.client_service_template.rendered
  family                   = "${var.project}-${var.env}-ecs-task-def"
  cpu                      = 2048
  memory                   = 4096
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  execution_role_arn = aws_iam_role.fargate_iam_role.arn
  task_role_arn      = aws_iam_role.fargate_iam_role.arn
}

resource "aws_ecs_service" "ecs-service-1" {
  cluster = aws_ecs_cluster.ecs-1.name
  name    = "${var.project}-${var.env}-ecs-service-app"
  # task_definition must be update from ci/cd as well
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 1
  launch_type     = var.ecs_launch_type

  wait_for_steady_state   = false
  enable_execute_command  = true
  enable_ecs_managed_tags = true
  propagate_tags          = "TASK_DEFINITION"

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets = [var.subnet_1_id, var.subnet_2_id]
    # list of security groups
    security_groups  = var.app_security_groups
    assign_public_ip = false
  }

  load_balancer {
    container_name   = "web"
    container_port   = 80
    target_group_arn = var.web_target_group_arn
  }

  lifecycle {
    ignore_changes = [
      task_definition,
    ]
  }
}
