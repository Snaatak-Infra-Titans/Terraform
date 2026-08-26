# OTMS Dev integrated environment

This wrapper produces one plan and one state for the complete Dev environment:

- two public subnets for the internet-facing ALB;
- one private frontend subnet;
- one private backend subnet;
- one private database subnet;
- application ASGs using the previously tested application AMIs;
- Ubuntu 24.04 standalone database VMs with fixed private IPs;
- public `otms.online` aliases and association of the existing `internal` private zone;
- SSM-only instance access through `dev-otms-ssm-instance-profile`.

The frontend target group uses port `3000`, matching the AMI systemd service:
`npx serve -s build -l 3000`.

## State and safety

The S3 backend is `otms-terraform-state-036253061030-us-east-1` with key
`dev/terraform.tfstate`. Native S3 state locking is enabled. A blocking account
guardrail requires AWS account `036253061030`.

Terraform CI creates and archives an exact binary plan. This wrapper must not be
applied from a developer laptop. Terraform CD will be added separately and will
apply the archived plan only after manual approval.

## Existing private DNS records

The PostgreSQL, Redis, and ScyllaDB records are imported into this state on the
first approved apply and updated to `10.0.0.110`, `10.0.0.111`, and
`10.0.0.112`. Existing application and monitoring A records are intentionally
not changed by this CI work; their service-discovery design will be handled
before Terraform CD is enabled.
