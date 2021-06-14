
variable "name" {
  type        = string
  default     = "sns"
  description = "A unique name for the module"
}

variable "tags" {
  type        = map
  default     = {}
  description = "tags for resources"
}

variable "ssm_namespace" {
  type        = string
  description = "The namespace for AWS SSM"
}

variable "cloudwatch_log_group_retention_in_days" {
  type        = number
  description = "Specifices the number of days to retain logs from cloudwatch"
  default     = 90
}
