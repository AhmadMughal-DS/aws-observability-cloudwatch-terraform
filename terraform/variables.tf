variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name prefix applied to all resources"
  type        = string
  default     = "ahmad-observability"
}

variable "alarm_email" {
  description = "Optional email to receive alarm notifications (leave empty to skip)"
  type        = string
  default     = ""
}
