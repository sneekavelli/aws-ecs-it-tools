# AWS ECS Fargate Infrastructure Project

A production-style AWS container deployment built with **Terraform, Docker, Amazon ECS Fargate, ECR, Application Load Balancer, Route 53 and ACM**.

The project deploys the open-source IT-Tools application from source into a secure AWS network architecture. ECS tasks run inside **private subnets** without public IP addresses, while an internet-facing Application Load Balancer provides HTTPS access to the application.

## 🌐 Live Application

**https://it-tools.humblehotheads.com**

The application is served over HTTPS using an AWS ACM certificate.

HTTP requests on port 80 are automatically redirected to HTTPS on port 443.

---

## 🏗️ Architecture

<img width="1536" height="1024" alt="AWS ECS Fargate Architecture Diagram" src="https://github.com/user-attachments/assets/c3dd5341-c83c-4546-8145-188470e110fa" />

> **Note:** The architecture diagram should reflect the current deployment: the ALB resides in public subnets while ECS Fargate tasks reside in private subnets and use a NAT Gateway for outbound internet access.

### Traffic Flow

```text
Internet
   │
   ▼
Route 53
it-tools.humblehotheads.com
   │
   ▼
Application Load Balancer
Public Subnets
   │
   ├── HTTP :80 ──► 301 Redirect ──► HTTPS :443
   │
   └── HTTPS :443
            │
            ▼
      Target Group :80
            │
            ▼
       ECS Fargate
      Private Subnets
            │
            ▼
       IT-Tools :80
```

The ECS tasks do **not** receive public IP addresses.

Outbound traffic from the private subnets follows:

```text
ECS Fargate
     │
     ▼
Private Route Table
     │
     ▼
NAT Gateway
     │
     ▼
Internet Gateway
     │
     ▼
Internet
```

---

## 🔐 Network Design

The VPC is divided into public and private networking tiers.

### Public Subnets

The public subnets contain:

- Application Load Balancer
- NAT Gateway

The ALB accepts:

- TCP/80 — HTTP
- TCP/443 — HTTPS

HTTP traffic is redirected to HTTPS.

### Private Subnets

The ECS Fargate tasks run in private subnets across multiple Availability Zones:

```text
eu-west-2a → 10.0.3.0/24
eu-west-2b → 10.0.4.0/24
```

ECS is configured with:

```text
assign_public_ip = false
```

The tasks therefore cannot be accessed directly from the internet.

The ECS security group accepts application traffic on port 80 **only from the ALB security group**.

---

## 🐳 Container Build

The application is built from source using a multi-stage Docker build.

```text
Application Source
       │
       ▼
Node / pnpm Build Stage
       │
       ▼
Production Build
       │
       ▼
Nginx Runtime Stage
       │
       ▼
Docker Image
```

The final container serves IT-Tools using Nginx on:

```text
Port 80
```

The image is built for:

```text
linux/amd64
```

This ensures compatibility with the ECS Fargate task architecture.

---

## 📦 Amazon ECR

The Docker image is stored in Amazon Elastic Container Registry.

Repository:

```text
it-tools-app
```

Deployment flow:

```text
Source Code
    │
    ▼
Docker Build
    │
    ▼
Docker Image
    │
    ▼
Amazon ECR
    │
    ▼
ECS Task Definition
    │
    ▼
ECS Fargate Service
```

---

## ⚖️ Application Load Balancer

The internet-facing ALB runs in the public subnets.

Two listeners are configured.

### HTTP Listener

```text
Port:     80
Protocol: HTTP
Action:   Redirect
          ↓
          HTTPS :443
```

### HTTPS Listener

```text
Port:     443
Protocol: HTTPS
Action:   Forward
          ↓
Target Group :80
```

The target group forwards traffic to the ECS container on port 80.

---

## 🔒 TLS / SSL

AWS Certificate Manager provides the TLS certificate for:

```text
it-tools.humblehotheads.com
```

Terraform creates the required Route 53 DNS validation record and waits for AWS to validate the certificate.

The validated certificate is attached to the ALB HTTPS listener.

---

## 🌍 Route 53

Route 53 maps:

```text
it-tools.humblehotheads.com
```

to the Application Load Balancer using an alias record.

This provides the public DNS endpoint for the application.

---

## 🧰 Technologies Used

