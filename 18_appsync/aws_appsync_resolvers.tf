# Mutations

resource "aws_appsync_resolver" "create_user_mutation" {
  type              = "Mutation"
  api_id            = aws_appsync_graphql_api.demo.id
  field             = "createUser"
  request_template  = file("./templates/mutations/before.create_user.tpl")
  response_template = file("./templates/mutations/after.create_user.tpl")
  kind              = "PIPELINE"

  pipeline_config {
    functions = [
      aws_appsync_function.create_user.function_id,
      aws_appsync_function.increment_office_employee_counter.function_id,
    ]
  }
}

resource "aws_appsync_resolver" "delete_user_mutation" {
  type              = "Mutation"
  api_id            = aws_appsync_graphql_api.demo.id
  field             = "deleteUser"
  request_template  = file("./templates/mutations/before.delete_user.tpl")
  response_template = file("./templates/mutations/after.delete_user.tpl")
  kind              = "PIPELINE"

  pipeline_config {
    functions = [
      aws_appsync_function.delete_user.function_id,
      aws_appsync_function.decrement_office_employee_counter.function_id,
    ]
  }
}

resource "aws_appsync_resolver" "update_user_mutation" {
  type              = "Mutation"
  api_id            = aws_appsync_graphql_api.demo.id
  field             = "updateUser"
  data_source       = aws_appsync_datasource.users.name
  request_template  = file("./templates/mutations/request.update_user.tpl")
  response_template = file("./templates/mutations/response.update_user.tpl")
  kind              = "UNIT"
}

# Queries

resource "aws_appsync_resolver" "get_city_by_id_query" {
  type              = "Query"
  api_id            = aws_appsync_graphql_api.demo.id
  field             = "getCity"
  data_source       = aws_appsync_datasource.offices.name
  request_template  = file("./templates/queries/request.get_city_by_id.tpl")
  response_template = file("./templates/queries/response.get_city_by_id.tpl")
  kind              = "UNIT"
}

resource "aws_appsync_resolver" "get_office_by_id_query" {
  type              = "Query"
  api_id            = aws_appsync_graphql_api.demo.id
  field             = "getOffice"
  data_source       = aws_appsync_datasource.offices.name
  request_template  = file("./templates/queries/request.get_office_by_id.tpl")
  response_template = file("./templates/queries/response.get_office_by_id.tpl")
  kind              = "UNIT"
}

resource "aws_appsync_resolver" "get_user_by_id_query" {
  type              = "Query"
  api_id            = aws_appsync_graphql_api.demo.id
  field             = "getUser"
  data_source       = aws_appsync_datasource.users.name
  request_template  = file("./templates/queries/request.get_user_by_id.tpl")
  response_template = file("./templates/queries/response.get_user_by_id.tpl")
  kind              = "UNIT"
}

resource "aws_appsync_resolver" "list_cities_query" {
  type              = "Query"
  api_id            = aws_appsync_graphql_api.demo.id
  field             = "listCities"
  data_source       = aws_appsync_datasource.offices.name
  request_template  = file("./templates/queries/request.list_cities.tpl")
  response_template = file("./templates/queries/response.list_cities.tpl")
  kind              = "UNIT"
}

resource "aws_appsync_resolver" "list_offices_query" {
  type              = "Query"
  api_id            = aws_appsync_graphql_api.demo.id
  field             = "listOffices"
  data_source       = aws_appsync_datasource.offices.name
  request_template  = file("./templates/queries/request.list_offices.tpl")
  response_template = file("./templates/queries/response.list_offices.tpl")
  kind              = "UNIT"
}

resource "aws_appsync_resolver" "list_users_query" {
  type              = "Query"
  api_id            = aws_appsync_graphql_api.demo.id
  field             = "listUsers"
  data_source       = aws_appsync_datasource.users.name
  request_template  = file("./templates/queries/request.list_users.tpl")
  response_template = file("./templates/queries/response.list_users.tpl")
  kind              = "UNIT"
}
