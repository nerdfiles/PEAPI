P = require('bluebird')
Management = require('./src/management')
P.resolve(Management())
  .then('./src/api')

