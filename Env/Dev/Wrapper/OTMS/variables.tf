variable "aws_region" {
  description = "AWS region for the Dev environment."
  type        = string
  default     = "us-east-1"
}

variable "expected_aws_account_id" {
  description = "Guardrail: CI and deployment must use this AWS account."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"
}

variable "deployment_phase" {
  description = "Controls whether application Auto Scaling groups remain empty for database preparation or launch application instances."
  type        = string
  default     = "foundation"

  validation {
    condition     = contains(["foundation", "application"], var.deployment_phase)
    error_message = "deployment_phase must be either foundation or application."
  }
}

variable "application" {
  description = "Application name used in resource names and tags."
  type        = string
  default     = "otms"
}

variable "owner" {
  description = "Team that owns the infrastructure."
  type        = string
}

variable "cost_center" {
  description = "Cost allocation tag."
  type        = string
}

variable "vpc_cidr" {
  description = "Dev VPC CIDR."
  type        = string
  default     = "10.0.0.0/24"
}

variable "certificate_arn" {
  description = "Issued us-east-1 ACM certificate covering otms.online and *.otms.online."
  type        = string
}

variable "public_route53_zone_id" {
  description = "Persistent public otms.online hosted zone ID."
  type        = string
}

variable "private_route53_zone_id" {
  description = "Persistent private internal hosted zone ID."
  type        = string
}

variable "application_amis" {
  description = "Previously tested application AMIs used when Packer is skipped."
  type        = map(string)
}

variable "ssm_instance_profile_name" {
  description = "Existing SSM-enabled EC2 instance profile reused by all OTMS instances."
  type        = string
  default     = "dev-otms-ssm-instance-profile"
}

variable "application_instance_type" {
  description = "Instance type used by application Auto Scaling groups."
  type        = string
  default     = "t3.micro"
}

variable "database_instance_types" {
  description = "Instance type for each standalone database VM."
  type        = map(string)
}

variable "tags" {
  description = "Additional tags for the Dev environment."
  type        = map(string)
  default     = {}
}
