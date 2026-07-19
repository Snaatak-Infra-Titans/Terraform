# AWS Network Skeleton Infrastructure - Terraform Module

<p align="center">
  <img width="300" height="200" alt="image" src="https://github.com/user-attachments/assets/658c74ce-55cd-4b71-80c9-a1ba08579609" alt="AWS Network" width="500"/>
</p>

---

# Document Details

| **Author** | **Created on** | **Version** | **Last Updated By** | **Last Edited On** | **Pre Reviewer** | **L0 Reviewer** | **L1 Reviewer** | **L2 Reviewer** |
| ---------- | -------------- | ----------- | ------------------- | ------------------ | ---------------- | --------------- | --------------- | --------------- |
| Ankita     | 20-07-2026     | v1.0        | Ankita              | 20-07-2026         | Team             | Komal Jaiswal   | Akshit Kapil    | Mahesh Kumar    |

---

# Table of Contents

1. [Description](#1-description)
2. [Prerequisites](#2-prerequisites)
3. [Terraform Resources Used](#3-terraform-resources-used)
4. [Terraform Data Sources Used](#4-terraform-data-sources-used)
5. [Module Structure](#5-module-structure)
6. [Infrastructure Design](#6-infrastructure-design)
7. [File Description](#7-file-description)
8. [Input Variables](#8-input-variables)
9. [Network Design](#9-network-design)
10. [Subnet Design](#10-subnet-design)
11. [Routing Design](#11-routing-design)
12. [Best Practices Followed](#12-best-practices-followed)
13. [Result](#13-result)
14. [Conclusion](#14-conclusion)
15. [Contact Information](#15-contact-information)
16. [References](#16-references)

---

# 1. Description

This document explains the design of the **AWS Network Skeleton Terraform Module**.

The Network Skeleton module creates the foundational networking infrastructure required before deploying compute, load balancers, databases, and application services.

The module is reusable and can be deployed across multiple environments such as Development, QA, UAT, and Production.

## The module provisions

* Amazon VPC
* Public Subnets
* Private Application Subnets
* Private Database Subnets
* Internet Gateway
* NAT Gateway
* Elastic IP
* Public Route Table
* Private Route Tables
* Route Table Associations

This module serves as the base infrastructure upon which other Terraform modules are deployed.

---

# 2. Prerequisites

Before deploying this module, ensure the following requirements are met.

| Tool                      | Purpose                    |
| ------------------------- | -------------------------- |
| Terraform                 | Infrastructure as Code     |
| AWS CLI                   | AWS Authentication         |
| AWS Account               | Cloud Infrastructure       |
| IAM User/Role             | Required permissions       |
| Remote Backend (Optional) | Terraform State Management |

---

# 3. Terraform Resources Used

The Network Skeleton module provisions the following AWS resources.

| Resource                    | Purpose                                              |
| --------------------------- | ---------------------------------------------------- |
| aws_vpc                     | Creates the Virtual Private Cloud                    |
| aws_subnet                  | Creates Public, Private App and Private DB Subnets   |
| aws_internet_gateway        | Provides Internet connectivity                       |
| aws_eip                     | Creates Elastic IP for NAT Gateway                   |
| aws_nat_gateway             | Enables outbound Internet access for private subnets |
| aws_route_table             | Creates Public and Private Route Tables              |
| aws_route                   | Configures routing rules                             |
| aws_route_table_association | Associates Route Tables with Subnets                 |

---

# 4. Terraform Data Sources Used

This module primarily creates networking resources. It may also retrieve AWS information using Terraform data sources.

| Data Source                 | Purpose                                |
| --------------------------- | -------------------------------------- |
| data.aws_availability_zones | Retrieves available Availability Zones |
| data.aws_region             | Retrieves current AWS Region           |
| data.aws_caller_identity    | Retrieves AWS Account information      |

---

# 5. Module Structure

```text
network-skeleton-module/

├── provider.tf
├── versions.tf
├── variables.tf
├── main.tf
├── outputs.tf
├── terraform.tfvars
├── README.md
└── examples/
    └── basic/
```

---

# 6. Infrastructure Design

The Network Skeleton module creates the base AWS networking architecture.

```text
                        AWS VPC
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
 Public Subnet 1    Public Subnet 2      Internet Gateway
        │                  │
        └──────────┬───────┘
                   │
              NAT Gateway
                   │
      ┌────────────┴────────────┐
      │                         │
Private App Subnet 1     Private App Subnet 2
      │                         │
      └────────────┬────────────┘
                   │
        Private Database Subnets
```

---

# 7. File Description

| File             | Purpose                         |
| ---------------- | ------------------------------- |
| provider.tf      | Configures AWS Provider         |
| versions.tf      | Terraform and Provider versions |
| variables.tf     | Defines input variables         |
| main.tf          | Creates networking resources    |
| outputs.tf       | Exposes module outputs          |
| terraform.tfvars | Environment-specific values     |
| README.md        | Module documentation            |
| examples/basic   | Example module usage            |

---

# 8. Input Variables

The following input variables configure the Network Skeleton module.

| Variable                   | Type         | Description                      |
| -------------------------- | ------------ | -------------------------------- |
| `name`                     | string       | Resource name prefix             |
| `environment`              | string       | Deployment environment           |
| `vpc_cidr`                 | string       | VPC CIDR block                   |
| `public_subnet_cidrs`      | list(string) | Public subnet CIDRs              |
| `private_app_subnet_cidrs` | list(string) | Private Application subnet CIDRs |
| `private_db_subnet_cidrs`  | list(string) | Private Database subnet CIDRs    |
| `availability_zones`       | list(string) | AWS Availability Zones           |
| `enable_nat_gateway`       | bool         | Enable or disable NAT Gateway    |
| `tags`                     | map(string)  | Resource tags                    |

---

# 9. Network Design

The module provisions an Amazon VPC that acts as the foundation for all AWS resources.

### Purpose

* Provides network isolation.
* Supports multiple Availability Zones.
* Enables secure communication.
* Serves as the base for all infrastructure modules.

---

# 10. Subnet Design

The module provisions three subnet types.

## Public Subnets

### Purpose

* Host Internet-facing resources.
* Connect through the Internet Gateway.
* Suitable for Load Balancers and NAT Gateway.

## Private Application Subnets

### Purpose

* Host application servers.
* No direct Internet access.
* Outbound access through NAT Gateway.

## Private Database Subnets

### Purpose

* Host database resources.
* Isolated from public Internet.
* Accessible only from application layer.

---

# 11. Routing Design

The module creates separate route tables for secure traffic management.

## Public Route Table

### Purpose

* Routes Internet traffic through the Internet Gateway.
* Used by Public Subnets.

## Private Route Table

### Purpose

* Routes outbound Internet traffic through the NAT Gateway.
* Used by Private Application and Database Subnets.

---

# 12. Best Practices Followed

| Best Practice                 | Description                                                                       |
| ----------------------------- | --------------------------------------------------------------------------------- |
| Reusable Module Design        | Module can be reused across multiple environments                                 |
| Variable-Driven Configuration | Uses variables instead of hardcoded values                                        |
| High Availability             | Supports deployment across multiple Availability Zones                            |
| Network Isolation             | Separates Public, Application, and Database layers                                |
| Secure Routing                | Private resources access the Internet through NAT Gateway only                    |
| Standard Resource Tagging     | Consistent tagging across all AWS resources                                       |
| Modular Infrastructure        | Designed for integration with Compute, ALB, Database, and other Terraform modules |

---

# 13. Result

After successful deployment, the module provisions:

* Amazon VPC
* Public Subnets
* Private Application Subnets
* Private Database Subnets
* Internet Gateway
* NAT Gateway
* Route Tables
* Route Table Associations

The outputs generated by this module can be consumed by downstream Terraform modules such as Compute, Load Balancer, Security Groups, and Database.

---

# 14. Conclusion

The AWS Network Skeleton Terraform Module provides a reusable and scalable networking foundation for cloud infrastructure. By automating the creation of core networking components, the module simplifies infrastructure deployment while promoting consistency, security, and maintainability across multiple environments.

---

# 15. Contact Information

| Contact Type | Details                                               |
| ------------ | ----------------------------------------------------- |
| Name         | Ankita                                                |
| Role         | DevOps Trainee                                        |
| Email        | [askankita19@gmail.com](mailto:askankita19@gmail.com) |

---

# 16. References

| Link                                                                       | Description                    |
| -------------------------------------------------------------------------- | ------------------------------ |
| https://developer.hashicorp.com/terraform/docs                             | Terraform Documentation        |
| https://registry.terraform.io/providers/hashicorp/aws/latest/docs          | Terraform AWS Provider         |
| https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html   | Amazon VPC Documentation       |
| https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html | Internet Gateway Documentation |
| https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html      | NAT Gateway Documentation      |
| https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html     | Route Tables Documentation     |
