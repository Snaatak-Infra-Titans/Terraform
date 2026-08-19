module "wrapper_poc" {
  source = "../../../../Modules/Wrapper_POC"

  environment = var.environment
  application = var.application
}

output "poc_details" {
  value = module.wrapper_poc.poc_details
}
