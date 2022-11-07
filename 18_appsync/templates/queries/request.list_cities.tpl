#set($limit = $util.defaultIfNull($ctx.args.limit, 5))

{
    "version": "2018-05-29",
    "statements": [
        $util.toJson("select * from cities LIMIT $limit")
    ]
}