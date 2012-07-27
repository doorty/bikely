## TODO: add watch position

class window.CurrentLocation

	constructor: ->
		
		@latLng = null
		@geolocation = navigator.geolocation
		@watchId = null
		
	getErrorMessage: (code) ->
		switch code
			when -1 then return "SUCCESS"
			when 0 then return "Sorry, there was an unknown error." # UNKNOWN_ERROR
			when 1 then return "Hey, we need permission to give you directions." # PERMISSION_DENIED
			when 2 then return "Sorry, your position is unavailable." # POSITION_UNAVAILABLE
			when 3 then return "Sorry, we couldn't find your location in time." # TIMEOUT
			when 4 then return "Sorry, this device doesn't support location." # GEOLOCATION UNSUPPORTED
			else return code
		
	updatePosition: (latLngArray) ->
		@latLng = if latLngArray and latLngArray.length is 2 then latLngArray else null
		
	stopWatching: ->
		@geolocation.clearWatch(@watchId) if @watchId
		
	watchPosition: (callback) ->
		gotPosition = (location) =>
	
			lat = location.coords.latitude;
			lng = location.coords.longitude;
			latLngArray = [lat, lng]
			
			@updatePosition(latLngArray)
			if callback? then callback(latLngArray, @getErrorMessage(-1))
			
		unknownPosition = (positionError) =>
			callback(null, @getErrorMessage(positionError.code))

		if @geolocation
			@watchId = @geolocation.watchPosition(gotPosition, unknownPosition, {enableHighAccuracy:true, maximumAge:30000, timeout:27000})
		else
			callback(null, @getErrorMessage(4))
			
	getPosition: (callback) ->
	
		gotPosition = (location) =>
	
			lat = location.coords.latitude;
			lng = location.coords.longitude;
			latLngArray = [lat, lng]
			
			@updatePosition(latLngArray)
			if callback? then callback(latLngArray, @getErrorMessage(-1))
			
		unknownPosition = (positionError) =>
			callback(null, @getErrorMessage(positionError.code))

		if @geolocation
			@geolocation.getCurrentPosition(gotPosition, unknownPosition)
		else
			callback(null, @getErrorMessage(4))