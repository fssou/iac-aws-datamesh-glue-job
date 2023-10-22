
resource "aws_security_group" "main" {
  name = var.gh_repo_name
  description = "Security group for ${var.gh_repo_name}"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      data.aws_vpc.default.cidr_block
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}
