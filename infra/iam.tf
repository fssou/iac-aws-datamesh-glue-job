
resource "aws_iam_role" "glue_job" {
  path               = "/iamsr/"
  name               = var.gh_repo_name
  assume_role_policy = data.aws_iam_policy_document.glue_job_assume_role.json
}

data "aws_iam_policy_document" "glue_job_assume_role" {
  statement {
    effect  = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = [
        "glue.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "glue_job_policy" {
  role       = aws_iam_role.glue_job.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "glue_job_policy" {
  role       = aws_iam_role.glue_job.name
  policy_arn = aws_iam_policy.glue_job_permissions.arn
}

resource "aws_iam_policy" "glue_job_permissions" {
  path = "/iamsr/"
  name = var.gh_repo_name
  policy = data.aws_iam_policy_document.glue_job_permissions.json
}

data "aws_iam_policy_document" "glue_job_permissions" {
  statement {
    effect  = "Allow"
    actions = [
      "glue:*"
    ]
    resources = [
      "*"
    ]
  }
}
