output "dashboard_name" {
  value = aws_cloudwatch_dashboard.this.dashboard_name
}
output "alerts_topic_arn" {
  value = aws_sns_topic.alerts.arn
}
output "monitored_function" {
  value = aws_lambda_function.heartbeat.function_name
}
