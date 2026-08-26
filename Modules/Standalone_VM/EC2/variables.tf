variable "application" {
  description = "Application or component name."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "owner" {
  description = "Resource owner."
  type        = string
}

variable "instance_name" {
  description = "Name of the standalone EC2 instance."
  type        = string
}

variable "ami_id" {
  description = "AMI ID used to launch the instance."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Private subnet ID where the instance is launched."
  type        = string
}

variable "private_ip" {
  description = "Fixed private IPv4 address within the selected subnet."
  type        = string
}

variable "security_group_ids" {
  description = "Security group IDs attached to the instance."
  type        = list(string)
}

variable "iam_instance_profile" {
  description = "SSM-enabled IAM instance profile name."
  type        = string
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB."
  type        = number
  default     = 20
}

variable "root_volume_type" {
  description = "Root EBS volume type."
  type        = string
  default     = "gp3"
}

variable "user_data" {
  description = "Optional user data. Database configuration is performed later by Ansible CD."
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional custom tags."
  type        = map(string)
  default     = {}
}
