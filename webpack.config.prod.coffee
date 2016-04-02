_             = require('lodash')
webpack       = require('webpack')

{ src, app }  = require('./gulp/config')
base          = require('./webpack.config.base')

config = _.merge({}, base, {
  target: "electron"
  entry:
    app:            "#{src}/main.coffee"
    "browser/main": "#{src}/browser/main.es6"
  output: {
    path:           "#{app}"
    filename:       '[name].js'
  }
})
# sourcemap
#   webpackConfig.debug = false
#   delete webpackConfig.devtool
config.devtool = 'source-map'

config.plugins.push(
  new webpack.optimize.DedupePlugin()
)
config.plugins.push(
  new webpack.optimize.UglifyJsPlugin({
    compressor:
      screw_ie8: true
      #warnings: false
    output:
      comments: require('uglify-save-license')
  })
)


module.exports = config
