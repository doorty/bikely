// Generated by CoffeeScript 1.3.3
(function() {

  window.LocalStorage = (function() {

    function LocalStorage(callback) {
      var name, record;
      name = "name";
      record = "record";
      if (callback == null) {
        callback = function(info) {
          return utils.log("storage ready: " + info);
        };
      }
      this.storage = Lawnchair({}, callback);
    }

    LocalStorage.prototype.save = function(key, value, callback) {
      return this.saveCookie(key, value, callback);
    };

    LocalStorage.prototype.saveCookie = function(key, value, callback) {
      var saved;
      saved = $.cookie(key, JSON.stringify(value));
      return alert("saved: " + saved);
    };

    LocalStorage.prototype.get = function(key, callback) {
      return this.getCookie(key, callback);
    };

    LocalStorage.prototype.getCookie = function(key, callback) {
      var resultObj;
      resultObj = JSON.parse($.cookie(key));
      alert("get: " + resultObj);
      return callback(resultObj);
    };

    LocalStorage.prototype.remove = function(key, callback) {
      return $.cookie(key, null);
    };

    return LocalStorage;

  })();

}).call(this);
