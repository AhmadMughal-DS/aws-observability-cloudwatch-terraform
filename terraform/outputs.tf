output "dashboard_name" {
  description = "CloudWatch dashboard name"
  value       = aws_cloudwatch_dashboard.this.dashboard_name
}

output "alerts_topic_arn" {
  description = "SNS topic that receives alarm notifications"
  value       = aws_sns_topic.alerts.arn
}

output "monitored_function" {
  description = "Heartbeat Lambda being monitored"
  value       = aws_lambda_function.heartbeat.function_name
}
