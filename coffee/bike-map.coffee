class window.BikeMap
	
	constructor: (@mapId, @defaultCity) ->
	
		@map = null													# google map instance
		@showingDirections = no							# boolean - so I know how I should update the map
		@directionsService = null						# google map directions instance
		@directionsDisplay = null						# google map display instance
		@origin = null											# starting location - google map LatLng
		@destination = null									# ending location - google map LatLng
		#@defaultCity = [37.7750, -122.4183] # San Francisco
		@mapBounds = null										# bounding rectangle - google maps LatLngBounds
		@geocoder = null										# get lat,lng from address - google maps geocoder
		@clickCallback = null
		@currentLocationMarker = null
		@animatingLocations = []
		
		@initMap()
		
	getClickEvents: (callback) ->
		@clickCallback = callback
	
	mapClicked: (event) =>
		callback = @clickCallback
		myEvent =
			latLngArray: [event.latLng.lat(), event.latLng.lng()]
		
		if callback? then callback(myEvent)
	
	initMap: ->
		mapCenter = new google.maps.LatLng(@defaultCity[0], @defaultCity[1])
		
		mapOptions = {
			zoom: 15
			minZoom:10
			center: mapCenter
			mapTypeId: google.maps.MapTypeId.ROADMAP
			panControl: false
			zoomControl: false
			mapTypeControl: false
			scaleControl: false
			streetViewControl: false
			overviewMapControl: false
		}
		
		elMap = document.getElementById(@mapId)
		
		if elMap?
			@map = new google.maps.Map(elMap, mapOptions)
		else
			utils.log "Failed to find map element: " + @mapId
			return;
		
		google.maps.event.addListener(@map, 'click', @mapClicked)
		
		@directionsDisplay = new google.maps.DirectionsRenderer()
		@directionsDisplay.setMap(@map)
		
		@directionsService = new google.maps.DirectionsService()
		
		@geocoder = new google.maps.Geocoder()
		
		mileToDegree = 0.0166666667
		offset = 10 * mileToDegree
		lat = @defaultCity[0]
		lng = @defaultCity[1]
		sw = new google.maps.LatLng( (lat - offset), (lng - offset) )
		ne = new google.maps.LatLng( (lat +  offset), (lng + offset) )
		
		@mapBounds = new google.maps.LatLngBounds(sw,ne)
		
	updateOrigin: (latLngArray) ->
		
		# valid location?
		if not utils.isLatLng(latLngArray) then return
		
		oldOrigin = @origin
		@origin = new google.maps.LatLng(latLngArray[0], latLngArray[1])
		
		# no use wasting CPU cyclings updating the same location
		if oldOrigin and (oldOrigin.lat() is @origin.lat() and oldOrigin.lng() is @origin.lng) then return
		
		animation = 
			delay:10 # milliseconds
			steps:100 # steps between starting-ending locations
		
		createMarker = =>

			locationMarker = new google.maps.MarkerImage("images/location-marker.png")
			locationMarker.size = new google.maps.Size(32, 32 ) # sprite size (the entire sprite)
			locationMarker.origin = new google.maps.Point( 0, 0 ) # displacement on sprite
			locationMarker.anchor = new google.maps.Point( 8, 8 ) # anchor (move to center of marker)
			locationMarker.scaledSize = new google.maps.Size( 17, 17 ) # scaled size (required for Retina display icon)

			@map.panTo(@origin)
			
			@currentLocationMarker = new google.maps.Marker(
				map: @map
				position: @origin
				icon: locationMarker
				flat: true
				optimized: false
				title: "Current Location"
				visible: true
			)
			
		animateMarker = =>
			location = @animatingLocations.shift() # remove first location
			if utils.isLatLng(location)
				newPosition = new google.maps.LatLng(location[0], location[1])
				@currentLocationMarker.setPosition(newPosition)
			if @animatingLocations.length > 0 then setTimeout(animateMarker, animation.delay)
			
		updateMarker = =>
			steps = animation.steps
			latitude = @origin.lat()
			longitude = @origin.lng()
			deltaLat = (latitude - oldOrigin.lat()) / steps
			deltaLng = (longitude - oldOrigin.lng()) / steps
			
			# this array of locations will just keep getting longer if we receive a new location before the last one finished animating
			@animatingLocations.push( [latitude + i*deltaLat, longitude + i*deltaLng] ) for i in [0..steps]
			
			animateMarker()
			#@currentLocationMarker.setPosition(@origin)
		
		if @showingDirections
			# update current location on route?
			# or recalculate route with provided origin
			# @calcRoute()
		else
			if @currentLocationMarker then updateMarker() else createMarker()

	updateDestination: (latLngArray) ->
	
		if not utils.isLatLng(latLngArray) then return
			
		@destination = new google.maps.LatLng(latLngArray[0], latLngArray[1])
			
	getLatLng: (address, callback) ->

		geocodeOptions = 
			address: address
			bounds: @mapBounds
			
		geocodeCallback = (results, status) =>
			_results = []
			
			isNotDuplicate = (address) ->
				for existingResult in _results
					if address is existingResult.address then return false 
				return true

			addResult = (address, location) ->
				_results.push( {
					address: address
					location: [location.lat(), location.lng()]
				})
						
			if status is google.maps.GeocoderStatus.OK

				for result in results
					location = result.geometry.location
					address_components = result.address_components
					address = address_components[0]?.short_name + " " + address_components[1]?.short_name + ", " + address_components[3]?.short_name
					# only return results within our defined boundary and
					# don't add if they are the same address as we define it (e.g. 303 2nd St, N Tower, SF === 303 2nd St, S Tower, SF)
					if @mapBounds.contains(location) and isNotDuplicate(address) then addResult(address, location)

			callback(_results)
	
		@geocoder.geocode(geocodeOptions, geocodeCallback)
	
	calcRoute: (callback) ->
	
		if not @destination?
			utils.log "Enter a destination" 
			return
			
		if not @origin?
			utils.log "Enter a starting location"
			return
		
		routeCallback = (result, status) =>	
			_result = "FAILED"
			if status is google.maps.DirectionsStatus.OK
				_result = "SUCCESS"
				@showingDirections = true
				@directionsDisplay.setDirections(result)
			else
				utils.log "result = " + result + " status = " + status
			callback(_result)
		
		request = 
			origin: @origin
			destination: @destination
			travelMode: google.maps.TravelMode.BICYCLING
	
		@directionsService.route request, routeCallback