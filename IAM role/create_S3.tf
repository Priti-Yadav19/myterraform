# Creating S3 bucket
resource "aws_s3_bucket" "rudra12345" {
  bucket = "rudra12345"
  acl = "private"

  tags = {
    Name        = "rudra12345"
  }
}