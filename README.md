# Initial setup

```bash
# 1. Open https://shell.cloud.google.com/?hl=en_US&fromcloudshell=true&show=ide

# 2. Install Cloud Shell Editor extensions:
# - HashiCorp Terraform

# 3. Clone repository
cd "${HOME}"
git clone https://github.com/piotrwozniak28/uam-data-governance-2025.git
cd "${HOME}/uam-data-governance-2025/resource-based-infra"

# 4. Input your values to terraform.tfvars
cp terraform.example.tfvars terraform.tfvars # No need to input value for "dwh_client_email"; org_id is my (Piotr W) private org's id
gcloud beta billing accounts list --format=json | jq -r '.[].name | split("/")[-1]' # billing_account_id
gcloud info --format json | jq -r '.config.account' # current_user_email

# 5. Run terraform
terraform init
terraform plan
terraform apply

# 6. Continue with "templates_outputs/070_README.tmp.md"
```
