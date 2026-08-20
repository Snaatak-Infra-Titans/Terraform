####################################
# Standard Tags
####################################

variable "application" {
  description = "Application name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "owner" {
  description = "Resource owner"
  type        = string
}

####################################
# EC2 Configuration
####################################

variable "instance_name" {
  description = "Name of the standalone EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID used to launch the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

####################################
# Networking
####################################

variable "subnet_id" {
  description = "Existing subnet ID where the instance will be launched"
  type        = string
}

variable "security_group_ids" {
  description = "Existing security group IDs to attach to the instance"
  type        = list(string)
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
  default     = false
}

####################################
# IAM
####################################

variable "iam_instance_profile" {
  description = "Existing IAM instance profile to attach to the EC2 instance"
  type        = string
  default     = null
}

####################################
# Root Volume
####################################

variable "root_volume_size" {
  description = "Size of the root EBS volume in GB"
  type        = number
  default     = 20
}

variable "root_volume_type" {
  description = "Type of the root EBS volume"
  type        = string
  default     = "gp3"
}

variable "delete_on_termination" {
  description = "Whether the root EBS volume should be deleted when the instance is terminated"
  type        = bool
  default     = true
}

####################################
# User Data
####################################

variable "user_data" {
  description = "Optional user data script for EC2 instance initialization"
  type        = string
  default     = null
}

####################################
# Additional Tags
####################################

variable "tags" {
  description = "Additional custom tags"
  type        = map(string)
  default     = {}
}
