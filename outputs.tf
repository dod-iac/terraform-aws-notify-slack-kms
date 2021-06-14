
output "slack_kms_key_id" {
  value       = aws_kms_key.notify_slack_webhook_url.id
  description = "The KMS Key to encrypt Slack Webhook URLs"
}

output "sns_topic_arn" {
  value       = module.slack_alerts.this_sns_topic_arn
  description = "The ARN of the SNS topic"
}
