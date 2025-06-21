variable "vpc_id" {
  description = "The ID of the VPC where the private subnet will be created."
  type        = string

}
variable "private_subnet_cidr" {
  description = "The CIDR block for the private subnet."
  type        = string
}
variable "private_az" {
  description = "The availability zone in which the private subnet will be created."
  type        = string
}

variable "public_subnet_id" {
  description = "The ID of the public subnet to associate with the private subnet."
  type        = string
}