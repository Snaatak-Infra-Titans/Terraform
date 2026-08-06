############################################
# Existing VPC
############################################

data "aws_vpc" "main" {
  id = var.vpc_id
}

############################################
# Existing Public Subnet A
############################################

data "aws_subnet" "public_a" {
  id = var.public_subnet_a_id
}

############################################
# Existing Public Subnet B
############################################

data "aws_subnet" "public_b" {
  id = var.public_subnet_b_id
}
