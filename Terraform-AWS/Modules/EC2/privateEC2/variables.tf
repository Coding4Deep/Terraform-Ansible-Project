variable "private_instances" {
  type = map(object({
    ami           = string
    instance_type = string
  }))
  description = "Map of private instance configurations"
}

variable "private_subnet_id" {
  type        = string
  description = "ID of the private subnet for EC2 instances"
}

variable "private_sg_id" {
  type        = string
  description = "ID of the security group for private EC2 instances"
}

variable "key_name" {
  type        = string
  description = "Name of the key pair for EC2 instances"
}