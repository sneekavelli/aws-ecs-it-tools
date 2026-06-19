

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

<img width="1536" height="1024" alt="AWS-ECS-ARCH-DIAGRAM" src="https://github.com/user-attachments/assets/05896eb1-ab99-43ee-9975-bc5064bbe55c" />





