// Generated by CoffeeScript 1.6.1
(function() {
  var Analyze, Engine, Enumerators, engine,
    __slice = [].slice;

  Enumerators = {
    simple: function(count) {
      return {
        count: count,
        represent: function(raw) {
          return raw;
        }
      };
    },
    range: function(from, to) {
      return {
        count: to - from + 1,
        represent: function(raw) {
          return from + raw;
        }
      };
    },
    set: function() {
      var item;
      item = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return {
        count: item.length,
        represent: function(raw) {
          return item[raw];
        }
      };
    }
  };

  Analyze = {
    UNDEFINED: 0,
    SUCCESS: 1,
    FAIL: 2
  };

  Engine = (function() {

    function Engine() {}

    Engine.prototype.start = function(options) {
      this._options = options;
      this.reset();
      this.idx = 0;
      return this.execute();
    };

    Engine.prototype.reset = function() {
      this.values = [];
      this.status = Analyze.UNDEFINED;
      return this._enumerators = [];
    };

    Engine.prototype.execute = function() {
      var _this = this;
      if (this.idx < 20) {
        this.trigger('onProgress', this.idx, [this.idx]);
        this.idx++;
        return setTimeout(function() {
          return _this.execute();
        }, 500);
      } else {
        return this.trigger('onComplete');
      }
    };

    Engine.prototype.trigger = function() {
      var args, method;
      method = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      return postMessage(JSON.stringify({
        method: method,
        args: args
      }));
    };

    Engine.prototype.log = function(message) {
      return this.trigger('log', message);
    };

    Engine.prototype.nextEnumerator = function() {
      if (this.values.length < 10) {
        return Enumerators.simple(10000);
      }
    };

    Engine.prototype.analyze = function() {};

    return Engine;

  })();

  engine = new Engine();

  self.addEventListener('message', function(event) {
    var message;
    message = JSON.parse(event.data);
    return engine[message.method].apply(engine, message.args);
  });

}).call(this);
