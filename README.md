<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
# Terraform AWS Notify Slack

## Description

Terraform module which creates SNS topic and Lambda function which sends notifications to Slack with KMS keys pre-configured

See the original [notify-slack](https://registry.terraform.io/modules/terraform-aws-modules/notify-slack/aws/latest) for more details.

## Usage

``` hcl
module "notify_slack" {
  source = "dod-iac/notify-slack-kms/aws"
  version = "1.0.0"

  ssm_namespace = "/project-app"
}
```

Using AWS SSM Parameter Store you will need to create these variables:

* `/project-app/notify_slack_webhook_url`
* `/project-app/notify_slack_channel`
* `/project-app/notify_slack_username`
* `/project-app/notify_slack_emoji` (without `:` symbols)

The variable `/project-app/notify_slack_webhook_url` should be the webhook url where the SNS topic will post.
The URL uses a KMS key to encode it so the lambda function doesn't expose the value.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudwatch_kms_key"></a> [cloudwatch\_kms\_key](#module\_cloudwatch\_kms\_key) | dod-iac/cloudwatch-kms-key/aws | ~> 1.0.0 |
| <a name="module_notify_slack"></a> [notify\_slack](#module\_notify\_slack) | terraform-aws-modules/notify-slack/aws | ~> 4.14 |
| <a name="module_slack_alerts"></a> [slack\_alerts](#module\_slack\_alerts) | terraform-aws-modules/sns/aws | ~> 2.0 |
| <a name="module_sns_kms_key"></a> [sns\_kms\_key](#module\_sns\_kms\_key) | dod-iac/sns-kms-key/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.notify_slack_webhook_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_ciphertext.notify_slack_webhook_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_ciphertext) | resource |
| [aws_kms_key.notify_slack_webhook_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.notify_slack_webhook_url_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_ssm_parameter.notify_slack_channel](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.notify_slack_emoji](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.notify_slack_username](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.notify_slack_webhook_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_log_group_retention_in_days"></a> [cloudwatch\_log\_group\_retention\_in\_days](#input\_cloudwatch\_log\_group\_retention\_in\_days) | Specifices the number of days to retain logs from cloudwatch | `number` | `90` | no |
| <a name="input_name"></a> [name](#input\_name) | A unique name for the module | `string` | `"sns"` | no |
| <a name="input_ssm_namespace"></a> [ssm\_namespace](#input\_ssm\_namespace) | The namespace for AWS SSM | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | tags for resources | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_slack_kms_key_id"></a> [slack\_kms\_key\_id](#output\_slack\_kms\_key\_id) | The KMS Key to encrypt Slack Webhook URLs |
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | The ARN of the SNS topic |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
