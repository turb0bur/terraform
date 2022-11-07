resource "aws_iam_role" "appsync_role" {
  name = "AWSAppSyncDemoRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "appsync.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

  managed_policy_arns = [
    aws_iam_policy.dynamodb_allow_actions.arn,
    aws_iam_policy.rds_allow_actions.arn,
    aws_iam_policy.secrets_manager_actions.arn,
    "arn:aws:iam::aws:policy/service-role/AWSAppSyncPushToCloudWatchLogs"
  ]
}

resource "aws_iam_policy" "dynamodb_allow_actions" {
  name = "AWSDynamoDBRole"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:*"
      ],
      "Effect": "Allow",
      "Resource": [ "*" ]
    }
  ]
}
EOF
}

resource "aws_iam_policy" "rds_allow_actions" {
  name = "AWSRDSRole"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
                "rds:*",
                "rds-data:ExecuteStatement",
                "rds-data:DeleteItems",
                "rds-data:ExecuteSql",
                "rds-data:GetItems",
                "rds-data:InsertItems",
                "rds-data:UpdateItems"
            ],
      "Effect": "Allow",
      "Resource": [ "*" ]
    }
  ]
}
EOF
}

resource "aws_iam_policy" "secrets_manager_actions" {
  name = "AWSSecretsManagerRole"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "secretsmanager:GetSecretValue"
      ],
      "Effect": "Allow",
      "Resource": [ "*" ]
    }
  ]
}
EOF
}


resource "aws_iam_role" "cloud_watch_logs" {
  name = "CloudWatchLogsRole"

  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "appsync.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "example" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppSyncPushToCloudWatchLogs"
  role       = aws_iam_role.cloud_watch_logs.name
}
