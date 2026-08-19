resource "terraform_data" "wrapper_poc" {

  input = {
    environment = var.environment
    application = var.application
    name        = "${var.environment}-${var.application}-wrapper-poc"
  }
}
