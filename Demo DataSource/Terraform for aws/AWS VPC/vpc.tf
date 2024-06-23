# Custom vpc in aws
resource "aws_vpc" "myvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = "True"
  enable_dns_support = "True"
  
  tags = {
    Name = "myvpc"
  }
}

# Defining subnets in custom vpc 
resource "aws_subnet" "public_subnet1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "True"
  availability_zone = "us-east-2a"

  tags = {
    Name = "public_subnet1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "True"
  availability_zone = "us-east-2b"

  tags = {
    Name = "public_subnet2"
  }
}

resource "aws_subnet" "public_subnet3" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = "True"
  availability_zone = "us-east-2c"

  tags = {
    Name = "public_subnet3"
  }
}

# Defining subnets in custom vpc 
resource "aws_subnet" "private_subnet1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.4.0/24"
  map_public_ip_on_launch = "False"
  availability_zone = "us-east-2a"

  tags = {
    Name = "private_subnet1"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.5.0/24"
  map_public_ip_on_launch = "False"
  availability_zone = "us-east-2b"

  tags = {
    Name = "private_subnet2"
  }
}

resource "aws_subnet" "private_subnet3" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.6.0/24"
  map_public_ip_on_launch = "False"
  availability_zone = "us-east-2c"

  tags = {
    Name = "private_subnet3"
  }
}

# Defining custom gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "my_igw"
  }
}

# Route table 
resource "aws_route_table" "publicRT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "10.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
 tags = {
    Name = "publicRT"
  }
}
 
# route table association
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.publicRT
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.publicRT
}

resource "aws_route_table_association" "rta3" {
  subnet_id      = aws_subnet.public_subnet3.id
  route_table_id = aws_route_table.publicRT
}