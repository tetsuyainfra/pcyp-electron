_       = require('lodash')
path    = require('path')
webpack = require('webpack')
CleanWebpackPlugin = require('clean-webpack-plugin')
CopyWebpackPlugin = require('copy-webpack-plugin')


{ SRC, APP } = require('./scripts/config.coffee')

module.exports = (options) ->
  { ENV, WATCH, REVISION } = options
  config = {
    name: "ELECTRON_#{ENV}"
    target: "electron"
    node: {
      __dirname: false,
      __filename: false,
    }
    entry: {
      main: [
        path.join(SRC, 'main.es6')
      ]
    }
    output: {
      path: APP
      filename: '[name].js'
  		chunkFilename: "[name].[id].[hash].js"
    }
    plugins: [
      new CleanWebpackPlugin(["main.*"],{
        root: path.join(__dirname, 'app')
        verbose: true
        dry: false
      })
      new CopyWebpackPlugin([{
        from: path.join(SRC, "package.json")
        to:   APP
      }], {
      })
      new webpack.DefinePlugin({
        'process.env.NODE_ENV': JSON.stringify(ENV)
        REVISION: JSON.stringify(REVISION)
        PRODUCTION: if ENV == "production" then true else false
      })
    ]
    module: {
      loaders: [
        {
          test:   /\.(coffee)$/
          loader: 'coffee-loader'
          exclude: '/node_modules/'
        }
        {
          test:   /\.(es6)$/
          loader: 'babel-loader'
          exclude: '/node_modules/'
        }
      ]
      noParse: [
        /\.\/data\//, /\.\/nightwatch\//
      ]
    } # module
    resolve: {
      extensions: ['', '.js', '.coffee']
      root: SRC
      modulesDirectories: ['node_modules'],
    }
  }

  # テストコンパイルではエントリーをコンパイルしない
  # ※ testファイルで読み込まれているものだけコンパイルする
  if !WATCH && ENV == "test"
    delete config.entry
    delete config.output

  if ENV == "development"
    config.debug = true
    config.devtool = '#source-map'
    # config.devtool = '#cheap-module-source-map'

  return config
