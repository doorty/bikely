class window.LocalStorage
	constructor: (callback) ->
		name = "name"
		record = "record"
		callback ?= (info) -> utils.log "storage ready: " + info
		@storage = Lawnchair({}, callback)
		
	# save an object
	save: (key, value, callback) ->
		callback ?= (obj) -> utils.log obj
		saveObj = 
			"key": key
			"value": value
		@storage.save(saveObj)
		
	# batch save array of objs
	saveMultiple: (keyValueArray, callback) ->
		callback ?= (obj) -> utils.log obj
		@storage.batch(keyValueArray, callback)
	
	# retrieve obj (or array of objs) and apply callback to each
	get: (key, callback) ->
		#callback ?= (obj) -> utils.log obj
		cb = (obj) -> callback if obj && obj.value then obj.value else null
		@storage.get(key, cb)
		
	getEverything: (callback) ->
		callback ?= (obj) -> utils.log obj
		@storage.all(callback)
	
	# check if exists in the collection passing boolean to callback
	exists: (key, callback) ->
		callback ?= -> (exists) -> utils.log "Existence is " + exists
		@storage.exists(key, callback)
		
	# remove a doc or collection of em
	remove: (key, callback) ->
		callback ?= (obj) -> utils.log obj
		@storage.remove(key, callback)
		
	# remove a doc or collection of em
	removeMultiple: (array, callback) ->
		callback ?= (obj) -> utils.log obj
		@storage.remove(array, callback)
		
	# destroy everything
	removeEverything: (callback) ->
		callback ?= (obj) -> utils.log obj
		@storage.nuke(callback)