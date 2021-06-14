
// Slack Notifications via SMS
data "aws_ssm_parameter" "notify_slack_webhook_url" {
  name = "${var.ssm_namespace}/notify_slack_webhook_url"
}

data "aws_ssm_parameter" "notify_slack_channel" {
  name = "${var.ssm_namespace}/notify_slack_channel"
}

data "aws_ssm_parameter" "notify_slack_username" {
  name = "${var.ssm_namespace}/notify_slack_username"
}

data "aws_ssm_parameter" "notify_slack_emoji" {
  name = "${var.ssm_namespace}/notify_slack_emoji"
}
