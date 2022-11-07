#set( $now =  $util.time.nowISO8601())
#set($ctx.args.input.created_at = $now)
#set($ctx.args.input.updated_at = $now)

{
  "version": "2017-02-28",
  "operation": "PutItem",
  "key": {
    "id": $util.dynamodb.toDynamoDBJson($util.autoId()),
  },
  "attributeValues": $util.dynamodb.toMapValuesJson($ctx.args.input),
  "condition": {
    "expression": "attribute_not_exists(#id)",
    "expressionNames": {
      "#id": "id",
    },
  },
}
