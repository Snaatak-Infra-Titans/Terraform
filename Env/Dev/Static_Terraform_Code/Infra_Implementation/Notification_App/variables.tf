variable "aws_region" {
  type = string
}

variable "environment" {
  type = string
}

variable "application" {
  type = string
}

variable "owner" {
  type = string
}

variable "cost_center" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "key_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "asg_min_size" {
  type        = number
  description = "Minimum number of instances in ASG"
}

variable "asg_max_size" {
  type        = number
  description = "Maximum number of instances in ASG"
}

variable "asg_desired_capacity" {
  type        = number
  description = "Desired number of instances in ASG"
}

variable "cpu_target_value" {
  type        = number
  description = "Target CPU utilization percentage for ASG scaling"
}

variable "ami_owner_id" {
  type        = string
  description = "AWS Account ID of the Custom AMI owner"
}

variable "ami_name" {
  type        = string
  description = "Name of the golden AMI for the Notification app"
}

variable "ssm_instance_profile" {
  type        = string
  description = "Name of the manually created IAM Instance Profile for SSM"
}
