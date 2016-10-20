// Generated by CoffeeScript 1.11.1
(function() {
  var Guide, _, async, crypto, defer, enabled, request,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  defer = require('promise-defer');

  async = require('async');

  _ = require('lodash');

  crypto = require('crypto');

  request = require('request');

  enabled = true;

  Guide = (function() {
    function Guide(cli) {
      var F, K, d, methods;
      this.cli = cli;
      this.status = bind(this.status, this);
      this.register = bind(this.register, this);
      if (!enabled) {
        return console.log('Guide: Disabled');
      }
      d = defer();
      this.config = this.cli.initConfig;
      F = _.filter(this.config, function(o, k) {
        if (_.isString(o)) {
          return o;
        }
      });
      K = _.filter(_.map(this.config, function(o, k) {
        if (o === true) {
          return k;
        }
      }));
      methods = _.map(K, (function(_this) {
        return function(methodName) {
          return function() {
            return _this[methodName](F);
          };
        };
      })(this));
      if (!enabled) {
        d.reject(enabled);
      }
      async.series(methods, function(error, result) {
        return console.log(result);
      });
      if (enabled) {
        d.resolve(enabled);
      }
      d.promise;
    }

    Guide.prototype.op = function(m, file) {

      /*
      @method op
      @description
      API to proofofexistence.com.
       */
      var d, e, hash, payload, pwd, url;
      d = defer();
      pwd = '';
      hash = '';
      url = 'https://www.proofofexistence.com/api/v1/';
      try {
        hash = crypto.createHash(file).update(pwd).digest('base64');
      } catch (error1) {
        e = error1;
        hash = e;
      }
      payload = {
        d: hash
      };
      console.log(payload);
      request({
        url: url + m,
        qs: payload
      }, function(err, response, body) {
        if (err) {
          d.reject(err);
          return;
        }
        d.resolve(response.statusCode);
      });
      return d.promise;
    };

    Guide.prototype.register = function(filename, callback) {

      /*
      @method register
      @description
       */
      return this.op("register", filename).then(function(error, data) {
        return callback(null, 'register finished');
      }, function() {
        return callback(null, 'register failed');
      });
    };

    Guide.prototype.status = function(filename, callback) {

      /*
      @method status
      @description
       */
      return this.op("status", "file").then(function(error, data) {
        return callback(null, 'status check finished');
      }, function() {
        return callback(null, 'status check failed');
      });
    };

    return Guide;

  })();

  module.exports = Guide;

}).call(this);
