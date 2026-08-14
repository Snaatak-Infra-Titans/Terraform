variable "application" {
  description = "Application name"
  type        = string
  default     = "scylladb"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Resource owner"
  type        = string
  default     = "Infra-Titans"
}

variable "instance_name" {
  description = "Name of the ScyllaDB EC2 instance"
  type        = string
  default     = "dev-otms-scylladb"
}

variable "ami_id" {
  description = "AMI ID used to launch the ScyllaDB EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "subnet_id" {
  description = "Backend subnet ID where the ScyllaDB instance will be launched"
  type        = string
}

variable "security_group_ids" {
  description = "Security group IDs attached to the ScyllaDB instance"
  type        = list(string)
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP address"
  type        = bool
  default     = false
}

variable "iam_instance_profile" {
  description = "IAM instance profile attached to the ScyllaDB instance"
  type        = string
  default     = "dev-otms-ssm-role"
}

variable "root_volume_size" {
  description = "Size of the root EBS volume in GB"
  type        = number
  default     = 15
}

variable "root_volume_type" {
  description = "Type of the root EBS volume"
  type        = string
  default     = "gp3"
}

variable "delete_on_termination" {
  description = "Whether the root EBS volume is deleted when the instance is terminated"
  type        = bool
  default     = true
}

variable "user_data" {
  description = "Optional user data script"
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional custom tags"
  type        = map(string)
  default     = {}
}
