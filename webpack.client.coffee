_       = require('lodash')
path    = require('path')
webpack = require('webpack')
HtmlWebpackPlugin = require('html-webpack-plugin')
ExtractTextPlugin = require('extract-text-webpack-plugin')
CleanWebpackPlugin = require('clean-webpack-plugin')
# AddAssetHtmlPlugin = require('add-asset-html-webpack-plugin')

parseDllManifest = (filename) ->
  [name, hash] = require(filename).name.split('_')
  # p = require.resolve("./app/dll/#{hash}/dll.#{name}.js")
  p = require.resolve("./app/dll/dll.#{name}.js")
  return path.relative('./app', p).split(path.sep).join('/')

{ SRC, APP } = require('./scripts/config.coffee')

module.exports = (options) ->
  { ENV, WATCH, SERVER_SIDE, REVISION } = options
  config = {
    name: "CLIENT_#{ENV}"
    target: "electron-renderer"
    entry: {
      client: [
        path.join(SRC, 'client.es6')
      ]
      # commons: [
      #   # path.join(SRC, '_assets', 'uikit.scss'),
      #   # path.join(SRC, '_assets', 'style.scss'),
      # ]
    }
    output: {
      path: path.join(__dirname, 'app')
      filename: '[name].js'
  		chunkFilename: "[name].[id].[hash].js"
    }
    plugins: [
      new CleanWebpackPlugin(["client.*"],{
        root: path.join(__dirname, 'app')
        verbose: true
        dry: false
      })
      new HtmlWebpackPlugin({
        template: path.join(SRC, '_index.jade')
        dllPath: parseDllManifest('./dll/vendor-manifest.json')
      })
      new webpack.ProvidePlugin({
        $: "jquery",
        jQuery: 'jquery',
      })
      new webpack.ExternalsPlugin('commonjs', [
        "wcjs-prebuilt"
      ])
      new webpack.DefinePlugin({
        'process.env.NODE_ENV': JSON.stringify(ENV)
        REVISION:         JSON.stringify(REVISION)
        PRODUCTION:       if ENV == "production" then true else false
      })
      new webpack.DllReferencePlugin({
        context: __dirname
        manifest: require('./dll/vendor-manifest.json')
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
          test:   /\.(woff|woff2|ttf|eot|svg)$/
          loader: 'file'
          query: {
            # name: "app/img/[hash].[ext]"
            name: "css/fonts/[name].[ext]"
          }
        }
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
          loader: "jade-loader?pretty=true"
        }
        {
          test: /(\.scss|\.css)$/
          loader: ExtractTextPlugin.extract('css?sourceMap!postcss!resolve-url')
          loader: 'css?sourceMap!postcss!resolve-url'
        }
        {include: /\.json$/, loaders: ['json-loader']}
      ]
      noParse: [
        /\.\/data\//, /\.\/nightwatch\//
      ]
    } # module
    externals: [
      {
        # "wcjs-prebuilt": "wcjs-prebuilt"
      }
    ]
    resolve: {
      extensions: ['', '.js', '.es6', '.jsx']
      root: path.join(__dirname, 'src'),
      modulesDirectories: ['node_modules'],
      alias: {
        jquery: "jquery/src/jquery"
      }
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
