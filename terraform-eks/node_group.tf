resource "aws_eks_node_group" "app_ng" {
  cluster_name    = aws_eks_cluster.eks_cluster.name

  node_group_name = "app_ng"
  node_role_arn   = aws_iam_role.app_ng_iam.arn

  subnet_ids      = [
    aws_subnet.app_prv_a.id,
    aws_subnet.app_prv_c.id
  ]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]

	# Optional: Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}