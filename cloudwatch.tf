
module "cloudwatch_kms_key" {
  source  = "dod-iac/cloudwatch-kms-key/aws"
  version = "~> 1.0.0"

  name = format("alias/%s-sns-cloudwatch-kms", var.name)
  tags = var.tags
}
