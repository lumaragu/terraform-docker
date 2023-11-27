variable "vpc_id" {}
variable "subnets" {
  type = list(string)
}
variable "public_subnet" {}

resource "aws_ecs_cluster" "main" {
  name = "my-ecs-cluster"
}

output "cluster_id" {
  value = aws_ecs_cluster.main.id
}
