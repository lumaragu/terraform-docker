output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnet" {
  value = module.vpc.public_subnet
}

output "cluster_id" {
  value = module.ecs.cluster_id
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}
