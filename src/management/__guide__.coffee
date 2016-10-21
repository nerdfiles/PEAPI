defer = require('promise-defer')
async = require('async')
_ = require('lodash')
crypto = require('crypto')
request = require('request')
QueryManager = require './qm'
enabled = true
colors = require('colors')
program = require 'commander'

prep_setup = () ->

  ###
  @inner
  @description
  ###

  g = defer()
  qm = new QueryManager

  g.resolve true
  # @TODO capture PWD relative to bashrc and add alias for PEAPI
  qm.add_file('~/.bashrc').then (file_contents) ->
    console.log file_contents

  g.promise

prep_request = (file) ->

  ###
  @inner
  @name prep_request
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

      qs =
        d: out

      g.resolve qs

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

    ###
    @inner
    @name __reporter__
    ###

    __reporter__ = (doc, state) ->

      return  if /failed/.test(state) is true
      __view__ = doc and doc.body
      __success__ = (JSON.parse __view__).reason.rainbow
      __finalized__ = 'task completed'.gray
      __doc__ = if __view__ then __success__ else __finalized__
      console.log __doc__

    __file_mapper__ = _.map K, (methodName) => () => @[methodName] F, __reporter__
    __stub__ = _.map K, (methodName) => () => @[methodName] __reporter__

    if not _.isEmpty(F)
      methods = __file_mapper__
    else
      methods = __stub__

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

    prep_request(file).then (o) ->

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
    @cite https://proofofexistence.com/developers: used to register a new
    document's SHA256 digest. Returns a payment address where you need to send
    the bitcoins to have the document certified in the blockchain, and the
    amount of bitcoins you need to send expressed in satoshis
    (100000000 satoshis = 1 BTC).
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

  ###
  @method status
  @cite https://proofofexistence.com/developers: receives a digest and returns
  the status of that document. If the status is `pending`, you'll also get the
  payment address and price to confirm the document in the blockchain.
  @param filename {string} a file from the local system to be computed for its SHA256
  checksum digest.
  @param callback {function} a callback function
  ###

  status: (filename, callback) =>

    @op("status", filename).then(
      (data) ->
        callback data, 'status check finished'
      ,
      () ->
        callback null, 'status check failed'
    )

module.exports = Guide
