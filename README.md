# AWS Observability Stack (Terraform)

> End-to-end monitoring: a scheduled workload, CloudWatch alarms, a dashboard, and SNS alerting — provisioned with Terraform.
> **Author:** Muhammad Ahmad · **IaC:** Terraform · **Cloud:** AWS

![Terraform CI](https://github.com/AhmadMughal-DS/aws-observability-cloudwatch-terraform/actions/workflows/terraform.yml/badge.svg)
![Terraform](https://img.shields.io/badge/Terraform-1.6%2B-7B42BC?logo=terraform&logoColor=white)
![Security](https://img.shields.io/badge/scanned-tfsec%20%7C%20checkov-success)
![AWS](https://img.shields.io/badge/AWS-CloudWatch%20%7C%20Lambda%20%7C%20SNS-FF9900?logo=amazonaws&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green)

---

## 📌 Overview

- A **heartbeat Lambda** runs every 5 minutes (via **EventBridge**) as the monitored workload.
- **CloudWatch alarms** watch its **Errors** and **Duration** metrics.
- A **CloudWatch dashboard** visualizes invocations, errors, and duration.
- Alarms publish to an **SNS topic** (optionally emailed to you).

A compact, reusable monitoring pattern you can point at any workload.

## 🏗️ Architecture

> 🎨 **Interactive diagram (industry-standard icons):** [open in Lucid — page 10](https://lucid.app/lucidchart/3da75ce3-ea66-4296-81b3-00d20a60435b/edit)

```mermaid
flowchart LR
    EB[EventBridge Schedule]
    L[Heartbeat Lambda]
    CW[CloudWatch Metrics]
    AL[CloudWatch Alarms]
    DB[Dashboard]
    SNS[SNS Topic]
    Email([Email])

    EB -->|every 5 min| L
    L --> CW
    CW --> AL
    CW --> DB
    AL -->|breach| SNS
    SNS --> Email
```

## 🚀 Deploy

```bash
cd terraform
terraform init
terraform apply -var="alarm_email=you@example.com"
```

Confirm the SNS subscription email, then open the dashboard output in the CloudWatch console.

## 🧹 Clean up

```bash
terraform destroy
```

## 💰 Cost note

Lambda, EventBridge, and a handful of alarms/dashboards fall largely within the free tier — idle cost is minimal.

## 🔐 Production hardening (next steps)

- Add **composite alarms** and anomaly detection.
- Add **log metric filters** for error patterns.
- Point the alarms at your real services (ALB 5xx, RDS CPU, SQS age).

---

*Built and maintained by **Muhammad Ahmad**.*
