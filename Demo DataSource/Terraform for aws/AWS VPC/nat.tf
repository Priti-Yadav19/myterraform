# Define external IP
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

# Define Route Table
resource "aws_route_table" "my_rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.mynatgw.id
  }

  tags = {
    Name = "my_rt"
  }
}

# Route Table Associations
resource "aws_route_table_association" "rta4" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.my_rt.id
}

resource "aws_route_table_association" "rta5" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.my_rt.id
}

resource "aws_route_table_association" "rta6" {
  subnet_id      = aws_subnet.private_subnet3.id
  route_table_id = aws_route_table.my_rt.id
}
