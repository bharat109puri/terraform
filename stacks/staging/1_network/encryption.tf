resource "aws_kms_key" "eks" {
  description             = "EKS Secret Encryption Key for ${var.name} environment"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "eks" {
  name          = "alias/${var.name}_eks"
  target_key_id = aws_kms_key.eks.key_id
}
