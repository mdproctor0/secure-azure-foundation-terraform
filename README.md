<img width="1021" height="625" alt="Gemini_Generated_Image_xee4ihxee4ihxee4" src="https://github.com/user-attachments/assets/28120ec5-e8bb-4c07-a7da-f7ee43309166" />

# Secure Azure Foundation (Terraform)

## Overview
This repository provisions a repeatable, security-oriented baseline in Microsoft Azure using Terraform. The goal is to establish a hardened “starter platform” that reduces common cloud failure modes such as unintended internet exposure, overly permissive network rules, weak storage defaults, and insufficient logging.

This project was designed as a foundational security lab and portfolio artifact. It demonstrates infrastructure-as-code, secure-by-default design choices, and operational visibility through centralized logging and alerting.

## Architecture
Provisioned components include:

- Resource Group: lifecycle boundary for the environment
- Virtual Network (VNet): private network boundary
- Subnets: public and private segmentation
- Network Security Groups (NSGs): least-privilege traffic controls
- Linux VM: deployed without a public IP (private-by-default posture)
- Log Analytics Workspace: centralized telemetry sink
- Azure Monitor / Log Analytics queries: validation of log ingestion
- Alert rule: detection of `authpriv` Syslog events (lab signal)

## Security Design Decisions
### No public IP on the VM
The Linux VM is deployed without a public IP to reduce exposure to common opportunistic attacks (SSH brute force, password spraying, vulnerability scanning). Administrative access is intended to be handled through controlled mechanisms such as Bastion, jump hosts, or private connectivity (implementation depends on environment requirements).

### Network segmentation with NSGs
Subnets and NSGs are used to establish a controlled network boundary with a least-privilege mindset. Inbound access is restricted and defaults to deny unless explicitly required.

### Centralized logging
Log Analytics is used to centralize platform telemetry. This supports investigation workflows, basic detections, and auditability.

## Repository Layout
The Terraform configuration is located in the `terraform/` directory.

Common files:
- `main.tf`: foundational resources and orchestration
- `network.tf`: VNet, subnets, and network configuration
- `security.tf`: NSGs and security controls
- `compute.tf`: VM and compute resources
- `bastion.tf`: optional Bastion-related resources (if enabled)
- `providers.tf`: provider configuration
- `versions.tf`: required Terraform/provider versions
- `variables.tf`: input variables
- `outputs.tf`: key outputs for validation and integration
- `terraform.tfvars.example`: example variable values template (safe to commit)

## Prerequisites
- Azure subscription with permissions to create resources (Resource Group, Networking, Compute, Log Analytics)
- Terraform installed
- Azure CLI installed and authenticated:
  - `az login`
- An SSH keypair (public key path referenced by variables)

## Usage
From the repository root:

```bash
cd terraform
terraform init
terraform fmt -recursive
terraform validate
terraform plan -out tfplan
terraform apply tfplan
terraform destroy
