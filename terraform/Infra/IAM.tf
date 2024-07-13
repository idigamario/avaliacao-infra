# Criar Usuário IAM para o Terraform
resource "aws_iam_user" "terraform_user" {
  name = var.terraform_user_name
}

# Criar Chave de Acesso para o Usuário IAM
resource "aws_iam_access_key" "terraform_access_key" {
  user = aws_iam_user.terraform_user.id
}

# Anexar Policy ao Usuário IAM para Gerenciar EBS
resource "aws_iam_user_policy" "terraform_ebs_policy" {
  user = aws_iam_user.terraform_user.id

  policy = <<-EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AttachVolume",
        "ec2:CreateVolume",
        "ec2:DeleteVolume",
        "ec2:DetachVolume",
        "ec2:DescribeVolumes",
        "ec2:ModifyVolume"
      ],
      "Resource": "*"
    }
  ]
}
EOT
}


# Criar Role IAM para o Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = var.eks_cluster_role_name

  assume_role_policy = <<-EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOT
}

# Anexar Policy de Acesso ao EBS para o Cluster
resource "aws_iam_role_policy" "eks_cluster_ebs_access" {
  name = var.eks_cluster_ebs_access_name
  role  = aws_iam_role.eks_cluster_role.arn

  policy = <<-EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AttachVolume",
        "ec2:CreateVolume",
        "ec2:DeleteVolume",
        "ec2:DetachVolume",
        "ec2:DescribeVolumes",
        "ec2:ModifyVolume"
      ],
      "Resource": "*"
    }
  ]
}
EOT
}

# Anexar Policy de Acesso ao ECR para o Cluster
resource "aws_iam_role_policy" "eks_cluster_ecr_access" {
  name = var.eks_cluster_ecr_access_name
  role  = aws_iam_role.eks_cluster_role.arn

  policy = <<-EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:BatchDeleteImage",
        "ecr:BatchGetImage",
        "ecr:CompleteLayerUpload",
        "ecr:DeleteImage",
        "ecr:DeleteRepository",
        "ecr:GetAuthorizationToken",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetImage",
        "ecr:GetImageTag",
        "ecr:InitiateLayerUpload",
        "ecr:ListImages",
        "ecr:PutImage",
        "ecr:SetImageTag",
        "ecr:StartImageScan",
        "ecr:StopImageScan"
      ],
      "Resource": [
        "arn:aws:ecr:${var.ecr_region}:${var.ecr_registry_id}:*"
      ]
    }
  ]
}
EOT
}

# Criar Instance Profile para o Cluster
resource "aws_iam_instance_profile" "eks_cluster_instance_profile" {
  name = var.eks_cluster_instance_profile_name
  role = aws_iam_role.eks_cluster_role.arn
}

# Configurar o Cluster Kubernetes
resource "kubernetes_cluster" "eks_cluster" {
  name     = var.eks_cluster_name
  provider = "aws/eks"

  version = var.eks_cluster_version

  # Configurar o IAM Role para o Cluster
  role_arn = aws_iam_instance_profile.eks_cluster_instance_profile.arn

  # Adicionar o EBS como Fonte de Volume
  cluster_configuration {
    networking {
      vpc_config {
        subnet_ids = [var.eks_cluster_subnet_ids]
      }
    }

    resources {
      feature_flags = ["PodOverprovisioning"]
    }

    identity {
      addon_management {
        cluster_auto_scaler = {
          enabled = true
        }
      }
    }

    container_networking {
      pod_subnet_id = var.eks_cluster_pod_subnet_id
    }

    endpoint_public_access = var.eks_cluster_endpoint_public_access

    volume_configuration {
      enable_fsx_integration = true
    }
  }

  kubernetes_version = var.kubernetes_version
}

# Saída para obter o ARN do Cluster EKS
output "eks_cluster_arn" {
  value = kubernetes_cluster.eks_cluster.arn
}

# Saída para obter o nome do cluster EKS
output "eks_cluster_name" {
  value = kubernetes_cluster.eks_cluster.name
}