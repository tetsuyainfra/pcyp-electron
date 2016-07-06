env = require('./env')
path = require('path')
ROOT = path.resolve path.join( __dirname, '../' )

# コンフィグ中での規則
# 変数名が全部大文字 → 絶対パス
# 変数名が小文字     → 相対パス

# package for pcyp-electron
#packageJson = require('../src/package.json')

APP   = "#{ROOT}/app"           # 開発中アプリの保存場所
SRC   = "#{ROOT}/src"           # ソースコード
CACHE = "#{ROOT}/cache"
DIST  = "#{ROOT}/build/dist"    # 配布ファイルの一時保存場所
BUILD = "#{ROOT}/build/Release" # 配布packageの保存場所

doc = {
  src : ["./doc/src/*.md", "./doc/src/**/*.md"],
  dest: "./doc/html"
}

test = {
  target: ["./src/**/*.test.coffee"]
  jasmine : {
    require: ['./spec/helper.coffee']
  }
}

connect = {
  browser: [
    "./app/**/*.js"
    "!./app/renderer/**/*.*"
    "!./app/player/**/*.*"
  ],
  renderer: [
    "./app/renderer/component/*.{html,js}"
    "./app/renderer/player/*.{html,js}"
  ]
}

module.exports = {
  ROOT: ROOT
  SRC:  SRC
  APP:  APP
  CACHE: CACHE
  BUILD: BUILD
  DIST : DIST
}
