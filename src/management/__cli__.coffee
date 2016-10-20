docopt = require('docopt-js');

__parser__ = (f) ->
  f.toString().
    replace(/^[^\/]+\/\*!?/, '').
    replace(/\*\/[^\/]+$/, '')

cli = __parser__(() ->
  ###!
  Usage:
    index register <file>
    index status <file>
    index setup
    index -h | --help
    index --version
  ###
)

class Cli
  constructor: () ->
    @initConfig = docopt.docopt cli, version: '0.0.1'

module.exports = Cli
