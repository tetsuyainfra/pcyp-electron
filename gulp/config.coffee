env = require('./env')
path = require('path')
root = path.resolve path.join( __dirname, '../' )


# package for pcyp-electron
packageJson = require('../src/package.json')

APP   = "#{root}/app"           # 開発中アプリの保存場所
CACHE = "#{root}/cache"
DIST  = "#{root}/build/dist"    # 配布ファイルの一時保存場所
BUILD = "#{root}/build/Release" # 配布packageの保存場所

src = {
  root    : "#{root}/src"
  resource: "#{root}/src/**/*.json",
  jade    : "#{root}/src/**/*.jade",
  coffee  : "#{root}/src/**/*.coffee",
  jsx     : "#{root}/src/**/*.jsx",
  less    : "#{root}/src/**/*.less",
}

# Browserify config
browserify = {
  debug : !env.isProduction,
  extensions: ['.jsx', '.coffee'], # 省略可能な拡張子
  bundleConfigs:[
    {
      entries: "#{src.root}/renderer/component/pcyp.jsx",
      dest   : "#{APP}/renderer/component",
      outputName: "pcyp.js",
    },
    {
      entries: "#{src.root}/renderer/component/setting.jsx",
      dest   : "#{APP}/renderer/component",
      outputName: "setting.js",
    }
  ],
  #debugExternal : ['react', 'react-dom', 'react-tap-event-plugin', 'material-ui', 'remote', 'flux']
}

doc = {
  src : ["#{root}/doc/src/*.md", "#{root}/doc/src/**/*.md"],
  dest: "#{root}/doc/html"
}

dev = {
  browser: [
    "#{APP}/app.js"
  ],
  renderer: [
    "#{APP}/renderer/**/*.{html,js}"
  ]
}

module.exports = {
  root: root,
  APP:  APP,
  CACHE: CACHE,
  BUILD: BUILD,
  DIST : DIST,

  src : src,
  doc : doc,
  dev : dev,
  packageJson: packageJson,
  browserify: browserify
}
