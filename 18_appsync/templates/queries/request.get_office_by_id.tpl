{
    "version": "2018-05-29",
    "statements": [
        $util.toJson("select * from offices WHERE id = '$ctx.args.id'")
    ]
}