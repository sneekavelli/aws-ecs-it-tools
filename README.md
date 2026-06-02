<img width="472" height="345" alt="ECS_project_ Lucidchart" src="https://github.com/user-attachments/assets/21b8d1db-b24b-4402-9492-1cf2e1e0c25d" />
<img width="472" height="345" alt="ECS_project_ Lucidchart" src="https://github.com/user-attachments/assets/825b3a63-a53a-4883-9e77-b458657c736d" />
## 🚀 Deployment Lifecycle Runbook

### Prerequisites
* **Terraform CLI** (v1.5.0+) installed locally.
* **AWS CLI** configured with appropriate administrative IAM credentials.

### Manual Step Sequence
To initialize and build the infrastructure cleanly from our unified repository layout, execute the configuration steps by targeting the infrastructure subdirectory:

```bash
# 1. Move into the infrastructure configuration directory
cd infra/

# 2. Initialize remote state backend and download required providers
terraform init

# 3. Perform a dry-run execution to audit planned resource builds
terraform plan

# 4. Provision the immutable infrastructure stack to AWS live
terraform apply

# To tear down the infrastructure and avoid costs:
terraform destroy

---

### 🏁 Staging and Syncing with your Remote

With your unified layout set up and the README corrected, let's run a clean sequence to push the finished product up to GitHub. 

Run these three commands in your terminal from the root folder:

```bash
# 1. Stage the completed README along with any other untracked root files
git add .

# 2. Commit the updates with an explicit structural message
git commit -m "docs: correct deployment directory pathways to reflect root repo structure"

# 3. Securely push to your GitHub branch
git push origin main





[ Public Internet ] 
       │
       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ AWS VPC BOUNDARY                                                            │
│                                                                             │
│   ┌───────────────────────┐                                                 │
│   │   Internet Gateway    │◀─────────────────────────────────────────────┐  │
│   └───────────────────────┘                                              │  │
│               │                                                          │  │
│               ▼                                                          │  │
│ 🌐 PUBLIC SUBNETS (ALB Tier)                                               │  │
│   ┌──────────────────────────────────────────────────────────────────┐   │  │
│   │ [ALB Security Group: Ingress 80/443 from 0.0.0.0/0]              │   │  │
│   │                                                                  │   │  │
│   │  Application Load Balancer (Distributed across Public AZ-A/B)    │   │  │
│   │    └─► HTTP-to-HTTPS Redirection Listener                        │   │  │
│   └──────────────────────────────────────────────────────────────────┘   │  │
│               │                                                          │  │
│               ▼ (Forwards traffic across isolation boundary via Target Group)│
│                                                                          │  │
│ 🔒 PRIVATE NETWORK SET 1: APPLICATION TIER                               │  │
│   ┌──────────────────────────────────────────────────────────────────┐   │  │
│   │ [ECS Task Security Group: Ingress from ALB SG Only]              │   <img width="1970" height="1438" alt="Blank diagram_ Lucidchart" src="https://github.com/user-attachments/assets/ce7cfbce-753f-46d9-b7e8-8ffb15463bd6" />
│  │
│   │                                                                  │   │  │
│   │  ┌──────────────────────────────┐  ┌──────────────────────────┐  │   │  │
│   │  │ ECS Fargate Task (AZ-A)       │  │ ECS Fargate Task (AZ-B)  │  │   │  │
│   │  │  └─► it-tools container      │  │  └─► it-tools container  │  │   │  │
│   │  └──────────────────────────────┘  └──────────────────────────┘  │   │  │
│   └──────────────────────────────────────────────────────────────────┘   │  │
│               │                                                          │  │
│               ▼ (Internal VPC Endpoints / Secured Registry Pulls)        │  │
│                                                                          │  │
│ 🔒 PRIVATE NETWORK SET 2: SUPPORT & DATA TIER                            │  │
│   ┌──────────────────────────────────────────────────────────────────┐   │  │
│   │ [Isolated Subnets: No Direct Inbound / Secure Core Services]      │   │  │
│   │                                                                  │   │  │
│   │  ┌──────────────────────────────┐  ┌──────────────────────────┐  │   │  │
│   │  │ Amazon ECR Registry          │  │ CloudWatch Core Logging  │  │   │  │
│   │  └──────────────────────────────┘  └──────────────────────────┘  │   │  │
│   └──────────────────────────────────────────────────────────────────┘   │  │
└─────────────────────────────────────────────────────────────────────────────┘


