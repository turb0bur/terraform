{
    "version": "2018-05-29",
    "statements": [
        $util.toJson("select * from cities WHERE id = '$ctx.args.id'")
    ]
}