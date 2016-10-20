defer = require('promise-defer')
async = require('async')
_ = require('lodash')
crypto = require('crypto')
request = require('request')
enabled = true

class Guide

  constructor: (@cli) ->

    return console.log('Guide: Disabled')  if !enabled

    d = defer()
    @config = @cli.initConfig

    F = _.filter @config, (o, k) -> o  if _.isString(o)

    K = _.filter _.map @config, (o, k) -> k  if o is true

    methods = _.map K, (methodName) => () => @[methodName](F)

    d.reject(enabled)  if !enabled

    async.series methods, (error, result) ->
      console.log result

    d.resolve(enabled)  if enabled

    d.promise

  op: (m, file) ->

    ###
    @method op
    @description
    API to proofofexistence.com.
    ###

    d = defer()
    pwd = ''
    hash = ''
    url = 'https://www.proofofexistence.com/api/v1/'

    try
      hash = crypto.createHash(file)
        .update(pwd)
        .digest('base64')
    catch e
      hash = e

    payload =
      d: hash

    console.log payload

    request {
      url: url + m
      qs: payload
    }, (err, response, body) ->
      if err
        d.reject err
        return
      d.resolve response.statusCode
      return

    d.promise

  register: (filename, callback) =>

    ###
    @method register
    @description
    ###

    @op("register", filename).then(
      (error, data) ->
        callback null, 'register finished'
      ,
      () ->
        callback null, 'register failed'
    )

  status: (filename, callback) =>

    ###
    @method status
    @description
    ###

    @op("status", "file").then(
      (error, data) ->
        callback null, 'status check finished'
      ,
      () ->
        callback null, 'status check failed'
    )

module.exports = Guide
