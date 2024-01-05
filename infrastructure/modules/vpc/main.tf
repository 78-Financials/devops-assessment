data "aws_availability_zones" "available" {}

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "random_shuffle" "public_az" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

resource "aws_vpc" "payaza_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    "Name" = "payaza-vpc"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_internet_gateway" "payaza_vpc_igw" {
  vpc_id = aws_vpc.payaza_vpc.id
  tags = {
    "Name" = "payaza-igw"
  }
}

resource "aws_subnet" "payaza_public_subnet" {
  count                   = var.public_sn_count
  cidr_block              = var.public_cidrs[count.index]
  vpc_id                  = aws_vpc.payaza_vpc.id
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.public_az.result[count.index]
  tags = {
    "Name" = "payaza-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "payaza_private_subnet" {
  count                   = var.private_sn_count
  cidr_block              = var.private_cidrs[count.index]
  vpc_id                  = aws_vpc.payaza_vpc.id
  map_public_ip_on_launch = false
  availability_zone       = random_shuffle.public_az.result[count.index]
  tags = {
    "Name" = "payaza-private-subnet-${count.index + 1}"
  }
}


resource "aws_route_table" "payaza_public_route" {
  vpc_id = aws_vpc.payaza_vpc.id
  tags = {
    "Name" = "payaza-${terraform.workspace}-public-route"
  }
}

resource "aws_route" "payaza_default_route" {
  route_table_id         = aws_route_table.payaza_public_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.payaza_vpc_igw.id
}

resource "aws_default_route_table" "payaza_private_route" {
  default_route_table_id = aws_route_table.payaza_public_route.id
  tags = {
    "Name" = "payaza-public-route"
  }
}

resource "aws_route_table_association" "payaza_public_asso" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.payaza_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.payaza_public_route.id
}

resource "aws_security_group" "simple-api-sg" {
  name        = "simple-api-sg"
  description = "Allow HTTP access from loadbalancer"
  vpc_id      = aws_vpc.payaza_vpc.id

  ingress {
    description     = "TLS from VPC"
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

resource "aws_security_group" "lb_sg" {
  name        = "lb_sg"
  description = "Allow HTTP access into Loadbalancer"
  vpc_id      = aws_vpc.payaza_vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "loadbalancer security group"
  }
}


