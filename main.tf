/*
 * # Terraform AWS Notify Slack
 *
 * ## Description
 *
 * Terraform module which creates SNS topic and Lambda function which sends notifications to Slack with KMS keys pre-configured
 *
 * See the original [notify-slack](https://registry.terraform.io/modules/terraform-aws-modules/notify-slack/aws/latest) for more details.
 *
 * ## Usage
 *
 * ``` hcl
 * module "notify_slack" {
 *   source = "dod-iac/notify-slack-kms/aws"
 *   version = "1.0.0"
 *
 *   ssm_namespace = "/project-app"
 * }
 * ```
 *
 * Using AWS SSM Parameter Store you will need to create these variables:
 *
 * * `/project-app/notify_slack_webhook_url`
 * * `/project-app/notify_slack_channel`
 * * `/project-app/notify_slack_username`
 * * `/project-app/notify_slack_emoji` (without `:` symbols)
 *
 * The variable `/project-app/notify_slack_webhook_url` should be the webhook url where the SNS topic will post.
 * The URL uses a KMS key to encode it so the lambda function doesn't expose the value.
 *
 */

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
