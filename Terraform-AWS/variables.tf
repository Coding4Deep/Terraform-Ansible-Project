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

variable "key_name" {
  description = "The name of the key pair to create or use."
  type        = string
  default     = "Terraform-ansible-Key"

}

variable "private_instances" {
  description = "Map of private instance configurations"
  type = map(object({
    ami           = string
    instance_type = string
  }))
  default = {
    "Memcached" = {
      ami           = "ami-020cba7c55df1f615"
      instance_type = "t2.micro"
    },
    "RabbitMQ" = {
      ami           = "ami-020cba7c55df1f615"
      instance_type = "t2.micro"
    },
    "MongoDB" = {
      ami           = "ami-020cba7c55df1f615"
      instance_type = "t2.micro"
    }
  }
}

variable "publicEC2_ami_id" {
  description = "AMI ID for the public EC2 instance"
  type        = string
  default     = "ami-020cba7c55df1f615"
}
variable "publicEC2_instance_type" {
  description = "Instance type for the public EC2 instance"
  type        = string
  default     = "t2.micro"
}
variable "public_instance_name" {
  description = "Name tag for the public EC2 instance"
  type        = string
  default     = "Tomcat"
}