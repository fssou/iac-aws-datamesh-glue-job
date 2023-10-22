
data "aws_caller_identity" "main" {}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "main" {
  filter {
    name = "vpc-id"
    values = [
      data.aws_vpc.default.id
    ]
  }
}

data "aws_subnet" "main" {
  vpc_id = data.aws_vpc.default.id
  availability_zone = var.availability_zone
}

data "aws_kms_key" "s3_default" {
  key_id = "alias/aws/s3"
}
