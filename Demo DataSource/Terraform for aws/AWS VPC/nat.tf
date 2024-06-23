#define external ip
resource "aws_eip" "my_nat_eip" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "mynatgw" {
  allocation_id = aws_eip.my_nat_eip
  subnet_id     = aws_subnet.public_subnet1.id

  tags = {
    Name = "mynatgw"
  }
}

resource "aws_route_table" "my_rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "10.0.0.0/0"
    gateway_id = aws_internet_gateway.mynatgw.id
  }
 tags = {
    Name = "my_rt"
  }
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.my_rt
}

resource "aws_route_table_association" "rta3" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.my_rt
}

resource "aws_route_table_association" "rta4" {
  subnet_id      = aws_subnet.private_subnet3.id
  route_table_id = aws_route_table.my_rt
}