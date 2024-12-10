resource "aws_iam_role" "redshift_role" {
  name = format(local.resource_name, "redshift-iam-role")
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "redshift.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = format(local.resource_name, "redshift-iam-role")
  }
}

resource "aws_iam_policy_attachment" "redshift_access_s3" {
  name       = format(local.resource_name, "redshift-access-s3")
  roles      = [aws_iam_role.redshift_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role" "bastion_ec2" {
  name = format(local.resource_name, "bastion-ec2-role")
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = format(local.resource_name, "bastion-profile")
  role = aws_iam_role.bastion_ec2.name
}

resource "aws_iam_role_policy_attachment" "bastion_ssm_role_policy" {
  role       = aws_iam_role.bastion_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "ec2_create_route" {
  name = format(local.resource_name, "ec2-create-route-policy")
  role = aws_iam_role.bastion_ec2.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:StartSession",
          "ssm:DescribeSessions",
          "ssm:GetSession",
          "ssm:TerminateSession"
        ],
        "Resource" : "*"
      }
    ]
  })
}
