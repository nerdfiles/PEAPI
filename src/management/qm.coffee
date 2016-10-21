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

open_file = (file) ->
  sep = '/'
  r = __q__()
  app_vantage = __path__.resolve $env.PWD
  __fs__.readFile app_vantage + sep + file, 'utf-8', (error, data) ->
    return console.log error  if error
    r.resolve data
  r.promise

class QueryManager

  constructor: () ->
    @files = null

  ls_files: () ->
    return

  add_file: (file) ->
    open_file(file)

module.exports = QueryManager
