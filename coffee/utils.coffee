window.utils =

	isUIWebView : /(iPhone|iPod|iPad).*AppleWebKit(?!.*Safari)/i.test(navigator.userAgent)
	isMobileSafariOrUIWebView : /(iPhone|iPod|iPad).*AppleWebKit/i.test(navigator.userAgent)
	
	isLatLng: (latLngArray) ->
		if (not latLngArray?) or (latLngArray.length is not 2) or isNaN(latLngArray[0]) or isNaN(latLngArray[1]) then false else true
		
	isTouchDevice: ->
		isTouch = !!('ontouchstart' in window)
		@isTouchDevice = -> isTouch  ## redefine function so it doesn't need to compute again
		isTouch ## return isTouch

	log: (msg)->
		if window.console and window.console.log then window.console.log msg

		