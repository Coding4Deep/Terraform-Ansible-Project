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


module "vpc" {
  source              = "./Modules/VPC"
  vpc_cidr_block      = var.vpc_cidr_block
  private_subnet_cidr = var.private_subnet_cidr
  private_az          = var.private_az
  public_subnet_cidr  = var.public_subnet_cidr
  public_az           = var.public_az

}