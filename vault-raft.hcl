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
