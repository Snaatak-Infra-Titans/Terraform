variable "aws_region" {
  description = "AWS Region for AMI creation"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type used by Packer to build the AMI"
  type        = string
  default     = "t3.small"
}

variable "subnet_id" {
  description = "Subnet where the temporary EC2 instance will be launched"
  type        = string
}

variable "security_group_id" {
  description = "Security Group attached to the temporary EC2 instance"
  type        = string
}

variable "environment" {
  description = "Deployment Environment"
  type        = string
}

variable "ami_name" {
  description = "Base name for the generated AMI"
  type        = string
}

variable "application" {
  description = "Application name"
  type        = string
}

variable "owner" {
  description = "Resource owner"
  type        = string
}

variable "cost_center" {
  description = "Cost center"
  type        = string
}

variable "ssm_instance_profile" {
  description = "IAM Instance Profile used by the Packer builder instance"
  type        = string
}
