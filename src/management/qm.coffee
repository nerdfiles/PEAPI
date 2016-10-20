__q__ = require 'promise-defer'
path = require 'path'
__fs__ = require 'fs'
$env = process.env

open_file = (file) ->
  sep = '/'
  r = __q__()
  app_vantage = path.resolve $env.PWD
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