| Technology | Purpose |
|---|---|
| Terraform | Infrastructure as Code |
| AWS VPC | Network isolation |
| ECS Fargate | Serverless container runtime |
| Amazon ECR | Docker image registry |
| Application Load Balancer | Public application entry point |
| Route 53 | DNS |
| AWS ACM | TLS certificate |
| NAT Gateway | Private subnet outbound internet |
| Docker | Application packaging |
| Nginx | Production web server |
| GitHub | Source control |

---

## 📁 Repository Structure

```text
it-tools/
├── app/
│   ├── Dockerfile
│   └── application source
│
├── infra/
│   ├── main.tf
│   ├── security.tf
│   ├── certificates.tf
│   ├── modules/
│   │   ├── acm/
│   │   ├── alb/
│   │   ├── dns/
│   │   ├── ecr/
│   │   ├── ecs/
│   │   └── vpc/
│   └── ...
│
└── README.md
```

The `infra/` directory is the source of truth for the deployed AWS infrastructure.

---

## 🚀 Deployment Lifecycle Runbook

### Prerequisites

Install and configure:

- Terraform
- AWS CLI
- Docker
- AWS credentials with the required permissions

### 1. Build the application

From the application directory:

```bash
cd app

docker build \
  --platform linux/amd64 \
  -t it-tools-source .
```

Verify the architecture:

```bash
docker image inspect \
  it-tools-source \
  --format '{{.Architecture}}/{{.Os}}'
```

Expected:

```text
amd64/linux
```

### 2. Authenticate Docker with ECR

```bash
aws ecr get-login-password \
  --region eu-west-2 |
docker login \
  --username AWS \
  --password-stdin \
  <AWS_ACCOUNT_ID>.dkr.ecr.eu-west-2.amazonaws.com
```

### 3. Tag and push the image

```bash
docker tag \
  it-tools-source:latest \
  <AWS_ACCOUNT_ID>.dkr.ecr.eu-west-2.amazonaws.com/it-tools-app:latest

docker push \
  <AWS_ACCOUNT_ID>.dkr.ecr.eu-west-2.amazonaws.com/it-tools-app:latest
```

### 4. Deploy infrastructure

```bash
cd ../infra

terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

For a reviewed saved plan:

```bash
terraform plan -out=tfplan
terraform apply tfplan
```

### 5. Verify ECS

```bash
aws ecs describe-services \
  --cluster it-tools-cluster \
  --services it-tools-service \
  --region eu-west-2 \
  --query 'services[0].{running:runningCount,pending:pendingCount,desired:desiredCount,status:status}'
```

A healthy service should show:

```json
{
  "running": 1,
  "pending": 0,
  "desired": 1,
  "status": "ACTIVE"
}
```

### 6. Verify HTTPS

```bash
curl -I https://it-tools.humblehotheads.com
```

Expected:

```text
HTTP/2 200
```

Verify the HTTP redirect:

```bash
curl -I http://it-tools.humblehotheads.com
```

Expected:

```text
HTTP/1.1 301 Moved Permanently
Location: https://it-tools.humblehotheads.com:443/
```

---

## 🧹 Destroying the Infrastructure

To remove Terraform-managed infrastructure:

```bash
cd infra
terraform plan -destroy
terraform destroy
```

Review the proposed destruction carefully before confirming.

---

## 🛡️ Security Design

Several security improvements are implemented:

- ECS tasks run in private subnets.
- ECS tasks have no public IP addresses.
- Only the ALB is internet-facing.
- ECS accepts inbound application traffic only from the ALB security group.
- HTTPS is enforced through an HTTP-to-HTTPS redirect.
- TLS certificates are managed through AWS ACM.
- Private workloads use a NAT Gateway for outbound connectivity.
- Terraform is used to provide reproducible infrastructure.

---

## 🎯 What This Project Demonstrates

This project demonstrates practical experience with:

- Infrastructure as Code using Terraform
- Terraform modules, variables and outputs
- AWS VPC networking
- Public and private subnet design
- Internet Gateway and NAT Gateway routing
- ECS Fargate container orchestration
- Docker multi-stage builds
- Amazon ECR
- Application Load Balancers
- ALB target groups and health checks
- Security groups
- Route 53 DNS
- ACM certificate validation
- HTTPS termination and HTTP redirects
- AWS CLI deployment troubleshooting
- Terraform state and execution plans

---

## ✅ Deployment Status

The deployed environment has been verified with:

```text
Terraform:     Infrastructure matches configuration
ECS Service:   ACTIVE
Desired Tasks: 1
Running Tasks: 1
Pending Tasks: 0
HTTPS:         HTTP/2 200
HTTP:          301 → HTTPS
```
