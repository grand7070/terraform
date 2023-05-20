resource "aws_security_group" "alb_sg" {
    name        = "alb_sg"
    description = "security group for application load balancer"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        description = "For https port"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "alb_sg"
    }
}

resource "aws_security_group" "bastion_sg" {
  name = "bastion_sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "For ssh port"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [local.my_ip]
  }

  ingress {
    description = "For argocd port"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [local.my_ip]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "bastion_sg"
  }
}

resource "aws_security_group" "cluster_sg" {
    name        = "cluster_sg"
    description = "security group for cluster"
    vpc_id      = aws_vpc.vpc.id

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
        Name = "cluster_sg"
    }
}

resource "aws_security_group" "node_group_sg" {
    name        = "node_group_sg"
    description = "security group for node group"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        description = "For DNS"
        from_port   = 53
        to_port     = 53
        protocol    = "tcp"
        self        = true
    }

    ingress {
        description = "For DNS"
        from_port   = 53
        to_port     = 53
        protocol    = "udp"
        self        = true
    }

    ingress {
        description = "For node group"
        from_port   = 1025
        to_port     = 65535
        protocol    = "tcp"
        self        = true
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "node_group_sg"
    }
}

resource "aws_security_group" "db_sg" {
    name        = "db_sg"
    description = "security group for database"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        description = "For database"
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        security_groups = [aws_security_group.node_group_sg.id]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "db_sg"
    }
}

resource "aws_security_group_rule" "cluster_sg_ingress_1" {
  security_group_id = aws_security_group.cluster_sg.id
  description = "For bastion"
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  source_security_group_id = aws_security_group.bastion_sg.id
}

resource "aws_security_group_rule" "cluster_sg_ingress_2" {
  security_group_id = aws_security_group.cluster_sg.id
  description = "For node group"
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  source_security_group_id = aws_security_group.node_group_sg.id
}

resource "aws_security_group_rule" "node_group_sg_ingress_1" {
  security_group_id = aws_security_group.node_group_sg.id
  description = "For clsuter"
  type        = "ingress"
  from_port   = 8443
  to_port     = 8443
  protocol    = "tcp"
  source_security_group_id = aws_security_group.cluster_sg.id
}

resource "aws_security_group_rule" "node_group_sg_ingress_2" {
  security_group_id = aws_security_group.node_group_sg.id
  description = "For clsuter"
  type        = "ingress"
  from_port   = 9443
  to_port     = 9443
  protocol    = "tcp"
  source_security_group_id = aws_security_group.cluster_sg.id
}

resource "aws_security_group_rule" "node_group_sg_ingress_3" {
  security_group_id = aws_security_group.node_group_sg.id
  description = "For clsuter"
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  source_security_group_id = aws_security_group.cluster_sg.id
}

resource "aws_security_group_rule" "node_group_sg_ingress_4" {
  security_group_id = aws_security_group.node_group_sg.id
  description = "For clsuter"
  type        = "ingress"
  from_port   = 10250
  to_port     = 10250
  protocol    = "tcp"
  source_security_group_id = aws_security_group.cluster_sg.id
}