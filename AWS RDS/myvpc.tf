# VPC Configuration

resource "aws_vpc" "myvpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "myvpc"
  }
}

# Defining Public Subnets in Custom VPC

resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2a"

  tags = {
    Name = "public_subnet1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2b"

  tags = {
    Name = "public_subnet2"
  }
}

resource "aws_subnet" "public_subnet3" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2c"

  tags = {
    Name = "public_subnet3"
  }
}

# Defining Private Subnets in Custom VPC

resource "aws_subnet" "private_subnet1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-2a"

  tags = {
    Name = "private_subnet1"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-2b"

  tags = {
    Name = "private_subnet2"
  }
}

resource "aws_subnet" "private_subnet3" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-2c"

  tags = {
    Name = "private_subnet3"
  }
}

# Defining Custom Internet Gateway

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "my_igw"
  }
}

# Define External IP for NAT Gateway

resource "aws_eip" "my_nat_eip" {
  domain = "vpc"
}

# Define NAT Gateway

resource "aws_nat_gateway" "mynatgw" {
  allocation_id = aws_eip.my_nat_eip.id
  subnet_id     = aws_subnet.public_subnet1.id

  tags = {
    Name = "mynatgw"
  }
}

# Define Route Table for Public Subnets

resource "aws_route_table" "publicRT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "publicRT"
  }
}

# Define Route Table for Private Subnets

resource "aws_route_table" "privateRT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.mynatgw.id
  }

  tags = {
    Name = "privateRT"
  }
}

# Route Table Associations for Public Subnets

resource "aws_route_table_association" "rta_public_1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.publicRT.id
}

resource "aws_route_table_association" "rta_public_2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.publicRT.id
}

resource "aws_route_table_association" "rta_public_3" {
  subnet_id      = aws_subnet.public_subnet3.id
  route_table_id = aws_route_table.publicRT.id
}

# Route Table Associations for Private Subnets

resource "aws_route_table_association" "rta_private_1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.privateRT.id
}

resource "aws_route_table_association" "rta_private_2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.privateRT.id
}

resource "aws_route_table_association" "rta_private_3" {
  subnet_id      = aws_subnet.private_subnet3.id
  route_table_id = aws_route_table.privateRT.id
}
