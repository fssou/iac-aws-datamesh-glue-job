
variable "gh_repo_id" {
  type = string
}

variable "gh_repo_name" {
  type = string
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "availability_zone" {
    type = string
    default = "us-east-1a"
}

variable "s3_bucket_path_glue_assets" {
  type = string
}

variable "s3_bucket_path_datamesh_raw_data" {
  type = string
}

variable "s3_bucket_path_datamesh_sor_data" {
  type = string
}
