defer = require('promise-defer')
Cli = require('./__cli__')
Guide = require('./__guide__')
enabled = true

class Management
  constructor: () ->
    d = defer()
    d.resolve enabled
    # $ node index.js register <some_file>
    cli = new Cli
    guide = new Guide cli

    d.promise

module.exports = Management
