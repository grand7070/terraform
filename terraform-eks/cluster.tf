resource "aws_eks_cluster" "eks_cluster" {
  name     = "eks_cluster" # local.cluster_name
  version  = "1.26"
  role_arn = aws_iam_role.eks_cluster_iam.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.app_prv_a.id,
      aws_subnet.app_prv_c.id
    ]
    endpoint_public_access  = false
    endpoint_private_access = true
    security_group_ids = [aws_security_group.cluster_sg.id]
  }

  enabled_cluster_log_types = ["api", "audit"]

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster
  ]
}