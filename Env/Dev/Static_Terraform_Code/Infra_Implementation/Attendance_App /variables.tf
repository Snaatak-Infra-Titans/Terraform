variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region to deploy resources"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Deployment environment name"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags for all resources"
  default = {
    Application = "otms"
    Owner       = "Infra-Titans"
    CostCenter  = "Snaatak"
  }
}
