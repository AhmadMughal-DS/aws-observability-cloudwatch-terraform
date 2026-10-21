locals {
  name_prefix = var.project_name
}

data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/../src"
  output_path = "${path.module}/build/heartbeat.zip"
}

module "observability" {
  source          = "./modules/observability"
  name_prefix     = local.name_prefix
  environment     = var.environment
  aws_region      = var.aws_region
  alarm_email     = var.alarm_email
  lambda_zip_path = data.archive_file.lambda.output_path
  lambda_zip_hash = data.archive_file.lambda.output_base64sha256
}
