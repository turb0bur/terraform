#if($ctx.error)
	$util.error($ctx.error.message, $ctx.error.type)
#end

#set($results=$utils.rds.toJsonObject($ctx.result)[0])

#if($results.isEmpty())
	null
#else
	$utils.toJson($results[0])
#end