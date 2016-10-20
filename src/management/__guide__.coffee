defer = require('promise-defer')
async = require('async')
_ = require('lodash')
crypto = require('crypto')
request = require('request')
QueryManager = require './qm'
enabled = true


prep_payload = (file) ->

  ###
  @inner
  @name prep_payload
  @description
  Encrypt our file after having finally opened it.
  ###

  g = defer()
  out = null
  qm = new QueryManager

  try
    qm.add_file(file).then (file_contents) ->
      out = crypto.createHash('sha256')
        .update(file_contents)
        .digest('base64')

      payload =
        d: out

      g.resolve payload

  catch e
    g.reject e

  g.promise


class Guide

  constructor: (@cli) ->

    return console.log('Guide: Disabled')  if !enabled

    d = defer()
    d.reject(enabled)  if !enabled
    d.resolve(enabled)  if enabled

    @config = @cli.initConfig
    F = _.filter @config, (o, k) -> o  if _.isString(o)
    # mapping id of cli inputs to public methods of Guide
    K = _.filter _.map @config, (o, k) -> k  if o is true
    methods = _.map K, (methodName) => () => @[methodName](F)

    async.series methods, (error, result) ->
      console.log result

    d.promise

  op: (m, file) ->

    ###
    @method op
    @description
    API to proofofexistence.com.
    ###


    d = defer()
    url = 'https://www.proofofexistence.com/api/v1/'
    method = url + m

    prep_payload(file).then (o) ->

      request
        method             : 'post'
        url                : method
        rejectUnauthorized : false
        qs                 : o
      , (error, response, body) ->
        console.log response
        if error
          d.reject error
          return
        d.resolve response.statusCode
        return

    d.promise

  register: (filename, callback) =>

    ###
    @method register
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
    ###

    @op("status", filename).then(
      (error, data) ->
        callback null, 'status check finished'
      ,
      () ->
        callback null, 'status check failed'
    )

module.exports = Guide
