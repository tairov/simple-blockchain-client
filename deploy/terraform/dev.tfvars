# terraform plan --var-file=dev.tfvars
# terraform apply --var-file=dev.tfvars

project               = "simple-client"
env                   = "dev"
region                = "eu-central-1"
vpc_cidr              = "10.45.0.0/16"
public_subnet_1_cidr  = "10.45.1.0/24"
public_subnet_2_cidr  = "10.45.2.0/24"
private_subnet_1_cidr = "10.45.11.0/24"
private_subnet_2_cidr = "10.45.12.0/24"
db_subnet_1_cidr      = "10.45.21.0/24"
db_subnet_2_cidr      = "10.45.22.0/24"


ecr_image     = "docker pull ghcr.io/tairov/simple-blockchain-client"
ecr_image_tag = "master"