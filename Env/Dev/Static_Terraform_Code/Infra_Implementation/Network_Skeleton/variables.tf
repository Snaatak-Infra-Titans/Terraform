# --- GLOBAL VARIABLES ---
variable "aws_region"  { type = string }
variable "environment" { type = string }
variable "application" { type = string }
variable "cost_center" { type = string }
variable "owner"       { type = string }

# --- VPC VARIABLES ---
variable "vpc_cidr" { type = string }
variable "vpc_name" { type = string }

# --- SUBNET VARIABLES ---
variable "subnet_newbits" {
  description = "Number of bits to add for subnetting"
  type        = number
  default     = 3
}

variable "azs" {
  description = "Availability zones suffixes to use"
  type        = list(string)
  default     = ["a", "b"]
}

# --- IGW VARIABLES ---
variable "igw_name" {
  description = "Name of the Internet Gateway"
  type        = string
}
