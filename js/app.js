// Generated by CoffeeScript 1.6.1
(function() {
  var EngineManager,
    __slice = [].slice;

  EngineManager = (function() {

    function EngineManager(solver) {
      var _this = this;
      this.solver = solver;
      this.worker = new Worker('js/enumerate.js');
      this.worker.onmessage = function(event) {
        var message, method;
        message = JSON.parse(event.data);
        method = _this[message.method];
        if (method) {
          return method.apply(_this, message.args);
        }
      };
    }

    EngineManager.DEFAULT_OPTIONS = {
      ticks: 100,
      all: false
    };

    EngineManager.prototype.start = function(options) {
      if (options) {
        options = _["default"](EngineManager.DEFAULT_OPTIONS);
      } else {
        options = EngineManager.DEFAULT_OPTIONS;
      }
      return this.invokeWorker('start', options);
    };

    EngineManager.prototype.log = function(message) {
      return console.log("Worker: " + message);
    };

    EngineManager.prototype.onProgress = function(ticks, values) {
      return $('#status').html(EngineManager.printValues(values));
    };

    EngineManager.prototype.onComplete = function() {
      return $('#status').html('Completed');
    };

    EngineManager.prototype.invokeWorker = function() {
      var args, method;
      method = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      return this.worker.postMessage(JSON.stringify({
        method: method,
        args: args
      }));
    };

    EngineManager.printValues = function(values) {
      if (_.isArray(values)) {
        return _.reduce(values, function(str, item) {
          if (str.length > 0) {
            str += '-';
          }
          return str += "<" + item + ">";
        }, '');
      } else {
        return values.toString();
      }
    };

    return EngineManager;

  })();

  $(function() {
    var enman;
    enman = new EngineManager();
    return $('#play').button({
      text: false,
      icons: {
        primary: 'ui-icon-play'
      }
    }).click(function() {
      return enman.start();
    });
  });

}).call(this);