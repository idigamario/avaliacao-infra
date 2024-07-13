variable "cluster_name" {
  type = string
}

variable "terraform_user_name" {
  type = string
  default = "terraform-user"
}

variable "availability_zone" {
  type = string
}

variable "size" {
  type = number
  default = 10
}

variable "type" {
  type = string
  default = "gp2"
}

variable "kube_config_context" {
  type = string
}

variable "kube_config_user" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}

variable "eks_cluster_version" {
  type = string
  default = "1.21"
}

variable "eks_cluster_role_name" {
  type = string
  default = "eks-cluster-role"
}

variable "eks_cluster_ebs_access_name" {
  type = string
  default = "eks-cluster-ebs-access"
}

variable "eks_cluster_instance_profile_name" {
  type = string
  default = "eks-cluster-instance-profile"
}

variable "eks_cluster_subnet_ids" {
  type = list(string)
}

variable "eks_cluster_pod_subnet_id" {
  type = string
}

variable "eks_cluster_endpoint_public_access" {
  type = bool
  default = false
}

variable "ecr_repository" {
  type = string
}

variable "ecr_region" {
  type = string
}

variable "ecr_registry_id" {
  type = string
}


