locals {
  cluster_name = "eks-demo"
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  # The log group name format is /aws/eks/<cluster-name>/cluster
  # Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 7

  # ... potentially other configuration ...
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = "eks-cluster" # local.cluster_name
  version  = "1.25"
  role_arn = aws_iam_role.eks_cluster_iam.arn

  vpc_config {
    subnet_ids = [aws_subnet.private.*.id]
    endpoint_private_access = true
    endpoint_public_access  = false
  }

	depends_on = [aws_cloudwatch_log_group.example]
	enabled_cluster_log_types = ["api", "audit"]

	# Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController,
  ]
  depends_on = [
    aws_security_group_rule.cluster,
  ]
}