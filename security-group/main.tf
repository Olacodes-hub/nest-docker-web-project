# create security group for the ec2 instance connect endpoint
resource "aws_security_group" "eice_security_group" {
  name        = "ec2-endpoint-connect-sg"
  description = "enable outbound traffic on port 22 from the vpc cidr"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  tags = {
    Name = "ec2-endpoint-connect-sg"
  }
}


# create security group to ssh into ec2.. expose port 22

resource "aws_security_group" "ssh_sg" {
  name        = "ssh-sg"
  description = "Allow ssh connection"
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-sg"
  }
}

# create security group for application load balancer.. expose port 80, 443

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow port 80 and 443"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

# create security group for ec2 webserver, expose port 22, 80, and 443
resource "aws_security_group" "webserver_sg" {
  name        = "webserver-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTPS"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]

  }

  ingress {
    description     = "HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description     = "SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.ssh_sg.id]

  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "webserver-sg"
  }
}

# create security group for the database
resource "aws_security_group" "database_security_group" {
  name        = "database-sg"
  description = "allows acces to db-sg"
  vpc_id      = var.vpc_id

  ingress {
    description     = "mysql/aurora access"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "database-sg"
  }
}