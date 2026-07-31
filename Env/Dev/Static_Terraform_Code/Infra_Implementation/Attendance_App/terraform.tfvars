aws_region    = "us-east-1"
environment   = "dev"
application   = "otms"
cost_center = "Snaatak"
owner   = "Infra-Titans"

ingress_rules = [
  { port = 8080, cidr = ["vpc"] },
  { port = 22, cidr = ["0.0.0.0/0"] }
]
