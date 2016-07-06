env             = require('./scripts/env.coffee')
webpackElectron = require('./webpack.electron.coffee')
webpackClient   = require('./webpack.client.coffee')


module.exports = [
  webpackElectron({
    ENV: env.name
    WATCH:  env.watch
    REVISION: env.revision
  })
  webpackClient({
    ENV: env.name
    WATCH:  env.watch
    REVISION: env.revision
  })
]
