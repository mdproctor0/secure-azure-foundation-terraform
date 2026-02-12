# Secure Azure Foundation with Terraform and Detection Validation

## Project Overview

This project implements a secure, repeatable Azure infrastructure baseline using Terraform and validates security monitoring through simulated privileged access activity.

The objective was to design and deploy a hardened cloud environment that eliminates common failure modes commonly seen in cloud security incidents:

- Unintended internet exposure  
- Overly permissive network rules  
- Weak service defaults  
- Lack of centralized logging and visibility  

After deploying the secure baseline, detection engineering was layered on top to validate monitoring capability.

---

## Phase 1 — Secure Azure Foundation (Infrastructure as Code)

### Architecture Components

- Resource Group — Lifecycle boundary for all resources  
- Virtual Network (VNet) — Private network boundary  
- Public Subnet — Controlled ingress segment  
- Private Subnet — Non-internet-facing segment  
- Network Security Groups (NSGs) — Least privilege traffic enforcement  
- Linux Virtual Machine (No Public IP) — Default secure posture  
- Secure Storage Account — Hardened configuration  
- Log Analytics Workspace — Centralized telemetry and monitoring  

---

## Security Controls Implemented

| Control | Purpose | Risk Mitigated |
|----------|----------|----------------|
| No Public IP on VM | Default secure stance | Prevents brute-force and direct internet exposure |
| Least Privilege NSGs | Restricts inbound and outbound traffic | Reduces attack surface |
| Centralized Logging | Enables visibility and investigations | Eliminates monitoring blind spots |
| Secure Storage Defaults | Protects data services | Prevents data exfiltration |
| Infrastructure as Code | Controlled, reviewable changes | Prevents configuration drift |

---

## Terraform Design Model

Infrastructure was defined declaratively using Terraform:

```
Desired State → Plan → Apply → State Tracking
```

Terraform builds infrastructure as a dependency graph in the following order:

1. Resource Group  
2. Virtual Network  
3. Subnets  
4. Network Security Groups  
5. NSG Associations  
6. Network Interface (Private Subnet)  
7. Linux Virtual Machine  
8. Storage Account  
9. Log Analytics Workspace  

All changes were validated using `terraform plan` prior to deployment.

---

## Phase 2 — Detection Engineering Validation

After the secure foundation was deployed, logging and detection capabilities were validated.

### Threat Scenario

Simulated unauthorized privileged access attempt:

```bash
logger -p authpriv.err "Security Test: Unauthorized Access Attempt"
```

Logs were ingested via Azure Monitor Agent into Log Analytics.

---

## Detection Query (KQL)

```kql
Syslog
| where Facility == "authpriv"
| where SyslogMessage contains "Unauthorized"
| summarize AttemptCount = count() by Computer, bin(TimeGenerated, 5m)
| where AttemptCount >= 1
| sort by TimeGenerated desc
```

---

## Alert Rule Configuration

- Scheduled query alert  
- Evaluation frequency: 5 minutes  
- Trigger condition: Results greater than 0  
- Alert successfully fired during validation testing  

---

## MITRE ATT&CK Mapping

- T1078 — Valid Accounts  
- TA0006 — Credential Access  
- TA0004 — Privilege Escalation  

---

## Architecture Principles Applied

- Zero direct internet exposure  
- Least privilege networking  
- Defense in depth  
- Infrastructure as Code  
- Threat-informed detection  
- Observability-first design  

---

## Future Improvements

- Remote Terraform state backend  
- Terraform module refactoring  
- Automated incident response integration  
- Flow logs and network analytics  
- Baseline anomaly detection  

---

## Skills Demonstrated

- Azure Networking Architecture  
- Infrastructure as Code (Terraform)  
- Secure Cloud Design  
- Azure Monitor and Log Analytics  
- KQL Detection Engineering  
- Alert Engineering  
- Threat Modeling  
- MITRE ATT&CK Mapping  
