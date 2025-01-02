resource "aws_eip" "squid" {
  domain = "vpc"
  tags   = merge(local.common_tags, {
    Name = "${local.name_prefix}-eip"
  })
}