variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "cluster_id" {
  description = "ECS cluster ID"
}

variable "ecr_repository_url" {
  description = "URL of the ECR repository"
}
