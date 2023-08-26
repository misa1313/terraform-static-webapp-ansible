variable "main_email" {}

##########################################################################
# Cloudwatch
##########################################################################

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "HighCpuUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Maximum"
  threshold           = 80
  alarm_description  = "Alarm for CPU utilization > 80%"
  alarm_actions      = [aws_sns_topic.alarm.arn]

  dimensions = {
    InstanceId = aws_instance.static-app.id
  }
}

resource "aws_cloudwatch_metric_alarm" "memory_alarm" {
  alarm_name          = "HighMemoryUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Maximum"
  threshold           = 60
  alarm_description  = "Alarm for memory utilization > 60%"
  alarm_actions      = [aws_sns_topic.alarm.arn]

  dimensions = {
    InstanceId = aws_instance.static-app.id
  }
}

resource "aws_sns_topic" "alarm" {
  name              = "alarm-topic"
  delivery_policy   = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
}

resource "aws_sns_topic_subscription" "alarm-ubscription" {
  topic_arn = aws_sns_topic.alarm.arn
  protocol  = "email"
  endpoint  = var.main_email
}
