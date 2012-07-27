// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.BikeLocalStorage = (function(_super) {

    __extends(BikeLocalStorage, _super);

    function BikeLocalStorage() {
      return BikeLocalStorage.__super__.constructor.apply(this, arguments);
    }

    BikeLocalStorage.prototype.saveDirections = function(origin, destination, callback) {
      var key, value;
      key = "directions";
      value = {
        "origin": origin,
        "destination": destination
      };
      return this.save(key, value, callback);
    };

    BikeLocalStorage.prototype.getDirections = function(callback) {
      var key;
      key = "directions";
      return this.get(key, callback);
    };

    return BikeLocalStorage;

  })(window.LocalStorage);

}).call(this);
