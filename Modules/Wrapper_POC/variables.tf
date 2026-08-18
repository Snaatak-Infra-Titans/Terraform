variable "environment" {
  description = "Environment for the POC"
  type        = string

  validation {
    condition     = contains(["dev", "qa"], lower(var.environment))
    error_message = "Environment must be dev or qa."
  }
}

variable "application" {
  description = "Application name"
  type        = string
}
