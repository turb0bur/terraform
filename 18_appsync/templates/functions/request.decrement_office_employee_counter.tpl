#set($office_id =  $ctx.prev.result.office_id)
#set($office_id =  $ctx.prev.result.office_id)

{
    "version": "2018-05-29",
    "statements": [
        $util.toJson("update offices set employees_amount = employees_amount - 1 WHERE id = '$office_id'"),
        $util.toJson("select * from offices WHERE id='$office_id'")
    ]
}