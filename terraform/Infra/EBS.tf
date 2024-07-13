# Criar Volume EBS
resource "aws_ebs_volume" "volume-mongodb" {
  availability_zone = var.availability_zone
  size               = var.size
  type               = var.type

  tags = {
    Name = "volume-mongodb"
  }
}


