gulp = require('gulp')
$    = require('gulp-load-plugins')()

env  = require('../env')
config = require('../config')
debug = require('../debug')
moment = require('moment')

gulp.task 'connect', ->
  # ブラウザプロセスでgcを晒す
  #opt = ["--debug", "--js-flags=--expose_gc"]
  opt = ["--js-flags=--expose_gc"]
  connect = require('electron-connect').server.create(path: "#{config.APP}/")

  connect.on 'RELOAD_APP', ->
    console.log 'RELOADING APP'
    connect.restart(opt)

  connect.start(opt)

  #console.log config.dev.browser
  #$.watch(config.dev.browser, () -> electron.restart(opt) )
  gulp.watch(config.dev.browser,
    () -> connect.restart(opt)
  )

  #$.watch(config.dev.renderer, electron.reload)
  gulp.watch(config.dev.renderer,
    connect.reload
  )
