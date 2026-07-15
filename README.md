# AWS Terraform & Database Reliability Assessment

This repository contains an enterprise-grade AWS infrastructure design using Terraform and a local Dockerized PostgreSQL database focused on reliability, disaster recovery, and query optimization.

## 🏗️ Architecture Overview
*   **Infrastructure as Code (Terraform):** Modularized deployment of a highly available VPC.
*   **Compute:** Application Load Balancer (ALB) routing to ECS Fargate (Private Subnets).
*   **Database:** Amazon RDS PostgreSQL deployed in strictly isolated private subnets, allowing ingress only from ECS.
*   **CI/CD:** GitHub Actions pipeline for automated Terraform formatting, validation, and security scanning.

## 🚀 Setup & Verification Steps

### Prerequisites
*   Docker & Docker Compose installed.
*   Terraform (v1.5.0+) installed locally (optional, for local planning).

### 1. Local Database Environment
Spin up the PostgreSQL database. The startup process automatically seeds the tables and applies performance indexes.
```bash
make db-up
