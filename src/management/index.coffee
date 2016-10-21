###
@fileOverview ./src/management/index.coffee
@description
This module has an index, as it should.
###

defer = require('promise-defer')
Cli = require('./__cli__')
Guide = require('./__guide__')
enabled = true

###
@jsdoc
Implements Management Interfaces.
@class
@description
Management is accompanied by a CLI with a Guide (Interface).
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
