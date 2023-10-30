resource "aws_ecr_repository" "my_registry" {
  name = "my-docker-registry"
}

data "aws_iam_policy_document" "ecr_policy" {
  statement {
    actions   = ["ecr:GetDownloadUrlForLayer", "ecr:GetAuthorizationToken", "ecr:GetRegistryCatalogData"]
    resources = [aws_ecr_repository.my_registry.arn]
  }
}

resource "aws_iam_policy" "ecr_policy" {
  name        = "my-ecr-policy"
  description = "ECR access policy"
  policy      = data.aws_iam_policy_document.ecr_policy.json
}

resource "aws_iam_role" "ecr_role" {
  name = "ecr-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecr.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_policy_attachment" {
  policy_arn = aws_iam_policy.ecr_policy.arn
  role       = aws_iam_role.ecr_role.name
}

resource "aws_eks_cluster_auth" "my_eks_cluster_auth" {
  name = aws_eks_cluster.my_eks.name

  depends_on = [aws_eks_cluster.my_eks]
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name = "aws-auth"
  }

  data = {
    mapRoles = <<-EOF
    - rolearn: ${aws_iam_role.eks_cluster_role.arn}
      username: kubernetes
      groups:
        - system:masters
    - rolearn: ${aws_iam_role.ecr_role.arn}
      username: build
      groups:
        - system:basic
    EOF
  }

  depends_on = [aws_eks_cluster_auth.my_eks_cluster_auth]
}

