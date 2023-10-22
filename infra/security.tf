
resource "aws_security_group" "main" {
  name_prefix = var.gh_repo_name
  description = "Security group for ${var.gh_repo_name}"
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }
}
