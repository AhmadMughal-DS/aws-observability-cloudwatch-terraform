variable "name_prefix" {
  type = string
}
variable "environment" {
  type = string
}
variable "aws_region" {
  type = string
}
variable "alarm_email" {
  type    = string
  default = ""
}
variable "lambda_zip_path" {
  type = string
}
variable "lambda_zip_hash" {
  type = string
}
