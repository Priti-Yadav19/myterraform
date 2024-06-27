# RDS Resources
resource "aws_db_subnet_group" "mariadb-subnets" {
  name       = "mariadb-subnets"
  subnet_ids = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]

  tags = {
    Name = "mariadb-subnet"
  }
}

# RDS parameters
resource "aws_db_parameter_group" "mariadb-parameter" {
  name   = "mariadb-parameter"
  family = "maria10.11"
}

# RDS Instance properties:
resource "aws_db_instance" "maria_db" {
  allocated_storage    = 20
  db_name              = "mydb"
  engine               = "mariadb"
  engine_version       = "10.11.0"
  instance_class       = "db.t2.micro"
  identifier = "mariadb"
  username             = "root"
  password             = "admin123"
  parameter_group_name = "aws_db_parameter_group.mariadb-parameter.name"
  db_subnet_group_name = "aws_db_subnet_group.mariadb-subnets.name"
  multi_az = "false"
  vpc_security_group_ids = [aws_security_group.maria_sg.id]
  storage_type = "gp2"
  backup_retention_period = 30
  availability_zone = "aws_db_subnet_group.mariadb-subnets.id"
  skip_final_snapshot = true
}