resource "aws_appsync_function" "create_user" {
  api_id      = aws_appsync_graphql_api.demo.id
  data_source = aws_appsync_datasource.users.name
  name        = "CreateUser"

  request_mapping_template  = file("${path.module}/templates/functions/request.create_user.tpl")
  response_mapping_template = file("${path.module}/templates/functions/response.create_user.tpl")
}

resource "aws_appsync_function" "increment_office_employee_counter" {
  api_id      = aws_appsync_graphql_api.demo.id
  data_source = aws_appsync_datasource.offices.name
  name        = "IncrementOfficeEmployeeCounter"

  request_mapping_template  = file("${path.module}/templates/functions/request.increment_office_employee_counter.tpl")
  response_mapping_template = file("${path.module}/templates/functions/response.increment_office_employee_counter.tpl")
}
resource "aws_appsync_function" "delete_user" {
  api_id      = aws_appsync_graphql_api.demo.id
  data_source = aws_appsync_datasource.users.name
  name        = "DeleteUser"

  request_mapping_template  = file("${path.module}/templates/functions/request.delete_user.tpl")
  response_mapping_template = file("${path.module}/templates/functions/response.delete_user.tpl")
}

resource "aws_appsync_function" "decrement_office_employee_counter" {
  api_id      = aws_appsync_graphql_api.demo.id
  data_source = aws_appsync_datasource.offices.name
  name        = "DecrementOfficeEmployeeCounter"

  request_mapping_template  = file("${path.module}/templates/functions/request.decrement_office_employee_counter.tpl")
  response_mapping_template = file("${path.module}/templates/functions/response.decrement_office_employee_counter.tpl")
}

