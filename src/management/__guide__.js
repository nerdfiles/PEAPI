// Generated by CoffeeScript 1.11.1
(function() {
  var Guide, QueryManager, _, async, colors, crypto, defer, enabled, prep_payload, prep_setup, program, request,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  defer = require('promise-defer');

  async = require('async');

  _ = require('lodash');

  crypto = require('crypto');

  request = require('request');

  QueryManager = require('./qm');

  enabled = true;

  colors = require('colors');

  program = require('commander');

  prep_setup = function() {

    /*
    @inner
    @description
     */
    var g, qm;
    g = defer();
    qm = new QueryManager;
    g.resolve(true);
    qm.add_file('~/.bashrc').then(function(file_contents) {
      return console.log(file_contents);
    });
    return g.promise;
  };

  prep_payload = function(file) {

    /*
    @inner
    @name prep_payload
    @description
    Encrypt our file after having finally opened it.
     */
    var e, g, out, qm;
    g = defer();
    out = null;
    qm = new QueryManager;
    try {
      qm.add_file(file).then(function(file_contents) {
        var payload;
        out = crypto.createHash('sha256').update(file_contents).digest('base64');
        payload = {
          d: out
        };
        return g.resolve(payload);
      });
    } catch (error1) {
      e = error1;
      g.reject(e);
    }
    return g.promise;
  };

  Guide = (function() {
    function Guide(cli) {
      var F, K, __callback__, d, methods;
      this.cli = cli;
      this.status = bind(this.status, this);
      this.setup = bind(this.setup, this);
      this.register = bind(this.register, this);
      if (!enabled) {
        return console.log('Guide: Disabled');
      }
      d = defer();
      if (!enabled) {
        d.reject(enabled);
      }
      if (enabled) {
        d.resolve(enabled);
      }
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
      __callback__ = function(doc, state) {
        var __doc__;
        if (/failed/.test(state) === true) {
          return;
        }
        __doc__ = doc && doc.body ? (JSON.parse(doc.body)).reason.rainbow : 'task completed'.gray;
        return console.log(__doc__);
      };
      if (!_.isEmpty(F)) {
        methods = _.map(K, (function(_this) {
          return function(methodName) {
            return function() {
              return _this[methodName](F, __callback__);
            };
          };
        })(this));
      } else {
        methods = _.map(K, (function(_this) {
          return function(methodName) {
            return function() {
              return _this[methodName](__callback__);
            };
          };
        })(this));
      }
      async.series(methods, function() {
        return console.log(K.join('').rainbow + ' completed');
      });
      d.promise;
    }

    Guide.prototype.op = function(m, file) {

      /*
      @method op
      @description
      API to proofofexistence.com.
       */
      var d, method, url;
      d = defer();
      url = 'https://www.proofofexistence.com/api/v1/';
      method = url + m;
      prep_payload(file).then(function(o) {
        return request({
          method: 'post',
          url: method,
          rejectUnauthorized: false,
          qs: o
        }, function(error, response, body) {
          if (error) {
            d.reject(error);
            return;
          }
          d.resolve(response);
        });
      });
      return d.promise;
    };

    Guide.prototype.register = function(filename, callback) {

      /*
      @method register
       */
      return this.op("register", filename).then(function(data) {
        return callback(data, 'register finished');
      }, function() {
        return callback(null, 'register failed');
      });
    };

    Guide.prototype.setup = function(callback) {

      /*
      @method setup
       */
      prep_setup().then(function() {
        return callback(null, 'setup finished');
      });
    };

    Guide.prototype.status = function(filename, callback) {

      /*
      @method status
       */
      return this.op("status", filename).then(function(data) {
        return callback(data, 'status check finished');
      }, function() {
        return callback(null, 'status check failed');
      });
    };

    return Guide;

  })();

  module.exports = Guide;

}).call(this);
