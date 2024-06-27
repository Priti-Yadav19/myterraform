# Creating IAM role to access S3 Bucket
resource "aws_iam_role" "S3_access" {
  name = "S3_access"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Policy to attach S3 role
resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.S3_access.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect   = "Allow"
        Resource = [
            "arn:aws:s3:::rudra12345",
            "arn:aws:s3:::rudra12345/*"
        ]
      },
    ]
  })
}

# Instance profile for the IAM role
resource "aws_iam_instance_profile" "II" {
  name = "II"
  role = aws_iam_role.S3_access.name
}
