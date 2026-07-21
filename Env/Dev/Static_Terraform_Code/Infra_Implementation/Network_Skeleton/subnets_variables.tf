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
