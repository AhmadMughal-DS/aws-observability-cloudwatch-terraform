resource "aws_sns_topic" "alerts" {
  name              = "${var.name_prefix}-alerts"
  kms_master_key_id = "alias/aws/sns"
}

resource "aws_sns_topic_subscription" "email" {
  count     = var.alarm_email == "" ? 0 : 1
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

############################
# Heartbeat Lambda (monitored workload)
############################
resource "aws_iam_role" "lambda" {
  name_prefix = "${var.name_prefix}-lambda-"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "heartbeat" {
  function_name    = "${var.name_prefix}-heartbeat"
  role             = aws_iam_role.lambda.arn
  runtime          = "python3.12"
  handler          = "heartbeat.handler"
  filename         = var.lambda_zip_path
  source_code_hash = var.lambda_zip_hash
  timeout          = 10
  tracing_config {
    mode = "Active"
  }
}

resource "aws_cloudwatch_event_rule" "schedule" {
  name                = "${var.name_prefix}-schedule"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule      = aws_cloudwatch_event_rule.schedule.name
  target_id = "heartbeat"
  arn       = aws_lambda_function.heartbeat.arn
}

resource "aws_lambda_permission" "events" {
  statement_id  = "AllowEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.heartbeat.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule.arn
}

############################
# Alarms
############################
resource "aws_cloudwatch_metric_alarm" "errors" {
  alarm_name          = "${var.name_prefix}-lambda-errors"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Heartbeat Lambda reported errors"
  dimensions          = { FunctionName = aws_lambda_function.heartbeat.function_name }
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "duration" {
  alarm_name          = "${var.name_prefix}-lambda-duration"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = 300
  statistic           = "Average"
  threshold           = 3000
  alarm_description   = "Heartbeat Lambda average duration is high"
  dimensions          = { FunctionName = aws_lambda_function.heartbeat.function_name }
  alarm_actions       = [aws_sns_topic.alerts.arn]
}

############################
# Dashboard
############################
resource "aws_cloudwatch_dashboard" "this" {
  dashboard_name = "${var.name_prefix}-dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          title  = "Heartbeat - Invocations & Errors"
          region = var.aws_region
          stat   = "Sum"
          period = 300
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", aws_lambda_function.heartbeat.function_name],
            ["AWS/Lambda", "Errors", "FunctionName", aws_lambda_function.heartbeat.function_name],
          ]
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          title   = "Heartbeat - Duration"
          region  = var.aws_region
          stat    = "Average"
          period  = 300
          metrics = [["AWS/Lambda", "Duration", "FunctionName", aws_lambda_function.heartbeat.function_name]]
        }
      }
    ]
  })
}
