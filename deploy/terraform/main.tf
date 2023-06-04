module "vpc" {
  source                = "./modules/vpc/"
  project               = var.project
  env                   = var.env
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  public_subnet_1_cidr  = var.public_subnet_1_cidr
  public_subnet_2_cidr  = var.public_subnet_2_cidr
  vpc_cidr              = var.vpc_cidr
  db_subnet_1_cidr      = var.db_subnet_1_cidr
  db_subnet_2_cidr      = var.db_subnet_2_cidr
}
