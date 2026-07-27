# SCRUM Ticket: Setup Attendance App Infra in Dev via Terraform Static Code

## Ticket

**Cloud Infra Implementation Dev via Static Terraform | Setup Attendance App infra in dev env via terraform static code | Terraform static code to configure Listener Rules of ALB**

**Ticket Link:**  
<JIRA_TICKET_LINK>

---

## Reference Implementation

The required ALB Listener Rules have already been implemented in the existing Terraform configuration.

**Reference Code:**  
https://github.com/Snaatak-Infra-Titans/Terraform/blob/SCRUM-393-versha/Env/Dev/Static_Terraform_Code/Infra_Implementation/Network_Skeleton/alb.tf

---

## Implementation Covered

The referenced `alb.tf` already includes:

- Application Load Balancer (ALB)
- HTTP Listener (Port 80) with redirect to HTTPS
- HTTPS Listener (Port 443)
- Path-based Listener Rules for:
  - Employee API
  - Attendance API
  - Salary API
  - Notification API
- Frontend configured as the default target group
- Target Group configuration
- Health Check configuration
- Security Group configuration
- Environment-based naming convention
- Terraform variables instead of hardcoded values
- Standard resource tags:
  - Application
  - Owner
  - Environment
  - CostCenter

---

## Ticket Requirement Mapping

| Requirement | Status |
|------------|--------|
| Configure Listener Rules of ALB | ✅ Already Implemented |
| Follow Dev Infra Diagram | ✅ Implemented |
| Proper Naming Convention | ✅ Implemented |
| Logical Terraform Directory Structure | ✅ Implemented |
| Use Variables Instead of Hardcoded Values | ✅ Implemented |
| Standard Tags (Application, Owner, Environment, CostCenter) | ✅ Implemented |
| Static Tag Blocks | ✅ Implemented |
| Validate Cost Allocation Tags in AWS Billing | ⚠️ Manual validation after deployment |

---

## Note

The required ALB listener configuration already exists in the Terraform implementation referenced above. Therefore, no additional Terraform code changes were required for this ticket.

The Terraform code satisfies the implementation requirements by using environment-based naming conventions, reusable variables, standard tagging, target groups, listeners, and path-based routing rules.

**Note:** Validation of **Cost Allocation Tags** in **AWS Console → Billing → Cost Allocation Tags** is a manual post-deployment verification step and is outside the scope of the Terraform static code.
