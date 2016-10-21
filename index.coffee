###
@fileOverview /index.coffee
@description
Module Index.
###

P = require('bluebird')
Management = require('./src/management')
P.resolve(Management())

