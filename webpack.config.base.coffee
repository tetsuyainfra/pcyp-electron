#--------------------------------------------------
#  Webpack config( Base )
#--------------------------------------------------
webpack = require('webpack')

{src, app} = require('./gulp/config')
env = require('./gulp/env')

# config for webpack
webpackConfig = {
  target: "electron"
  plugins: [
    new webpack.DefinePlugin({
      REVISION:      JSON.stringify(env.revision)
      DEBUG:        ! env.isProduction,
      PRODUCTION:   env.isProduction,
    })
    new webpack.ExternalsPlugin('commonjs',
      [
        'electron'
        'yargs'
        'isomorphic-fetch'
      ]
    )
    new webpack.ProvidePlugin({
      React:    'react'
      ReactDOM: 'react-dom'
    })
  ]

  # debug setting
  debug: true
  #devtool: 'eval'
  devtool: 'cheap-module-eval-source-map' # dev向け
  #devtool: 'source-map' # production向け

  resolve: {
    extensions: ['', '.js', '.es6', '.jsx', '.coffee']
  }
  module: {
    preLoaders: [
      # cssはextract-text-webpack-pluginで別ファイルにする？
      # https://webpack.github.io/docs/stylesheets.html
      {
        test:     /\.scss$/
        loader:   "sass-loader"
      },
    ]
    loaders: [
      {
        test:   /\.(es6|jsx)$/
        loader: 'babel-loader'
        exclude: '/(node_modules)/'
        query:
          compact: false
          presets: ['react', 'es2015']
      }
      {
        test: /\.coffee$/
        loader: "coffee-loader"
        query: {
          bare: true
        }
      }
      {
        test: /\.json$/
        loader: "json-loader"
      }
    ]
    postLoaders: [
      {
        test:   /\.(js|es6|jsx|coffee)$/
        loader: "transform?envify"
      }
    ]
  }
}


module.exports = webpackConfig
