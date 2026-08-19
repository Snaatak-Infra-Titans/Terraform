# Terraform Wrapper Code CD POC

| **Author**  | **Created on** | **Version** | **Last edited on** | **L0 Reviewer** | **L1 Reviewer** | **L2 Reviewer** |
| ----------- | -------------- | ----------- | ------------------ | --------------- | --------------- | --------------- |
| Saransh Rai | 19-08-2026     | v1.0        | 19-08-2026         | Aniruddh        |   Aayush        | Sandeep Rawat   |

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Purpose](#2-purpose)
3. [POC Architecture](#3-poc-architecture)
4. [Backend and State Management](#4-backend-and-state-management)
5. [Repository Structure](#5-repository-structure)
6. [CD Pipeline Stages](#6-cd-pipeline-stages)
7. [Dev and QA Deployment](#7-dev-and-qa-deployment)
8. [POC Validation](#8-poc-validation)
9. [Conclusion](#9-conclusion)
10. [References](#10-references)

---

# 1. Introduction

This POC demonstrates **Terraform Wrapper Code CD deployment** for Dev and QA environments using reusable Terraform modules. It extends the CI workflow by adding remote state management, a controlled approval stage, and `terraform apply`.

---

# 2. Purpose

The purpose of this POC is to demonstrate that:

* Dev and QA can use the same reusable Terraform module.
* Terraform state is stored remotely.
* Dev and QA maintain separate state files.
* Terraform Plan is generated and saved.
* Infrastructure changes require manual approval.
* The reviewed Terraform Plan is applied through Jenkins.
* Terraform state can be validated after deployment.

The CD flow is:

```text
Terraform Module
       |
       v
Dev / QA Wrapper
       |
       v
Jenkins CD
       |
       v
Plan
       |
       v
Approval
       |
       v
Apply
       |
       v
Remote State
```

---

# 3. POC Architecture

A common `Wrapper_POC` module is consumed by both Dev and QA.

```text
                 Wrapper_POC Module
                        |
               +--------+--------+
               |                 |
               v                 v
          DEV Wrapper        QA Wrapper
               |                 |
               v                 v
          DEV Backend        QA Backend
               |                 |
               +--------+--------+
                        |
                        v
                     Jenkins
                        |
               Plan → Approval
                        |
                        v
                      Apply
```

The POC uses `terraform_data` as the managed Terraform resource so that the CD workflow can be tested without provisioning application infrastructure.

---

# 4. Backend and State Management

The CD POC uses an **S3 backend** for Terraform state.

Both Dev and QA contain:

```text
backend.tf
backend.hcl
```

`backend.tf`:

```hcl
terraform {
  backend "s3" {}
}
```

The environment-specific backend configuration is supplied through `backend.hcl`.

### Dev State

```text
wrapper-poc/dev/terraform.tfstate
```

### QA State

```text
wrapper-poc/qa/terraform.tfstate
```

This maintains state isolation:

```text
S3 Backend
│
└── wrapper-poc/
    │
    ├── dev/
    │   └── terraform.tfstate
    │
    └── qa/
        └── terraform.tfstate
```

Terraform Init loads the backend using:

```bash
terraform init \
  -input=false \
  -reconfigure \
  -backend-config=backend.hcl
```

---

# 5. Repository Structure

### Terraform Repository

```text
Terraform/
│
├── Modules/
│   └── Wrapper_POC/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
└── Env/
    ├── Dev/
    │   └── Wrapper/
    │       └── POC/
    │           ├── main.tf
    │           ├── variables.tf
    │           ├── terraform.tfvars
    │           ├── versions.tf
    │           ├── backend.tf
    │           └── backend.hcl
    │
    └── QA/
        └── Wrapper/
            └── POC/
                ├── main.tf
                ├── variables.tf
                ├── terraform.tfvars
                ├── versions.tf
                ├── backend.tf
                └── backend.hcl
```

Terraform branch:

```text
SCRUM-490-saransh
```

### Jenkins Repository

```text
Jenkins/
└── POC/
    └── Terraform_Wrapper_CD/
        └── Jenkinsfile
```

Jenkins branch:

```text
SCRUM-490-saransh
```

---

# 6. CD Pipeline Stages

| **Stage**          | **Purpose**                            |
| ------------------ | -------------------------------------- |
| Checkout           | Downloads Terraform code.              |
| Set Terraform Path | Selects Dev or QA wrapper.             |
| Tool Check         | Verifies Terraform and TFLint.         |
| Terraform Init     | Initializes S3 backend and modules.    |
| Format Check       | Checks Terraform formatting.           |
| Validate           | Validates Terraform configuration.     |
| TFLint             | Performs linting checks.               |
| Terraform Plan     | Generates and saves `tfplan`.          |
| Show Plan          | Displays the plan before approval.     |
| Manual Approval    | Requires approval before deployment.   |
| Terraform Apply    | Applies the saved Terraform plan.      |
| State Validation   | Validates Terraform state and outputs. |

The plan is saved using:

```bash
terraform plan \
  -input=false \
  -no-color \
  -out=tfplan
```

The same reviewed plan is applied using:

```bash
terraform apply \
  -input=false \
  tfplan
```

---

# 7. Dev and QA Deployment

The deployment environment is selected using:

```text
ENVIRONMENT = Dev / QA
```

For Dev:

```text
terraform/Env/Dev/Wrapper/POC
```

For QA:

```text
terraform/Env/QA/Wrapper/POC
```

The pipeline pauses after Terraform Plan:

```text
Terraform Plan
      |
      v
Manual Approval
      |
  +---+---+
  |       |
Apply   Abort
  |
  v
Terraform Apply
```

This ensures that deployment occurs only after the Terraform Plan has been reviewed.

---

# 8. POC Validation

The POC is successful when the following requirements are demonstrated:

| **Requirement**           | **Validation**                    |
| ------------------------- | --------------------------------- |
| Reusable Terraform Module | Same module used by Dev and QA    |
| Dev Wrapper               | Successfully deployed             |
| QA Wrapper                | Successfully deployed             |
| Backend Configuration     | S3 backend initialized            |
| Dev State                 | Separate Dev state file           |
| QA State                  | Separate QA state file            |
| Terraform Plan            | Generated successfully            |
| Manual Approval           | Required before Apply             |
| Terraform Apply           | Saved plan applied successfully   |
| State Validation          | `terraform state list` successful |
| Terraform Output          | Output available after Apply      |

State validation is performed using:

```bash
terraform state list
```

and:

```bash
terraform output
```

Expected high-level flow:

```text
Checkout
   |
   v
Init with S3 Backend
   |
   v
Format
   |
   v
Validate
   |
   v
TFLint
   |
   v
Plan
   |
   v
Manual Approval
   |
   v
Apply
   |
   v
State Validation
   |
   v
SUCCESS
```

---

# 9. Conclusion

The Terraform Wrapper Code CD POC demonstrates controlled Dev and QA deployment using reusable Terraform modules. The implementation includes S3 backend configuration, separate environment state, Terraform Plan, manual approval, Terraform Apply, and post-deployment state validation.

---

# 10. References

| **Reference** | **Description** |
|---|---|
| [Terraform Documentation](https://developer.hashicorp.com/terraform) | Terraform configuration and CLI reference. |
| [Terraform Modules](https://developer.hashicorp.com/terraform/language/modules) | Reusable Terraform module concepts. |
| [Terraform S3 Backend](https://developer.hashicorp.com/terraform/language/backend/s3) | Remote Terraform state management. |
| [Terraform Plan](https://developer.hashicorp.com/terraform/cli/commands/plan) | Terraform execution plan generation. |
| [Terraform Apply](https://developer.hashicorp.com/terraform/cli/commands/apply) | Terraform deployment execution. |
| [Terraform State](https://developer.hashicorp.com/terraform/cli/commands/state) | Terraform state inspection and management. |
| [Jenkins Pipeline Documentation](https://www.jenkins.io/doc/book/pipeline/) | Jenkins CD pipeline implementation. |
