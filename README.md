# Terraform Wrapper Code CI POC

| **Author**  | **Created on** | **Version** | **Last edited on** | **L0 Reviewer** | **L1 Reviewer** | **L2 Reviewer** |
| ----------- | -------------- | ----------- | ------------------ | --------------- | --------------- | --------------- |
| Saransh Rai | 19-08-2026     | v1.0        | 19-08-2026         | Aniruddh        |   Aayush        | Sandeep Rawat   |

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Purpose](#2-purpose)
3. [POC Architecture](#3-poc-architecture)
4. [Repository Structure](#4-repository-structure)
5. [CI Pipeline Stages](#5-ci-pipeline-stages)
6. [Dev and QA Validation](#6-dev-and-qa-validation)
7. [POC Validation](#7-poc-validation)
8. [Conclusion](#8-conclusion)
9. [References](#9-references)

---

# 1. Introduction

This POC demonstrates **Terraform Wrapper Code CI validation** for Dev and QA environments using reusable Terraform modules. The CI pipeline validates Terraform configuration through formatting, validation, linting, and planning stages without applying any infrastructure changes.

---

# 2. Purpose

The purpose of this POC is to verify that:

* Dev and QA wrapper code can consume the same reusable Terraform module.
* Terraform configuration follows standard formatting.
* Terraform configuration is valid.
* TFLint checks pass successfully.
* Terraform Plan completes successfully.
* No infrastructure changes are performed.

The CI flow is:

```text
Terraform Module
       |
       v
Dev / QA Wrapper
       |
       v
Jenkins CI
       |
       v
Fmt → Validate → TFLint → Plan
       |
       v
      STOP
```

---

# 3. POC Architecture

A common Terraform module is consumed by separate Dev and QA wrapper configurations.

```text
                Wrapper_POC Module
                       |
              +--------+--------+
              |                 |
              v                 v
         DEV Wrapper        QA Wrapper
              |                 |
              v                 v
        Dev Variables       QA Variables
              |                 |
              +--------+--------+
                       |
                       v
                   Jenkins CI
```

The POC uses `terraform_data` to validate the Terraform module and wrapper workflow without creating external AWS infrastructure.

---

# 4. Repository Structure

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
    │           └── versions.tf
    │
    └── QA/
        └── Wrapper/
            └── POC/
                ├── main.tf
                ├── variables.tf
                ├── terraform.tfvars
                └── versions.tf
```

Terraform branch:

```text
SCRUM-489-saransh
```

### Jenkins Repository

```text
Jenkins/
└── POC/
    └── Terraform_Wrapper_CI/
        └── Jenkinsfile
```

Jenkins branch:

```text
SCRUM-489-saransh
```

---

# 5. CI Pipeline Stages

The Jenkins pipeline performs the following stages:

| **Stage**          | **Purpose**                                 |
| ------------------ | ------------------------------------------- |
| Checkout           | Downloads the Terraform repository.         |
| Set Terraform Path | Selects Dev or QA wrapper directory.        |
| Tool Check         | Verifies Terraform and TFLint availability. |
| Terraform Init     | Initializes Terraform and modules.          |
| Format Check       | Checks Terraform formatting.                |
| Validate           | Validates Terraform configuration.          |
| TFLint             | Performs Terraform linting.                 |
| Plan               | Generates the Terraform execution plan.     |

Main validation commands:

```bash
terraform init -input=false

terraform fmt -check -recursive

terraform validate

tflint

terraform plan -input=false -no-color
```

There is no `terraform apply` or `terraform destroy` stage in the CI POC.

---

# 6. Dev and QA Validation

The environment is selected using the Jenkins parameter:

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

Both environments consume the same reusable module while providing different environment values.

```text
DEV
environment = "dev"

QA
environment = "qa"
```

---

# 7. POC Validation

The POC is considered successful when the following checks pass:

| **Validation**         | **Expected Result** |
| ---------------------- | ------------------- |
| Dev Format Check       | Pass                |
| Dev Validate           | Pass                |
| Dev TFLint             | Pass                |
| Dev Plan               | Pass                |
| QA Format Check        | Pass                |
| QA Validate            | Pass                |
| QA TFLint              | Pass                |
| QA Plan                | Pass                |
| Terraform Apply        | Not Executed        |
| Infrastructure Changes | None                |

---

# 8. Conclusion

The Terraform Wrapper Code CI POC validates that the same reusable module can be consumed by Dev and QA wrapper configurations. The Jenkins pipeline performs formatting, validation, linting, and planning checks while ensuring that no infrastructure changes are applied.

---

# 9. References

| **Reference**                  | **Description**                            |
| ------------------------------ | ------------------------------------------ |
| Terraform Documentation        | Terraform configuration and CLI reference. |
| Terraform Modules              | Reusable Terraform module concepts.        |
| Terraform Validate             | Terraform configuration validation.        |
| Terraform Plan                 | Terraform execution planning.              |
| TFLint Documentation           | Terraform linting and static analysis.     |
| Jenkins Pipeline Documentation | Jenkins CI pipeline implementation.        |

