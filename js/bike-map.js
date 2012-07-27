// Generated by CoffeeScript 1.3.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.BikeMap = (function() {

    function BikeMap(mapId, defaultCity) {
      this.mapId = mapId;
      this.defaultCity = defaultCity;
      this.mapClicked = __bind(this.mapClicked, this);

      this.map = null;
      this.showingDirections = false;
      this.directionsService = null;
      this.directionsDisplay = null;
      this.origin = null;
      this.destination = null;
      this.mapBounds = null;
      this.geocoder = null;
      this.clickCallback = null;
      this.currentLocationMarker = null;
      this.animatingLocations = [];
      this.initMap();
    }

    BikeMap.prototype.getClickEvents = function(callback) {
      return this.clickCallback = callback;
    };

    BikeMap.prototype.mapClicked = function(event) {
      var callback, myEvent;
      callback = this.clickCallback;
      myEvent = {
        latLngArray: [event.latLng.lat(), event.latLng.lng()]
      };
      if (callback != null) {
        return callback(myEvent);
      }
    };

    BikeMap.prototype.initMap = function() {
      var elMap, lat, lng, mapCenter, mapOptions, mileToDegree, ne, offset, sw;
      mapCenter = new google.maps.LatLng(this.defaultCity[0], this.defaultCity[1]);
      mapOptions = {
        zoom: 15,
        minZoom: 10,
        center: mapCenter,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        panControl: false,
        zoomControl: false,
        mapTypeControl: false,
        scaleControl: false,
        streetViewControl: false,
        overviewMapControl: false
      };
      elMap = document.getElementById(this.mapId);
      if (elMap != null) {
        this.map = new google.maps.Map(elMap, mapOptions);
      } else {
        utils.log("Failed to find map element: " + this.mapId);
        return;
      }
      google.maps.event.addListener(this.map, 'click', this.mapClicked);
      this.directionsDisplay = new google.maps.DirectionsRenderer();
      this.directionsDisplay.setMap(this.map);
      this.directionsService = new google.maps.DirectionsService();
      this.geocoder = new google.maps.Geocoder();
      mileToDegree = 0.0166666667;
      offset = 10 * mileToDegree;
      lat = this.defaultCity[0];
      lng = this.defaultCity[1];
      sw = new google.maps.LatLng(lat - offset, lng - offset);
      ne = new google.maps.LatLng(lat + offset, lng + offset);
      return this.mapBounds = new google.maps.LatLngBounds(sw, ne);
    };

    BikeMap.prototype.updateOrigin = function(latLngArray) {
      var animateMarker, animation, createMarker, oldOrigin, updateMarker,
        _this = this;
      if (!utils.isLatLng(latLngArray)) {
        return;
      }
      oldOrigin = this.origin;
      this.origin = new google.maps.LatLng(latLngArray[0], latLngArray[1]);
      if (oldOrigin && (oldOrigin.lat() === this.origin.lat() && oldOrigin.lng() === this.origin.lng)) {
        return;
      }
      animation = {
        delay: 10,
        steps: 100
      };
      createMarker = function() {
        var locationMarker;
        locationMarker = new google.maps.MarkerImage("images/location-marker.png");
        locationMarker.size = new google.maps.Size(32, 32);
        locationMarker.origin = new google.maps.Point(0, 0);
        locationMarker.anchor = new google.maps.Point(8, 8);
        locationMarker.scaledSize = new google.maps.Size(17, 17);
        _this.map.panTo(_this.origin);
        return _this.currentLocationMarker = new google.maps.Marker({
          map: _this.map,
          position: _this.origin,
          icon: locationMarker,
          flat: true,
          optimized: false,
          title: "Current Location",
          visible: true
        });
      };
      animateMarker = function() {
        var location, newPosition;
        location = _this.animatingLocations.shift();
        if (utils.isLatLng(location)) {
          newPosition = new google.maps.LatLng(location[0], location[1]);
          _this.currentLocationMarker.setPosition(newPosition);
        }
        if (_this.animatingLocations.length > 0) {
          return setTimeout(animateMarker, animation.delay);
        }
      };
      updateMarker = function() {
        var deltaLat, deltaLng, i, latitude, longitude, steps, _i;
        steps = animation.steps;
        latitude = _this.origin.lat();
        longitude = _this.origin.lng();
        deltaLat = (latitude - oldOrigin.lat()) / steps;
        deltaLng = (longitude - oldOrigin.lng()) / steps;
        for (i = _i = 0; 0 <= steps ? _i <= steps : _i >= steps; i = 0 <= steps ? ++_i : --_i) {
          _this.animatingLocations.push([latitude + i * deltaLat, longitude + i * deltaLng]);
        }
        return animateMarker();
      };
      if (this.showingDirections) {

      } else {
        if (this.currentLocationMarker) {
          return updateMarker();
        } else {
          return createMarker();
        }
      }
    };

    BikeMap.prototype.updateDestination = function(latLngArray) {
      if (!utils.isLatLng(latLngArray)) {
        return;
      }
      return this.destination = new google.maps.LatLng(latLngArray[0], latLngArray[1]);
    };

    BikeMap.prototype.getLatLng = function(address, callback) {
      var geocodeCallback, geocodeOptions,
        _this = this;
      geocodeOptions = {
        address: address,
        bounds: this.mapBounds
      };
      geocodeCallback = function(results, status) {
        var addResult, address_components, isNotDuplicate, location, result, _i, _len, _ref, _ref1, _ref2, _results;
        _results = [];
        isNotDuplicate = function(address) {
          var existingResult, _i, _len;
          for (_i = 0, _len = _results.length; _i < _len; _i++) {
            existingResult = _results[_i];
            if (address === existingResult.address) {
              return false;
            }
          }
          return true;
        };
        addResult = function(address, location) {
          return _results.push({
            address: address,
            location: [location.lat(), location.lng()]
          });
        };
        if (status === google.maps.GeocoderStatus.OK) {
          for (_i = 0, _len = results.length; _i < _len; _i++) {
            result = results[_i];
            location = result.geometry.location;
            address_components = result.address_components;
            address = ((_ref = address_components[0]) != null ? _ref.short_name : void 0) + " " + ((_ref1 = address_components[1]) != null ? _ref1.short_name : void 0) + ", " + ((_ref2 = address_components[3]) != null ? _ref2.short_name : void 0);
            if (_this.mapBounds.contains(location) && isNotDuplicate(address)) {
              addResult(address, location);
            }
          }
        }
        return callback(_results);
      };
      return this.geocoder.geocode(geocodeOptions, geocodeCallback);
    };

    BikeMap.prototype.calcRoute = function(callback) {
      var request, routeCallback,
        _this = this;
      if (!(this.destination != null)) {
        utils.log("Enter a destination");
        return;
      }
      if (!(this.origin != null)) {
        utils.log("Enter a starting location");
        return;
      }
      routeCallback = function(result, status) {
        var _result;
        _result = "FAILED";
        if (status === google.maps.DirectionsStatus.OK) {
          _result = "SUCCESS";
          _this.showingDirections = true;
          _this.directionsDisplay.setDirections(result);
        } else {
          utils.log("result = " + result + " status = " + status);
        }
        return callback(_result);
      };
      request = {
        origin: this.origin,
        destination: this.destination,
        travelMode: google.maps.TravelMode.BICYCLING
      };
      return this.directionsService.route(request, routeCallback);
    };

    return BikeMap;

  })();

}).call(this);