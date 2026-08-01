variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
}

variable "subnet_name" {
  description = "Subnet Name Tag"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile"
  type        = string
}

variable "instance_name" {
  description = "EC2 Name Tag"
  type        = string
}

variable "tags" {
  description = "Common Tags"
  type        = map(string)
}
