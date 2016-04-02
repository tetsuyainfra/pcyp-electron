_             = require('lodash')
webpack       = require('webpack')

{ src, app }  = require('./gulp/config')
base          = require('./webpack.config.base')

config = _.merge({}, base, {
  target: "electron"
  entry:
    app: "#{src}/main.coffee"
    "browser/pcyp": "#{src}/browser/pcyp.es6"
    "browser/commons": ["react", "react-dom"]
  output: {
    path:           "#{app}"
    filename:       '[name].js'
  }
})
config.plugins.push(
  new webpack.optimize.CommonsChunkPlugin({
    name: "browser/commons"
    #minChunks: Infinity,
  })
)

module.exports = config
