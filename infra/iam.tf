resource "aws_iam_role" "glue_job" {
  path               = "/iamsr/"
  name               = var.gh_repo_name
  assume_role_policy = data.aws_iam_policy_document.glue_job_assume_role.json
}

resource "aws_iam_role_policy_attachment" "glue_job_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.glue_job.name
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
