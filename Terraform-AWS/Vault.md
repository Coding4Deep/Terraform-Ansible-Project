# 🔐 Using Vault Secrets in Terraform (AWS Access Key Example)

This guide explains how to securely use **AWS access keys and secret keys** stored in **HashiCorp Vault** in a **Terraform** configuration — without hardcoding sensitive credentials in your `.tf` files.

---

## 📌 Why Use Vault with Terraform?

* ✅ Avoid hardcoding secrets like AWS credentials.
* ✅ Centralize secret management with audit logging, TTL, and dynamic rotation.
* ✅ Inject secrets securely at runtime.

---

## 🛠 Prerequisites

Before getting started, ensure the following are set up:

* [ ] **Terraform** (v0.12 or later) installed on your system — [Install Guide](https://developer.hashicorp.com/terraform/downloads)
* [ ] **Vault** installed and running locally (dev mode is fine for testing) — [Install Vault](https://developer.hashicorp.com/vault/downloads)
* [ ] Set Vault address: `http://127.0.0.1:8200`
* [ ] Copy the root token shown after running `vault server -dev`
* [ ] **AWS access and secret keys** saved to Vault in the KV secrets engine at the path: `secret/awscreds`
* [ ] Internet access to download Terraform providers (like `hashicorp/aws`)

---

## 🔧 Step-by-Step Setup

### 1️⃣ Start Vault in Dev Mode (for testing)

```bash
vault server -dev
```

Copy the **root token** from the output (you'll use this in Terraform).

### 2️⃣ Store AWS Secrets in Vault

```bash
vault kv put secret/awscreds \
  access_key=AKIAEXAMPLE123 \
  secret_key=abc123examplekey \
  region=us-east-1
```

### 3️⃣ Create `main.tf` in Terraform

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.0"
    }
  }
  required_version = ">= 0.12"
}

provider "vault" {
  address = "http://127.0.0.1:8200"
  token   = var.vault_token
}

data "vault_generic_secret" "awscreds" {
  path = "secret/awscreds"
}

provider "aws" {
  access_key = data.vault_generic_secret.awscreds.data["access_key"]
  secret_key = data.vault_generic_secret.awscreds.data["secret_key"]
  region     = data.vault_generic_secret.awscreds.data["region"]
}

resource "aws_s3_bucket" "example" {
  bucket = "my-secure-bucket-terraform"
  acl    = "private"
}
```

### 4️⃣ Define Variables in `variables.tf`

```hcl
variable "vault_token" {
  type        = string
  description = "Vault root token"
  sensitive   = true
}
```

### 5️⃣ Set Token in `terraform.tfvars` or as ENV variable

```hcl
vault_token = "s.xxxxxx"
```

*or as environment variable:*

```bash
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=s.xxxxxx
```

### 6️⃣ Run Terraform

```bash
terraform init
terraform plan
terraform apply
```

---

## ✅ Result

* Your AWS credentials are **dynamically loaded from Vault**.
* No secrets are hardcoded.
* This setup is **Jenkins- and CI/CD-friendly**.

---

## 🔒 Security Tip

Even in dev mode, avoid sharing your root Vault token. For production, use Vault AppRole auth or dynamic AWS credentials instead.

---

## 📁 Files Structure (Summary)

```
.
├── main.tf
├── variables.tf
├── terraform.tfvars  (or use ENV vars)
```

---

## 💬 Need Dynamic AWS Credentials from Vault?

You can also use Vault's AWS secrets engine to generate temporary AWS keys. Ask if you'd like a guide for that!
