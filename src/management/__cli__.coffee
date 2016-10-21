docopt = require('docopt-js')

__parser__ = (f) ->
  f.toString().
    replace(/^[^\/]+\/\*!?/, '').
    replace(/\*\/[^\/]+$/, '')

cli = __parser__(() ->
  ###!
  Usage:
    index reg <file>
    index check <file>
    index setup
    index logs
    index wallet config <wallet_address>
    index pay <payment_address> <amount> <denomination>
    index -h | --help
    index --version
  ###
)

class Cli
  constructor: () ->
    @initConfig = docopt.docopt cli, version: '0.0.1'

module.exports = Cli
