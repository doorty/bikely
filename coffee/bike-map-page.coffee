class window.BikeMapPage

	constructor: ->

		@destinationInput = "#destination-input"
		@destinationInputClear = "#destination-input-clear"
		@destinationList = "#destination-list"
		@destinationListWrapper = "#destination-list-wrapper"
		@mapCanvas = "map-canvas"
		@defaultCity = [37.7750, -122.4183] # San Francisco
		@destinationLiHeight = 35 # pixels
		@localStorage = null
		@location =
			currentLocation: @defaultCity
			origin: null
			destination: null
		
		@setupMap()
		@setupLocalStorage()
		@setupInput()
		@hideAddressBar()
		
	hideAddressBar: ->
		window.scrollTo(0, 0)
		#setTimeout( (-> window.scrollTo(0, 1) ), 1000);
		
	updateMapOrigin: (latLngArray) ->
		@location.origin = latLngArray
		@bikemap.updateOrigin(latLngArray)

	updateMapDestinationAndDirections: (destination) ->
		$(@destinationInput).val(destination.address)
		$(@destinationInputClear).show()
		@bikemap.updateDestination(destination.location)
		@bikemap.calcRoute(@directionsCallback)
		$(@destinationList).empty()
		@location.destination = destination
		@localStorage.saveDirections(@location.origin, @location.destination, null)
		#TODO: remove callback

	gotPosition: (latLngArray, status) =>
		
		if latLngArray?
			utils.log "current position is " + latLngArray[0] + ", " + latLngArray[1]
			@location.currentLocation = latLngArray
			@updateMapOrigin(latLngArray)
			@localStorage.saveCurrentLocation(latLngArray)
		else
			# prompt the user to enter current location?
			utils.log  "Where are you? " + status

	directionsCallback: (status) =>
		utils.log status
	
	hideDestinationOptions: ->
		$(@destinationListWrapper).removeClass("show")
	
	showDestinationOptions: ->
		$(@destinationListWrapper).addClass("show")
	
	clearDestinationOptions: ->
		$(@destinationListWrapper).empty()
	
	updateDestinationOptions: (destinations) ->
		
		destinationList = $(@destinationList)
		destinationListWrapperTop = destinations.length * @destinationLiHeight + @destinationLiHeight
		listElementsFrag = $(document.createDocumentFragment())
		destinationListElements = ""
		
		addDestination = (destination) =>
			address = if destination.address.length > 32 then (destination.address.slice(0,32) + "...") else destination.address
			event = if utils.isTouchDevice() then "tap" else "click"
			li = $("<li/>").one(event, ( => 
				@updateMapDestinationAndDirections(destination)
				@hideDestinationOptions()
			))
			address = $("<span/>").addClass("address").attr("data-location", destination.location).text(address)
			li.append(address)
			listElementsFrag.append(li) 
		
		addDestination destination for destination in destinations
		
		destinationList.empty().append(listElementsFrag)
	
	destinationEntered: (address) ->
		destinationGeocodeCallback = (destinations) =>
			numOfDestinations = destinations.length
			# if input is focused then they haven't hit "Search", so only show options (not map directions)
			destinationIsFocused = $(@destinationInput).is(":focus")
			switch numOfDestinations
				when 0
					if destinationIsFocused
						@updateDestinationOptions(destinations)
						@hideDestinationOptions()
					else
						alert "Sorry, we couldn't find that in your area"
				when 1 
					if destinationIsFocused
						@updateDestinationOptions(destinations)
						@showDestinationOptions()
					else
						@updateMapDestinationAndDirections(destinations[0])
				else
					@updateDestinationOptions(destinations)
					@showDestinationOptions()
			
		@bikemap.getLatLng(address, destinationGeocodeCallback)

	mapClicked: (event) =>
		# utils.log "I clicked here: " + if event.latLngArray? then event.latLngArray
		@hideDestinationOptions()
	
	setupLocalStorage: ->
		@localStorage = new BikeLocalStorage()

		currentLocationCallback = (location) =>
			#alert "currentLocationCallback: " + location
			if location?
				@location.currentLocation = location
				@updateMapOrigin(location)

		directionsCallback = (obj) =>
			#alert "directionsCallback: " + JSON.stringify(obj)
			if obj?
				if obj.origin?
					@location.origin = if @location.currentLocation? then @location.currentLocation else obj.origin
					@updateMapOrigin(obj.origin)
				if obj.destination?
					@location.destination = obj.destination
					@updateMapDestinationAndDirections(obj.destination)
		
		@localStorage.getCurrentLocation(currentLocationCallback)
		@localStorage.getDirections(directionsCallback)
	
	setupMap: ->
		@bikemap = new BikeMap(@mapCanvas, @location.currentLocation)
		@bikemap.getClickEvents(@mapClicked)
		
		@location = new CurrentLocation()
		@location.watchPosition(@gotPosition)

	setupInput: ->
		
		input = $(@destinationInput)
		clearButton = $(@destinationInputClear)
		event = if utils.isTouchDevice() then "tap" else "mousedown"

		focus = (event) =>
			if $(@destinationList).children().length > 0 then @showDestinationOptions()

		keypress = (event) =>
			inputText = input.val()
			if event.which is 13 # 'Search' button pressed on keyboard
				input.blur()
				@destinationEntered(inputText)
			else
				if inputText.length > 0
					@destinationEntered(inputText) # live search
					clearButton.show()
				else
					@updateDestinationOptions(null)
					@hideDestinationOptions()
					clearButton.hide()

		clearInput = (event) ->
			input.val("")
			clearButton.hide()
			event.preventDefault() if event
		
		input.on("keyup", keypress).on("focus", focus)
		clearButton.on("mousedown",  clearInput)