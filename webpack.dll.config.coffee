path    = require('path')
_       = require('lodash')
webpack = require('webpack')
HtmlWebpackPlugin = require('html-webpack-plugin')
ExtractTextPlugin = require('extract-text-webpack-plugin')
CleanWebpackPlugin = require('clean-webpack-plugin')

env = require('./scripts/env')

#! webpack.plugin.configの使い方
#  webpack --config=webpack.plugin.config.coffee
ENV= env.name
WATCH=  env.watch
REVISION= env.revision
SERVER_SIDE= env.serverSide

#
# config for VENDOR DLL on client
#
vendorConfig = {
  name: "DLL_VENDOR_#{ENV}"
  # devtool: '#eval'
  devtool: '#source-map'
  entry: {
    vendor: [
      './src/vendor.es6',
    ]
  }
  output: {
    path: path.join(__dirname, 'app', 'dll')
    filename: 'dll.[name].js'
    library: '[name]_[hash]'
  }
  plugins: [
    new CleanWebpackPlugin([path.join(__dirname, 'app', 'dll')],{
      verbose: true
      dry: false
    })
    new webpack.ProvidePlugin({
      $: "jquery",
      jQuery: 'jquery',
    })
    new webpack.DefinePlugin({
      'process.env.NODE_ENV':    JSON.stringify(env.name)
    })
    new webpack.optimize.OccurenceOrderPlugin()
    new webpack.DllPlugin({
      path: path.join(__dirname, 'dll', '[name]-manifest.json')
      # どこにdll bundleが作られているかか指定する
      name: '[name]_[hash]'
    })
  ]
  module: {
    preLoaders: [
      {
        test:     /\.scss$/
        loader:   "sass-loader?sourceMap"
      }
    ]
    loaders: [
      {
        test:   /\.(es6|jsx)$/
        loader: 'babel'
        exclude: '/node_modules/'
        query: {
          compact: false
          cacheDirectory: true
        }
      }
      {
        test: /\.jade$/
        loader: "jade?pretty=true"
      }
      {include: /\.json$/, loaders: ['json-loader']}
    ]
  } # module
  resolve: {
    extensions: ['', '.js', '.es6', '.jsx']
    modulesDirectories: ['node_modules']
    module: {
      noParse: [
        /\.\/data\//, /\.\/nightwatch\//
      ]
    }
    alias: {
      jquery: "jquery/src/jquery"
    }
  }
}
if ENV == "development"
  vendorConfig.entry.vendor.push('./src/vendor.debug.es6')

if ENV == "production"
  console.log('Enable Optimization')
  vendorConfig.devtool = '#cheap-module-source-map'
  vendorConfig.plugins.push(
    new webpack.optimize.UglifyJsPlugin({
      comments: require('uglify-save-license')
      compress: { warnings: false }
    })
  )

# module.exports = [vendorConfig, apiConfig]
module.exports = vendorConfig
