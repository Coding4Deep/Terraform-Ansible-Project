resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "TerraAnsiProjectVPC"
  }
}

module "private_subnet" {
  source              = "./privateSubnet"
  vpc_id              = aws_vpc.vpc.id
  private_subnet_cidr = var.private_subnet_cidr
  private_az          = var.private_az
  public_subnet_id    = module.public_subnet.public_subnet_id

}

module "public_subnet" {
  source             = "./publicSubnet"
  vpc_id             = aws_vpc.vpc.id
  public_subnet_cidr = var.public_subnet_cidr
  public_az          = var.public_az
}