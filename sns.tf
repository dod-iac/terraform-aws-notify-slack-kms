# KMS Key to Encrypt for the Slack Webhook URL
data "aws_iam_policy_document" "notify_slack_webhook_url_policy_doc" {
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
}

resource "aws_kms_key" "notify_slack_webhook_url" {
  description             = "Key used to encrypt Slack Webhook URLs."
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 30
  policy                  = data.aws_iam_policy_document.notify_slack_webhook_url_policy_doc.json
  enable_key_rotation     = true
  tags                    = var.tags
}

resource "aws_kms_alias" "notify_slack_webhook_url" {
  name          = format("alias/%s-slack-webhook-url", var.name)
  target_key_id = aws_kms_key.notify_slack_webhook_url.key_id
}

module "sns_kms_key" {
  source = "dod-iac/sns-kms-key/aws"

  name        = format("alias/%s-sns-key", var.name)
  description = format("A SNS key used to encrypt SNS messages at rest for %s.", var.name)
  tags        = var.tags
}

module "slack_alerts" {
  source  = "terraform-aws-modules/sns/aws"
  version = "~> 2.0"

  name              = format("%s-service-degradation", var.name)
  create_sns_topic  = true
  kms_master_key_id = module.sns_kms_key.aws_kms_key_arn
}

# Encrypt the URL, storing encryption here will show it in logs and in tfstate
# https://www.terraform.io/docs/state/sensitive-data.html
resource "aws_kms_ciphertext" "notify_slack_webhook_url" {
  plaintext = data.aws_ssm_parameter.notify_slack_webhook_url.value
  key_id    = aws_kms_key.notify_slack_webhook_url.arn
}

module "notify_slack" {
  source  = "terraform-aws-modules/notify-slack/aws"
  version = "~> 4.14"

  lambda_function_name = format("%s-notify-slack", var.name)
  sns_topic_name       = format("%s-service-degradation", var.name)
  create_sns_topic     = false

  slack_webhook_url = aws_kms_ciphertext.notify_slack_webhook_url.ciphertext_blob
  slack_channel     = data.aws_ssm_parameter.notify_slack_channel.value
  slack_username    = data.aws_ssm_parameter.notify_slack_username.value
  slack_emoji       = data.aws_ssm_parameter.notify_slack_emoji.value

  kms_key_arn          = aws_kms_key.notify_slack_webhook_url.arn
  sns_topic_kms_key_id = module.sns_kms_key.aws_kms_key_arn

  cloudwatch_log_group_kms_key_id        = module.cloudwatch_kms_key.aws_kms_key_arn
  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days

  lambda_description = format("Lambda function which sends notifications to Slack for %s", var.name)

  tags                      = var.tags
  cloudwatch_log_group_tags = var.tags
  iam_role_tags             = var.tags
  lambda_function_tags      = var.tags
  sns_topic_tags            = var.tags

  depends_on = [
    module.slack_alerts,
  ]
}
