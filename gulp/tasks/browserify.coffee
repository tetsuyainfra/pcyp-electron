gulp = require('gulp')
$    = require('gulp-load-plugins')()
browserify = require('browserify')
source = require('vinyl-source-stream')
coffeeify = require('coffeeify')
babelify = require('babelify')
watchify = require('watchify')
envify   = require('envify/custom')

handleErrors = require('../utils/handleErrors')
bundleLogger = require('../utils/bundleLogger')
nameLogger   = require('../utils/nameLogger')

env  = require('../env')
config = require('../config').browserify
global_config = require('../config')
debug = require('../debug')

# Related to
#https://github.com/callemall/material-ui/tree/master/examples/browserify-gulp-example


# 主にjsxのコンパイル
gulp.task 'browserify', (cb)->
  queueNum = config.bundleConfigs.length

  browserifyThis = (bundleConfig)->
    bundler = browserify({
      cache: {}, packageCache: {}, fullPaths: false,
      entries: bundleConfig.entries,
      extensions: config.extensions,
      debug: config.debug,
      bundleExternal: ! config.debug
    })

    bundle = ()->
      bundleLogger.start(bundleConfig.outputName)
      bundler
      .bundle()
      .on('error', handleErrors)
      .pipe( source(bundleConfig.outputName) )
      .pipe( nameLogger() )
      .pipe( gulp.dest(bundleConfig.dest) )
      .on('end', reportFinished )

    #if config.debug
    #  console.log('browserify:debugExternal', config.debugExternal)
    #  bundler.external( config.debugExternal )

    bundler.transform(coffeeify, bare:true)
    .transform(babelify.configure())
    .transform(
      envify(
        NODE_ENV:         env.name
        PROGRAM_VERSION:  global_config.packageJson.version
        PROGRAM_REVISION: env.revision
      )
    )
    #.transform({global: true}, 'uglifyify')

    if global.isWatching
      bundler.plugin(watchify)
      bundler.on('update', bundle)

    reportFinished = ()->
      bundleLogger.end(bundleConfig.outputName)
      if queueNum
        queueNum -= 1
        if queueNum == 0
          cb()

    bundle()

  config.bundleConfigs.forEach(browserifyThis)
