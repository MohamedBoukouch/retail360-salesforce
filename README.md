# Retail360

**Salesforce Retail Operations Platform** — a portfolio project demonstrating Salesforce development combined with good software engineering practices.

## Overview

Retail360 is a Salesforce-based retail management platform designed to centralize customer, store, and sales workflows for a business operating multiple stores.

The project applies a structured process from requirements to development:

- Business analysis and user stories
- Data modeling
- Layered Apex architecture
- Lightning Web Components
- Declarative automation with Flow
- Role-based security
- Git-based workflow with Pull Requests

## Business context

A fictional multi-store retail company needs to centralize:
- Customer information, currently dispersed
- Store performance visibility
- Sales rep activity tracking
- Customer visit follow-up

Retail360 addresses this across three domains: **Customer Management**, **Store Management**, and **Sales Management**.

## Architecture

```
Lightning Web Components
          |
          v
   Apex Controller & Services
          |
          v
     Salesforce Data (SOQL / DML)
          ^
          |
     Salesforce Flow
```

The Apex layer follows a strict separation of concerns:

```
Trigger -> Trigger Handler -> Service Layer -> Selector -> Salesforce Database
```

- **Trigger Handler** — manages trigger context, delegates processing
- **Service** — contains business rules
- **Selector** — centralizes SOQL queries

## Features

- **Customer 360** — unified view of a customer: visits, purchases, opportunities, tasks, cases
- **Store performance dashboard** — revenue, customers, visits, conversion rate, target progress, top stores/reps
- **Customer Visit tracking** — check-in/check-out, purchase flag, automated follow-up tasks
- **Salesforce Flow automation**:
  - Visit follow-up flow (creates a task when no purchase was made)
  - Recommendation notification flow (confidence ≥ 80%)
  - Opportunity approval flow (manager approval above a threshold)
- **Role-based security** — Permission Sets for Admin, Manager, Sales Rep, Read Only, following least privilege

## Data model

| Object | Description |
|---|---|
| `Store__c` | A retail store |
| `CustomerVisit__c` | A recorded customer visit |
| `Recommendation__c` | A product recommendation |
| `SalesRepPerformance__c` | Sales rep performance metrics |

Plus standard objects: `Account`, `Contact`, `Product2`, `Opportunity`, `Case`, `Task`, `User`.

## Technology stack

| Technology | Purpose |
|---|---|
| Salesforce Platform | CRM, data, security, automation |
| Apex | Server-side business logic |
| Lightning Web Components | Modern UI |
| SOQL | Data queries |
| Salesforce Flow | Declarative automation |
| Salesforce CLI / DX | Source-driven project management |
| Git / GitHub | Version control and collaboration |

## Development workflow

```
User Story -> Git Branch -> Development -> Local Tests -> Pull Request
   -> Code Review -> Integration -> Release
```

Commit convention: `feat:`, `fix:`, `refactor:`, `docs:`

## Environments

`Development -> Integration -> UAT -> Staging -> Production`

## Project structure

```
retail360-salesforce/
├── force-app/
│   └── main/default/
│       ├── classes/
│       ├── triggers/
│       ├── lwc/
│       ├── flows/
│       ├── objects/
│       ├── permissionsets/
│       └── layouts/
├── config/
├── scripts/
├── docs/
│   ├── architecture/
│   └── screenshots/
├── sfdx-project.json
└── README.md
```

## Roadmap — next steps

- REST API to expose customer data
- Automated Apex tests (unit, negative, bulk)
- CI/CD pipeline with GitHub Actions
- Recommendation engine logic

## Documentation

Architecture diagrams and screenshots are available in [`/docs`](./docs).

## Author

**Mohamed Boukouch** — Portfolio project, 2026
