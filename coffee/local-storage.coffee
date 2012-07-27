class window.LocalStorage
	constructor: (callback) ->
		name = "name"
		record = "record"
		callback ?= (info) -> utils.log "storage ready: " + info
		@storage = Lawnchair({}, callback)
		
	# save an object
	save: (key, value, callback) ->
# 		callback ?= (obj) -> utils.log obj
# 		saveObj = 
# 			"key": key
# 			"value": value
# 		@storage.save(saveObj)
		@saveCookie(key, value, callback)
		
	saveCookie: (key, value, callback) ->
		saved = $.cookie(key, JSON.stringify(value))
		alert "saved: " + saved
# 		expdate = new Date();
# 		expdate.setDate(expdate.getDate() + daysTillExpired)
# 		cookieValue = escape(value) + if daysTillExpired is null then "" else "; expires="+expdate.toUTCString()
# 		document.cookie=key + "=" + cookieValue;
		
		# retrieve obj (or array of objs) and apply callback to each
	get: (key, callback) ->
		@getCookie(key, callback)
# 		cb = (obj) -> callback if obj && obj.value then obj.value else null
# 		@storage.get(key, cb)

	getCookie: (key, callback) ->
		resultObj = JSON.parse($.cookie(key))
		alert "get: " + resultObj
		callback(resultObj)
# 		cookies=document.cookie.split(";")
# 		
# 		for c in cookies
# 			x = c.substr(0,c.indexOf("="));
# 			y = c.substr(c.indexOf("=")+1);
# 		
# 			x = x.replace(/^\s+|\s+$/g,"");
# 			if x is key then return unescape(y)
		
		# remove a doc or collection of em
	remove: (key, callback) ->
		$.cookie(key, null);
# 		callback ?= (obj) -> utils.log obj
# 		@storage.remove(key, callback)

# 
# 	# batch save array of objs
# 	saveMultiple: (keyValueArray, callback) ->
# 		callback ?= (obj) -> utils.log obj
# 		@storage.batch(keyValueArray, callback)
# 	
# 
# 		
# 	getEverything: (callback) ->
# 		callback ?= (obj) -> utils.log obj
# 		@storage.all(callback)
# 	
# 	# check if exists in the collection passing boolean to callback
# 	exists: (key, callback) ->
# 		callback ?= -> (exists) -> utils.log "Existence is " + exists
# 		@storage.exists(key, callback)
# 			
# 	# remove a doc or collection of em
# 	removeMultiple: (array, callback) ->
# 		callback ?= (obj) -> utils.log obj
# 		@storage.remove(array, callback)
# 		
# 	# destroy everything
# 	removeEverything: (callback) ->
# 		callback ?= (obj) -> utils.log obj
# 		@storage.nuke(callback)