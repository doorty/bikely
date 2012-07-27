class window.BikeLocalStorage extends window.LocalStorage

	saveDirections: (origin, destination, callback) ->
		key = "directions"
		value =
			"origin": origin
			"destination": destination
		@save key, value, callback
		#@storage.addToDirectionsHistory(obj, null)
		
	getDirections: (callback) ->
		key = "directions"
		@get(key, callback)

# 	addToDirectionsHistory:(directionsObj, callback) ->
# 		key = "directionsHistory"
# 		
# 		historyExistsCallback = (hasHistory) ->
# 			if hasHistory
# 				@storage.get(key, gotHistoryCallback)
# 			else
# 				saveHistory([directionsObj])
# 				
# 		gotHistoryCallback = (historyObj) ->
# 			historyArray = historyObj.options
# 			# TODO: only add to array if less than 10 and not already added
# 			historyArray.push(directionsObj)
# 			saveHistory(historyArray)
# 		
# 		saveHistory = (historyArray) ->
# 			obj =
# 				key: key
# 				options: historyArray
# 			@storage.save obj, callback
# 					
# 		@storage.exists(key, historyExistsCallback)
# 		
# 	getDirectionsHistory: (callback) ->
# 		key = "directionsHistory"
# 		@storage.get(key, callback)
# 		
# 	addToCurrentLocationHistory: (locationObj, callback) ->
# 		key = "currentLocations"
# 		
# 		gotHistoryCallback = (historyObj) ->
# 			historyArray = historyObj.options
# 			historyArray.push(directionsObj)
# 			saveHistory(historyArray)
# 		
# 		saveHistory = (historyArray) ->
# 			obj =
# 				key: key
# 				options: historyArray
# 			@storage.save obj, callback
# 		
# 		
# 		historyExistsCallback = (hasHistory) ->
# 			if hasHistory
# 				@storage.get(key, gotHistoryCallback)
# 			else
# 				saveHistory([locationObj])			
# 		
# 		@storage.exists(key, historyExistsCallback)
# 		
# 	getCurrentLocationHistory: (callback) ->
# 		key = "currentLocations"
# 		@storage.get(key, callback)	
