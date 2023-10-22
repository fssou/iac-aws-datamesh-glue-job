locals {
    database_name = "db_data_world"
    table_name    = "tb_covid_19_data_resource_hub_covid_19_case_counts"
}

resource "aws_glue_job" "main" {
  depends_on = [
    aws_glue_connection.main,
    aws_glue_security_configuration.main,
  ]
  name                   = var.gh_repo_name
  description            = "Glue job for ${var.gh_repo_name}"
  role_arn               = aws_iam_role.glue_job.arn
  glue_version           = 3.0
  max_retries            = 0
  worker_type            = "G.025X"
  execution_class        = "flex"
  security_configuration = aws_glue_security_configuration.main.name
  connections = [
    aws_glue_connection.main.name
  ]
  command {
    script_location = "${var.s3_bucket_path_glue_assets}/src/main/scala/in/francl/data/datamesh/glue/GlueApp.scala"
  }
  default_arguments = {
    "--job-language" = "scala"
    "--class"        = "in.francl.data.datamesh.glue.GlueApp"
    "--extra-jars"   = "${var.s3_bucket_path_glue_assets}/target/app.jar"
    "--SOURCE_PATH"  = "${var.s3_bucket_path_datamesh_raw_data}/${local.database_name}/${local.table_name}/*"
    "--TARGET_PATH"  = "${var.s3_bucket_path_datamesh_sor_data}/${local.database_name}/${local.table_name}"
  }
  execution_property {
    max_concurrent_runs = 1
  }
  tags = {
    "Name" = var.gh_repo_name
  }
}

resource "aws_glue_connection" "main" {
  depends_on = [
    aws_security_group.main,
  ]
  name            = var.gh_repo_name
  description     = "Glue connection for ${var.gh_repo_name}"
  connection_type = upper("NETWORK")
  physical_connection_requirements {
    availability_zone = var.availability_zone
    security_group_id_list = [
      aws_security_group.main.id
    ]
    subnet_id = data.aws_subnet.main.cidr_block
  }
}

resource "aws_glue_security_configuration" "main" {
  name = var.gh_repo_name
  encryption_configuration {
    cloudwatch_encryption {
      cloudwatch_encryption_mode = "DISABLED"
    }
    s3_encryption {
      s3_encryption_mode = "SSE-KMS"
      kms_key_arn = data.aws_kms_key.s3_default.arn
    }
    job_bookmarks_encryption {
      job_bookmarks_encryption_mode = "DISABLED"
    }
  }
}
