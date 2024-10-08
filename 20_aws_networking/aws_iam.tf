resource "aws_iam_role" "ec2_role" {
  name = format(local.resource_name, "ec2-role")
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

resource "aws_iam_role_policy_attachment" "ssm_role_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = format(local.resource_name, "ssm-instance-profile")
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role_policy" "ec2_create_route" {
  name = format(local.resource_name, "ec2-create-route-policy")
  role = aws_iam_role.ec2_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "ec2:CreateRoute",
        Resource = format("arn:aws:ec2:%s:%s:route-table/*", var.region, data.aws_caller_identity.current.account_id)
      }
    ]
  })
}
