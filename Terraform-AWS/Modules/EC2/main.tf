module "key_pair" {
  source   = "./keypair"
  key_name = var.key_name
}

module "private_ec2" {
  source            = "./privateEC2"
  private_instances = var.private_instances
  private_subnet_id = var.private_subnet_id
  private_sg_id     = var.private_sg_id
  key_name          = module.key_pair.key_pair_name
}

module "public_ec2" {
  source                  = "./publicEC2"
  publicEC2_ami_id        = var.publicEC2_ami_id
  publicEC2_instance_type = var.publicEC2_instance_type
  key_name                = module.key_pair.key_pair_name
  public_sg_id            = var.public_sg_id
  public_subnet_id        = var.public_subnet_id
  public_instance_name    = var.public_instance_name
}