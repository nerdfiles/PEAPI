###
@fileOverview ./src/management/qm.coffee
@description
Eventually to grace us as a management system for files that have been 
digested. For now it merely opens a file and passes it along
to the Guide.
###

__q__ = require 'promise-defer'
__path__ = require 'path'
__fs__ = require 'fs'
$env = process.env

###
@jsdoc
@inner
@name open_file
@description
Opens a file.
###

open_file = (file) ->
  sep = '/'
  r = __q__()
  app_vantage = __path__.resolve $env.PWD
  __fs__.readFile app_vantage + sep + file, 'utf-8', (error, data) ->
    return console.log error  if error
    r.resolve data
  r.promise

###
@jsdoc
Implements Query Management. So we store our history of files added, etc.
@class
###

class QueryManager

  constructor: () ->
    @files = null

  # @stub
  ls_files: () ->
    return

  ###
  @prototype
  @name add_file
  @description
  Should likely create a list of files elsewhere since we are technically
  stateless right now; or set up an eventing system to create
  hashes for each new invoke.
  ###

  add_file: (file) ->
    open_file(file)

module.exports = QueryManager
