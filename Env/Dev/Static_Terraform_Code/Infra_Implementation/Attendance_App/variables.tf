variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "application" {
  type    = string
  default = "otms"
}

variable "owner" {
  type    = string
  default = "Infra-Titans"
}

variable "cost_center" {
  type    = string
  default = "Snaatak"
}

variable "ingress_rules" {
  type = list(object({
    port = number
    cidr = list(string)
  }))
  default = [
    { port = 8080, cidr = ["vpc"] },
    { port = 22, cidr = ["0.0.0.0/0"] }
  ]
  description = "List of ingress rules with port and cidr blocks. Use 'vpc' as a placeholder for the VPC CIDR block."
}
