env = require('./env')
path = require('path')
ROOT = path.resolve path.join( __dirname, '../' )

# コンフィグ中での規則
# 変数名が全部大文字 → 絶対パス
# 変数名が小文字     → 相対パス

# package for pcyp-electron
packageJson = require('../src/package.json')

APP   = "#{ROOT}/app"           # 開発中アプリの保存場所
SRC   = "#{ROOT}/src"           # ソースコード
CACHE = "#{ROOT}/cache"
DIST  = "#{ROOT}/build/dist"    # 配布ファイルの一時保存場所
BUILD = "#{ROOT}/build/Release" # 配布packageの保存場所

app = "./app"
src = {
  root    : "./src"
  resource: "./src/**/*.json",
  jade    : "./src/**/*.jade",
  coffee  : ["./src/**/*.coffee", "!./src/renderer/**/*.coffee"]
  jsx     : "./src/**/*.jsx",
  less    : "./src/**/*.less",
}

# Browserify config
browserify = {
  debug : !env.isProduction,
  extensions: ['.jsx', '.coffee'], # 省略可能な拡張子
  bundleConfigs:[
    {
      entries: "#{SRC}/renderer/component/pcyp.jsx",
      dest   : "#{APP}/renderer/component",
      outputName: "pcyp.js",
    }
    {
      entries: "#{SRC}/renderer/component/setting.jsx",
      dest   : "#{APP}/renderer/component",
      outputName: "setting.js",
    }
    {
      entries: "#{SRC}/renderer/component/player.coffee",
      dest   : "#{APP}/renderer/component",
      outputName: "player.js",
    }
  ],
  #debugExternal : ['react', 'react-dom', 'react-tap-event-plugin', 'material-ui', 'remote', 'flux']
}

doc = {
  src : ["./doc/src/*.md", "./doc/src/**/*.md"],
  dest: "./doc/html"
}

dev = {
  browser: [
    "./app/app.js"
  ],
  renderer: [
    "./app/renderer/**/*.{html,js}"
  ]
}

module.exports = {
  isWatching: false,

  ROOT: ROOT
  SRC:  SRC
  APP:  APP
  CACHE: CACHE
  BUILD: BUILD
  DIST : DIST

  app : app
  src : src
  doc : doc
  dev : dev
  packageJson: packageJson
  browserify: browserify
}
