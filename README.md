# Azure Bicep CI Infrastructure – Foundation & Workload
## Overview

This repository implements a real-world Azure Infrastructure as Code (IaC) CI pipeline using Bicep + GitHub Actions + OIDC, following enterprise-grade practices:

Secure authentication with OIDC (no secrets)

Clear separation between foundation and workload

What-If validation before deployment

Modular, reusable Bicep architecture

Cross-deployment output consumption

Designed to mirror production DevOps workflows, not tutorials

The goal of this project is to simulate how infrastructure is validated and deployed in a real DevOps / Platform Engineering environment.

## Architecture
Foundation Layer

Responsible for shared, long-lived infrastructure:

Virtual Network + Subnet

Network Security Group (baseline)

Azure Key Vault (RBAC-enabled)

Outputs exposed for downstream consumption

Workload Layer

Consumes foundation outputs and deploys application-specific resources:

Application NSG

Network Interface

Public IP (optional)

Virtual Machine (Windows/Linux ready pattern)

Parameterized and environment-aware

## Repository Structure
```text
.
├── bicep
│   ├── foundation
│   │   ├── main.bicep
│   │   └── modules
│   │       ├── vnet.bicep
│   │       ├── subnet.bicep
│   │       ├── nsg-baseline.bicep
│   │       └── keyvault.bicep
│   └── workload
│       ├── main.bicep
│       ├── parameters.dev.json
│       └── modules
│           ├── nic.bicep
│           ├── nsg-app.bicep
│           ├── publicIP.bicep
│           └── vm.bicep
├── .github
│   └── workflows
│       └── ci-bicep.yml
└── README.md
```
## Authentication Model

This project uses GitHub Actions OIDC to authenticate to Azure.

No client secrets

No stored credentials

Federated Identity Credential configured on Azure AD App Registration

Case-sensitive subject matching (post-2024 Azure AD behavior)

This mirrors modern enterprise security standards.

## CI Pipeline Flow
1. Validation

Bicep build for foundation and workload

Syntax and structural validation

2. What-If – Foundation

Resource Group–scoped what-if

Ensures no unintended changes

3. Deploy Foundation

Executes deployment only after validation

Outputs are captured (e.g. subnetId)

4. What-If – Workload

Consumes foundation outputs

Validates workload changes safely

No secrets exposed in logs

## Key DevOps Concepts Demonstrated

Infrastructure modularization with Bicep

Separation of concerns (foundation vs workload)

GitHub Actions job dependencies

Cross-job output sharing

Azure ARM what-if usage

Handling real Azure constraints:

Global resource naming (Key Vault)

Soft delete & purge behavior

SKU availability per region

NIC and IP configuration rules

Parameter file versioning pitfalls

Debugging deployments using:
``` bash
az deployment operation group list
```
## How to Run (CI-driven)

All deployments are intended to be executed via GitHub Actions CI.

Trigger:

Push to main

Local execution is possible for debugging, but CI is the source of truth, mirroring real enterprise workflows.


## Status

✅ CI pipeline stable

✅ OIDC authentication working

✅ Foundation and workload what-if passing

✅ Enterprise-grade structure in place

Next Possible Enhancements

Environment approvals (GitHub Environments)

Azure resource locks

Key Vault secret injection

RBAC assignments via Bicep

Multi-environment promotion (dev → prod)

## Author
Bruno Mijail Diaz Barba
DevOps/Platform Engineer 
