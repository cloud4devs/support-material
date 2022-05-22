resource "aws_db_instance" "default" {
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "13.4"
  instance_class         = "db.t3.micro"
  db_name                = "observability"
  identifier             = "observability"
  username               = "observability"
  password               = "m4rM5etY8zT9AcDuq24m"
  skip_final_snapshot    = true
  storage_type           = "gp2"
  multi_az               = false
  vpc_security_group_ids = [aws_security_group.db_security_group.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  publicly_accessible    = false
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "observability-db-subnet-group"
  subnet_ids = [data.aws_subnets.default.ids[0], data.aws_subnets.default.ids[1]]
}

resource "aws_security_group" "db_security_group" {
  name        = "observability-db-security-group"
  description = "Observability db Security Group."
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}