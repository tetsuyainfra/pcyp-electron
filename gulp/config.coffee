#--------------------------------------------------
#  Gulp task & Webpack config
#--------------------------------------------------

webpack = require('webpack')

env = require('./env')
path = require('path')
ROOT = path.resolve path.join( __dirname, '../' )
# コンフィグ中での規則
# 変数名が小文字     → 相対パス
# 変数名が全部大文字 → 絶対パス

# package for pcyp-electron
packageJson = require('../src/package.json')

app   = "./app"           # 開発中アプリの保存場所
src   = "./src"           # ソースコード
cache = "./cache"
build = "./build/Release" # 配布packageの一時保存場所
dist  = "./build/dist"    # 配布ファイルの保存場所

module.exports = {
  isWatching: false,
  app  : app
  src  : src
  cache: cache
  build: build
  dist : dist

  packageJson: packageJson
}


# config for webpack
webpackConfig = {
  target: "electron"
  entry:
    app: "#{src}/main.coffee"
  output: {
    path:           "#{app}"
    filename:       '[name].js'
  }
  externals: [
    {
      yargs: true
    }
  ]
  resolve: {
    extensions: ['', '.js', '.es6', '.jsx', '.coffee']
  }
  plugins: [
    new webpack.ProvidePlugin({
      React:    'react'
      ReactDOM: 'react-dom'
    })
    new webpack.DefinePlugin({
      REVISION:      JSON.stringify(env.revision)
      DEBUG:        ! env.isProduction,
      PRODUCTION:   env.isProduction,
    })
    # vender-libをcommonにまとめる
    # new webpack.optimize.CommonsChunkPlugin({
    #   name: "vendor"
    # })
  ]

  # debug setting
  debug: true
  #devtool: 'eval'
  devtool: '#source-map'
  #devtool: '#eval-source-map'

  module: {
    preLoaders: [
      {
        test:     /\.scss$/
        loader:   "sass"
      },
    ]
    loaders: [
      {
        test:   /\.(es6|jsx)$/
        loader: 'babel'
        exclude: '/(node_modules)/'
        query:
          compact: false
          presets: ['react', 'es2015']
      }
      {
        test: /\.coffee$/
        loader: "coffee"
        query: {
          bare: true
        }
      }
    ]
    # postLoaders: [
    #   {
    #     test:   /\.(js|es6|jsx|coffee)$/
    #     loader: "transform?envify"
    #   }
    # ]
  } # module
}

if env.isProduction
  # disable sourcemap
  webpackConfig.debug = false
  delete webpackConfig.devtool
  # optimize
  webpackConfig.plugins.push(
    new webpack.optimize.UglifyJsPlugin({
      sourceMap: false
      output:
        comments: require('uglify-save-license')
    })
  )

module.exports.webpack = webpackConfig
