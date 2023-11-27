provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
}

module "ecs" {
  source        = "./modules/ecs"
  vpc_id        = module.vpc.vpc_id
  subnets       = module.vpc.private_subnets
  public_subnet = module.vpc.public_subnet
}

module "ecr" {
  source = "./modules/ecr"
}

module "ecs_service" {
  source             = "./modules/ecs-service"
  cluster_id         = "your-ecs-cluster-id"
  private_subnets    = module.vpc.private_subnets
  ecr_repository_url = module.ecr.repository_url
}

module "load_balancer" {
  source        = "./modules/load-balancer"
  vpc_id        = module.vpc.vpc_id
  public_subnet = module.vpc.public_subnet
}
