resource "aws_iam_role" "cluster_role" {
  name = "cloud4devs-cluster-role"

  assume_role_policy = <<POLICY
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
POLICY
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_role.name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster_role.name
}

resource "aws_security_group" "cluster_sg" {
  name        = "cloud4devs-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cloud4devs"
  }
}

resource "aws_security_group_rule" "cluster_ingress_rule" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow to communicate with the cluster API Server."
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.cluster_sg.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_eks_cluster" "this" {
  name     = "cloud4devs"
  role_arn = aws_iam_role.cluster_role.arn
  version  = 1.22

  vpc_config {
    security_group_ids = [aws_security_group.cluster_sg.id]
    subnet_ids         = [data.aws_subnets.default.ids[0], data.aws_subnets.default.ids[1]]
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSVPCResourceController,
  ]

  # Configure file ~/.kube/config with cluster credentials
  provisioner "local-exec" {
    command = "aws eks --region us-east-1 update-kubeconfig --name cloud4devs"
  }
}