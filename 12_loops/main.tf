provider "aws" {}

variable "users" {
  description = "List of user names"
  default     = ["Volodymyr", "Yurii", "Liubomyr", "Oleksandr", "Andrii"]
}

resource "aws_iam_user" "users" {
  count = length(var.users)
  name  = element(var.users, count.index)
}

output "created_users_id" {
  value = aws_iam_user.users[*].id
}

output "created_users_custom_list" {
  value = [
  for user in aws_iam_user.users :
  "User ${user.name} has ARN ${user.arn}"
  ]
}

output "created_users_custom_map" {
  value = {
  for user in aws_iam_user.users :
  user.unique_id => user.id if length(user.name) >= 9
  }
}