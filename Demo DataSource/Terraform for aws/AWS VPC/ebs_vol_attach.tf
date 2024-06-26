resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "MyFirstInstnace" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.levelup_key.key_name

  tags = {
    Name = "custom_instance"
  }

}

# EBS resource creation
resource "aws_ebs_volume" "my_ebs_vol" {
  availability_zone = "us-east-1a"
  size              = 40
  type              = "gp2"
  tags = {
    Name = "my_ebs_vol"
  }
}

# Attach EBS volume with ec2 instance
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.my_ebs_vol.id
  instance_id = aws_instance.MyFirstInstance.id
}
