###
@fileOverview ./src/management/index.coffee
###

defer = require('promise-defer')
Cli = require('./__cli__')
Guide = require('./__guide__')
enabled = true

###
@jsdoc
Implements Management Interfaces.
@class
###

class Management
  constructor: () ->
    d = defer()
    return (d.reject(enabled) &&
      console.log('Management: Disabled'))  if !enabled
    d.resolve enabled
    cli = new Cli
    guide = new Guide cli

    d.promise

module.exports = Management
