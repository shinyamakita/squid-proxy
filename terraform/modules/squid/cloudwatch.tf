# CloudWatch Logs
resource "aws_cloudwatch_log_group" "squid" {
  name              = "/ecs/squid"
  retention_in_days = 30

  tags = local.common_tags
}