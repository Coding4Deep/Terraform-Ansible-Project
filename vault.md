# 🛡️ HashiCorp Vault: Server Modes, Storage Backends, and Setup Guide

This document explains the different types of Vault server modes and storage backends, how to set up Vault using `file` and `raft` backends, and provides shell scripts to automate the setup. It also includes how to store and retrieve secrets securely.

---

## 🔍 What is Vault Dev Server?

The **development (`-dev`) server mode** in Vault is designed for testing and learning. It is:

* 🔄 In-memory only (no data persistence)
* ⚠️ Not meant for production
* 🧪 Good for quick testing and demos

```bash
vault server -dev
```

### Limitations of Dev Mode:

* Every time you stop it, all secrets/configs are lost
* Auto-initialized and auto-unsealed
* Root token is auto-generated and printed

---

## 🏢 What is Vault Production Server?

A **production Vault server** runs with persistent and secure storage, proper TLS, audit logging, and authentication controls.

Vault supports multiple **storage backends**:

| Backend    | Persistent | HA Support | Best For                 |
| ---------- | ---------- | ---------- | ------------------------ |
| `file`     | ✅ Yes      | ❌ No       | Local, dev/prod (non-HA) |
| `raft`     | ✅ Yes      | ✅ Yes      | Production, HA setup     |
| `consul`   | ✅ Yes      | ✅ Yes      | External cluster setups  |
| `dynamodb` | ✅ Yes      | ✅ Yes      | Cloud-native (AWS)       |

---

## 🧾 Vault Setup with File Backend

### 1️⃣ Create Configuration

`vault-file.hcl`

```hcl
storage "file" {
  path = "/opt/vault/data"
}

listener "tcp" {
  address     = "127.0.0.1:8200"
  tls_disable = 1
}

disable_mlock = true
ui = true
```

### 2️⃣ Create Directory

```bash
sudo mkdir -p /opt/vault/data
sudo chown $USER /opt/vault/data
```

### 3️⃣ Start the Server

```bash
vault server -config=vault-file.hcl
```

---

## 🧾 Vault Setup with Raft Backend

### 1️⃣ Create Configuration

`vault-raft.hcl`

```hcl
storage "raft" {
  path    = "/opt/vault/data"
  node_id = "vault-1"
}

listener "tcp" {
  address     = "127.0.0.1:8200"
  cluster_address = "127.0.0.1:8201"
  tls_disable = 1
}

ui = true
disable_mlock = true

# Advertise to other nodes if needed (optional for single-node)
api_addr     = "http://127.0.0.1:8200"
cluster_addr = "http://127.0.0.1:8201"

```

### 2️⃣ Create Directory

```bash
sudo mkdir -p /opt/vault/data
sudo chown $USER /opt/vault/data
```

### 3️⃣ Start the Server

```bash
vault server -config=vault-raft.hcl
```

---

## 🔐 Initialize, Unseal & Login

### In a New Terminal:

```bash
export VAULT_ADDR='http://127.0.0.1:8200'

# Initialize (Run Once)
vault operator init

#This will generate:
#5 Unseal Keys
#1 Root Token
#Store these securely

# Unseal (Run 3 times)
vault operator unseal <key1>
vault operator unseal <key2>
vault operator unseal <key3>

# Login
vault login <Root-Token>
```

---

## 🔏 Store and Retrieve Secrets

### 1️⃣ Store a Secret

```bash
vault kv put secret/awscreds \
  access_key=AKIAEXAMPLE123 \
  secret_key=abc123examplekey \
  region=us-east-1
```

### 2️⃣ Read a Secret

```bash
vault kv get secret/myapp

```

---

## 🚀 Shell Script: Run Vault and Bootstrap

Save this as `vault-setup.sh`:

```bash

#!/bin/bash

set -e

echo "📄 Writing Raft config file..."
cat <<EOF > vault-raft.hcl
storage "raft" {
  path    = "/opt/vault/data"
  node_id = "vault-1"
}
listener "tcp" {
  address     = "127.0.0.1:8200"
  cluster_address = "127.0.0.1:8201"
  tls_disable = 1
}
ui = true
disable_mlock = true
api_addr     = "http://127.0.0.1:8200"
cluster_addr = "http://127.0.0.1:8201"
EOF

echo "📁 Creating storage directory..."
sudo mkdir -p /opt/vault/data
sudo chown \$USER /opt/vault/data

echo "🚀 Starting Vault server in background..."
vault server -config=vault-raft.hcl > vault.log 2>&1 &
sleep 5

export VAULT_ADDR='http://127.0.0.1:8200'

echo "🔐 Initializing Vault..."
INIT_OUTPUT=\$(vault operator init -format=json)
echo "\$INIT_OUTPUT" > init.json

echo "🔓 Unsealing Vault..."
for i in 0 1 2; do
  KEY=\$(jq -r ".unseal_keys_b64[\$i]" init.json)
  vault operator unseal "\$KEY"
done

ROOT_TOKEN=\$(jq -r ".root_token" init.json)
vault login "\$ROOT_TOKEN" > /dev/null

echo "✅ Logged in with root token."

echo "📦 Enabling KV secret engine (if not enabled)..."
vault secrets enable -path=secret kv || echo "Already enabled."

echo -e "\\n✅ Vault Raft setup complete. Secrets persisted and working!"
