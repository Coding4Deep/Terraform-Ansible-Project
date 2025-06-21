variable "vault_token" {
  description = "Vault token for accessing AWS credentials"
  type        = string
  sensitive   = true
}

# VPC CONFIGURATION

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.1.0/24"
}
variable "private_az" {
  description = "Availability zone for the private subnet"
  type        = string
  default     = "us-east-1a"
}
variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.2.0/24"
}
variable "public_az" {
  description = "Availability zone for the public subnet"
  type        = string
  default     = "us-east-1b"
}