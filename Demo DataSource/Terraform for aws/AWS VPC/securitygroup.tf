# Defining security group for myVPC
resource "aws_security_group" "my_sg" {
  name        = "my_sg"
  description = "Allow SSH traffic"
  vpc_id      = aws_vpc.myvpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol = "-1"
    to_port     = 0
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol = "tcp"
    to_port     = 22
  }

  tags = {
    Name = "my_sg"
  }
}
