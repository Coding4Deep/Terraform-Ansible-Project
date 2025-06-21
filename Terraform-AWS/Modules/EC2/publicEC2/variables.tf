variable "publicEC2_ami_id" {
  description = "AMI ID for the public EC2 instance"
  type        = string
}
variable "publicEC2_instance_type" {
  description = "Instance type for the public EC2 instance"
  type        = string
}
variable "key_name" {
  description = "Key pair name for SSH access to the public EC2 instance"
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