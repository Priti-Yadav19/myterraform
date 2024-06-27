# Defining IAM users and Group
resource "aws_iam_user" "Anil" {
  name = "Admin"
}

resource "aws_iam_user" "Niti" {
  name = "Dev"
}

# IAM Group
resource "aws_iam_group" "Developers" {
  name = "Developers"
}

# Add user to group
resource "aws_iam_group_membership" "team" {
  name = "tf-testing-group-membership"

  users = [
    aws_iam_user.Anil.name,
    aws_iam_user.Niti.name,
  ]

  group = aws_iam_group.Developers.name
}

# Attaching policy
resource "aws_iam_policy_attachment" "policy1" {
  name       = "policy1"
  groups     = [aws_iam_group.Developers.name]
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

