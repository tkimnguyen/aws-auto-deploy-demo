# Create IAM role that can access policies
resource "aws_iam_role" "read_ec2_tags" {
  name = "read_ec2_tags"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Create an IAM policy allowing EC2 instances to see tags
resource "aws_iam_policy" "ec2_tags_policy" {
  name = "ec2_tags_policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeTags"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# Attach the Role and Policy into a single entity
resource "aws_iam_policy_attachment" "ec2-tags-attach" {
  name       = "ec2-tags-attach"
  roles      = ["${aws_iam_role.read_ec2_tags.name}"]
  policy_arn = aws_iam_policy.ec2_tags_policy.arn
}

# Allow the roles to be assigned to an EC2 instance
resource "aws_iam_instance_profile" "read_ec2_tags" {
  name = "read_ec2_tags"
  role = aws_iam_role.read_ec2_tags.name
}

