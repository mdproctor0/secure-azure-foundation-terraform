<img width="1021" height="625" alt="Gemini_Generated_Image_xee4ihxee4ihxee4" src="https://github.com/user-attachments/assets/28120ec5-e8bb-4c07-a7da-f7ee43309166" />

# Secure Azure Foundation (Terraform)

## Summary
This repository provisions a secure, repeatable baseline in Microsoft Azure using Terraform. The intent is to establish a hardened “starter platform” that prevents common cloud failure modes early, including unintended internet exposure, overly permissive network rules, and missing visibility.

This project is designed as a foundational security lab and portfolio artifact. It demonstrates infrastructure-as-code discipline, secure-by-default design, and basic operational telemetry via centralized logging and alerting.

## Project Status

Status: Fully deployed and validated in Azure

Validated Controls:
- Private VM with no public IP
- Subnet-level NSG enforcement
- Explicit inbound deny from Internet
- Controlled outbound via NAT Gateway
- Log ingestion verified in Log Analytics
- Syslog events observable for detection testing
-
- ## What This Deploys
- Resource Group (environment lifecycle and cost boundary)
- Virtual Network (private address space boundary)
- Public and private subnets (network segmentation)
- Network Security Groups (least-privilege inbound posture)
- NAT Gateway for private subnet egress (outbound-only internet access)
- Azure Bastion (controlled administrative access path)
- Linux VM deployed without a public IP (private-by-default)
- Log Analytics Workspace (centralized log sink)
- Azure Monitor agent on the VM (telemetry collection)

## Architecture
High-level flow:
- The VNet provides a private network boundary.
- Subnets separate potential ingress exposure (public) from protected workloads (private).
- The Linux VM is deployed into the private subnet with no public IP.
- Outbound access for the private subnet is provided through a NAT Gateway.
- Administrative access is intended through Azure Bastion (no direct inbound SSH from the internet).
- Logs are sent to Log Analytics for visibility and detection.

### Architecture Diagram

The following diagram represents the deployed secure baseline architecture:

<img width="1536" height="1024" alt="ChatGPT Image Feb 13, 2026 at 01_01_39 PM" src="https://github.com/user-attachments/assets/9aac08f3-f292-4e59-9b6e-93259ae0dc89" />

### High-Level Flow

Internet → NAT Gateway (Outbound Only) → Private Subnet (snet-private) → Linux VM (No Public IP)

Administrative Access Model:
- No direct internet exposure
- Controlled access patterns (Bastion / Private Connectivity)
- Subnet-level NSG enforcement

## Security Controls and Rationale

### No public IP on the VM
The Linux VM is deployed without a public IP to reduce exposure to opportunistic attacks (SSH brute force, password spraying, vulnerability scanning). This enforces a default posture where workloads are not directly reachable from the internet.

Operational implication:
- Access must occur through controlled paths (Azure Bastion or private connectivity).

### Least-privilege network controls (NSGs)
Network Security Groups enforce a restrictive inbound posture and prevent accidental exposure. This reduces the attack surface and limits unintended access paths that can enable lateral movement.

### Private subnet egress via NAT Gateway
Private workloads often require outbound internet access (updates, package repos) without becoming publicly reachable. NAT enables outbound connectivity while preserving inbound isolation.

### Centralized logging (Log Analytics)
A baseline without telemetry is not defensible. Log Analytics provides centralized visibility for investigation, auditing, and future detections.

## Security Validation Results

The following validations confirm the secure-by-default posture:

### Network Isolation
- VM deployed in private subnet
- No public IP attached
- Inbound internet traffic explicitly denied via NSG

### Controlled Egress
- Private subnet uses NAT Gateway
- Outbound internet allowed without inbound exposure

### Centralized Logging
- Azure Monitor Agent installed
- Syslog ingestion validated via Log Analytics query

### Detection Capability
-Authpriv Syslog events successfully ingested and queryable
-Security-relevant log activity observable in centralized workspace
-Alert rule configured to trigger on monitored security events

## Repository Layout
Terraform configuration lives in the `terraform/` directory.

- `main.tf` – resource group (deployment boundary)
- `network.tf` – VNet, subnets, NAT, and network plumbing
- `security.tf` – NSGs and security controls
- `compute.tf` – VM and NIC configuration (private-by-default)
- `bastion.tf` – Bastion host and public IP (controlled admin access)
- `providers.tf` – AzureRM provider configuration
- `versions.tf` – Terraform/provider version constraints
- `variables.tf` – input variables (portable configuration)
- `outputs.tf` – key outputs for validation and integration
- `terraform.tfvars.example` – example variable overrides (safe to commit)

## Why This Matters

Cloud environments frequently fail due to:

- Accidental public IP exposure
- Overly permissive network rules
- Lack of centralized logging
- Weak outbound control

This project demonstrates how to reduce those risks using infrastructure-as-code and secure-by-default design principles.

## Future Enhancements

Planned improvements:

- Enforce diagnostic settings on all resources
- Add Azure Policy for baseline enforcement
- Implement Defender for Cloud recommendations
- Convert to reusable Terraform modules
- Introduce CI/CD pipeline validation

- ## Engineering Considerations

Key design tradeoffs and observations:

- NAT Gateway provides outbound-only internet access while preserving inbound isolation.
- Subnet-level NSG enforcement reduces blast radius compared to NIC-level rules.
- Log Analytics provides rapid validation of telemetry ingestion during testing.
- Azure Monitor Agent (AMA) is required for modern log collection pipelines.
- Explicit deny rules improve security clarity despite Azure default deny behavior.

This baseline can be expanded into a production-ready landing zone using modular Terraform architecture.
  
## Prerequisites
- Azure subscription with permissions to create:
  - Resource Group, VNet/Subnets/NSGs, NAT, Bastion, VM, Log Analytics
- Terraform installed
- Azure CLI installed and authenticated:
  - `az login`
- SSH key pair available locally (public key path referenced in variables)

## How To Deploy
From the repository root:

```bash
cd terraform
terraform init
terraform fmt -recursive
terraform validate
terraform plan -out tfplan
terraform apply tfplan

