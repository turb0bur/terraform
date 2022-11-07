resource "aws_dynamodb_table" "users" {
  name           = "Users"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  read_capacity  = 0
  write_capacity = 0

  attribute {
    name = "id"
    type = "S"
  }
}
