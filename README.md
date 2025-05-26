# Self-Hosted GitLab Project

This project provisions a fully self-hosted GitLab CE instance on AWS EC2 using Terraform. It automates the infrastructure setup, installs GitLab, and prepares the environment for CI/CD pipelines. A GitLab Runner can also be configured separately with custom business hour behavior.

## Requirements

To run this project, ensure the following are installed and configured on your local machine:

- [Terraform](https://developer.hashicorp.com/terraform/install)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [Git](https://git-scm.com/)
- [WSL 2](https://learn.microsoft.com/en-us/windows/wsl/) or Linux/macOS terminal

### AWS Setup
1. Create an AWS account at https://aws.amazon.com
2. Create an IAM user with AdministratorAccess
3. Generate Access Key and Secret Access Key

Configure your credentials locally:
```bash
aws configure
```
Enter:
- AWS Access Key ID
- AWS Secret Access Key
- Default region name (e.g., us-east-1)
- Default output format (e.g., json)

### Permissions
Your IAM user should have permissions for:
- EC2
- VPC
- IAM (for key pair)
- Networking resources (subnets, route tables, etc.)

## How to Run the Project

### 1. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/gitlab-selfhost.git
cd gitlab-selfhost
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Review the plan

```bash
terraform plan -var-file="custom.tfvars"
```

### 4. Apply the infrastructure

```bash
terraform apply -var-file="custom.tfvars"
```
Type `yes` when prompted.

### 5. Access GitLab

Once provisioning is complete:
- Run `terraform output gitlab_public_ip`
- Open your browser and visit `http://<public-ip>`
- SSH into the instance:
  ```bash
  chmod 600 gitlab-selfhost-key.pem
  ssh -i gitlab-selfhost-key.pem ubuntu@<public-ip>
  ```
- View login credentials:
  ```bash
  cat /home/ubuntu/gitlab_credentials.txt
  ```

## Cleaning Up

To avoid AWS charges, destroy all resources with:

```bash
terraform destroy -var-file="custom.tfvars"
```

## Notes

- The private key file (`gitlab-selfhost-key.pem`) is created automatically by Terraform. Make sure it's excluded from version control using `.gitignore`.
