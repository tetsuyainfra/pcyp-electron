
env = require('./gulp/env')

if env.isProduction
  config = require('./webpack.config.prod')
else
  config = require('./webpack.config.dev')

module.exports = config
