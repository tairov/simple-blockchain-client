resource "aws_cloudwatch_log_group" "cw-log-group-1" {
  name = "${var.project}-${var.env}-log-group-1"
}

resource "aws_ecs_cluster" "ecs-1" {
  name = "${var.project}-${var.env}-ecs-1"

  capacity_providers = [
    "FARGATE",
  ]

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  lifecycle {
    ignore_changes = [
      tags_all,
      tags,
    ]
  }
}

