resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.example.name
  addon_name   = "kube-proxy"
  addon_version = "1.21.2-eksbuild.1" # 버전 선택
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.example.name
  addon_name   = "coredns"
  addon_version = "1.8.4-eksbuild.1" # 버전 선택
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.example.name
  addon_name   = "vpc-cni"
  addon_version = "1.9.3-eksbuild.1" # 버전 선택
}

resource "aws_eks_addon" "guardduty" {
  cluster_name = aws_eks_cluster.example.name
  addon_name   = "guardduty"
  addon_version = "1.0.0-eksbuild.1" # 버전 선택
}