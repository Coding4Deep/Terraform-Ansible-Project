variable "key_name" {
  description = "The name of the key pair to create or use."
  type        = string
}
variable "private_instances" {
  description = "Map of private instance configurations"
  type = map(object({
    ami           = string
    instance_type = string
  }))
}
variable "private_subnet_id" {
  description = "ID of the private subnet for EC2 instances"
  type        = string
}
variable "private_sg_id" {
  description = "ID of the security group for private EC2 instances"
  type        = string
}
variable "publicEC2_ami_id" {
  description = "AMI ID for the public EC2 instance"
  type        = string
}
variable "publicEC2_instance_type" {
  description = "Instance type for the public EC2 instance"
  type        = string
}
variable "public_sg_id" {
  description = "Security group ID for the public EC2 instance"
  type        = string
}
variable "public_subnet_id" {
  description = "Subnet ID for the public EC2 instance"
  type        = string
}
variable "public_instance_name" {
  description = "Name tag for the public EC2 instance"
  type        = string
  default     = "Tomcat"
}