resource "aws_security_group" "eks_sg" {
  name        = "${var.name}_eks_sg"
  description = "security group for ${var.name} EKS"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "${var.name}_eks_sg"
  }
}
