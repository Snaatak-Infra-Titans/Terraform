variable "aws_region" {
  description = "AWS region where the infrastructure resources will be deployed."
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, qa, staging, prod)."
  type        = string
}

variable "application" {
  description = "Name of the application for which the infrastructure is being provisioned."
  type        = string
}

variable "cost_center" {
  description = "Cost center used for resource tagging and cost allocation."
  type        = string
}

variable "owner" {
  description = "Owner or team responsible for managing the infrastructure resources."
  type        = string
}
