# Architecture Diagram — AWS Observability Stack

## Lucid diagram

- **View:** https://lucid.app/lucidchart/626a20bf-cc7e-4ec6-a764-6ef670c63823/view
- **Edit:** https://lucid.app/lucidchart/626a20bf-cc7e-4ec6-a764-6ef670c63823/edit

## Lucid prompt (reusable)

```
Create an AWS monitoring diagram titled "AWS Observability Stack".
An EventBridge Schedule triggers a Heartbeat Lambda every 5 minutes. The Lambda emits
metrics to CloudWatch. CloudWatch feeds a Dashboard and a set of Alarms; when an alarm
breaches it publishes to an SNS Topic which emails a recipient. Label the arrows.
Clean, professional AWS colors.
```

## Mermaid source

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
