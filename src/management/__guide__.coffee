defer = require('promise-defer')
async = require('async')
_ = require('lodash')
crypto = require('crypto')
request = require('request')
QueryManager = require './qm'
enabled = true
colors = require('colors')


prep_setup = () ->

  ###
  @inner
  @description
  ###

  g = defer()
  qm = new QueryManager

  g.resolve true
  qm.add_file('~/.bashrc').then (file_contents) ->
    console.log file_contents

  g.promise

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
    F = _.filter @config, (o, k) -> o  if _.isString(o) # Filename
    # mapping id of cli inputs to public methods of Guide
    K = _.filter _.map @config, (o, k) -> k  if o is true # Method

    __callback__ = (doc, state) ->
      return  if /failed/.test(state) is true
      __doc__ = if doc and doc.body then (JSON.parse doc.body).reason.rainbow else 'task completed'.gray
      console.log __doc__

    if not _.isEmpty(F)
      methods = _.map K, (methodName) => () => @[methodName](F, __callback__)
    else
      methods = _.map K, (methodName) => () => @[methodName](__callback__)

    async.series methods, () ->
      console.log K.join('').rainbow + ' completed'

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
        if error
          d.reject error
          return
        d.resolve response
        return

    d.promise

  register: (filename, callback) =>

    ###
    @method register
    ###

    @op("register", filename).then(
      (data) ->
        callback data, 'register finished'
      ,
      () ->
        callback null, 'register failed'
    )

  setup: (callback) =>

    ###
    @method setup
    ###

    prep_setup().then () ->
      callback null, 'setup finished'
    return


  status: (filename, callback) =>

    ###
    @method status
    ###

    @op("status", filename).then(
      (data) ->
        callback data, 'status check finished'
      ,
      () ->
        callback null, 'status check failed'
    )

module.exports = Guide
