variable "aws_region" {
  description = "The AWS region to deploy the cluster"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "The name for the EKS cluster"
  type        = string
  default     = "simple-api-cluster"
}

variable "node_count" {
  description = "The number of nodes in the EKS cluster's node group"
  type        = number
  default     = 2
}

variable "instance_type" {
  description = "The instance type for the EKS nodes"
  type        = string
  default     = "t3a.medium"
}