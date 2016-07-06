gulp = require('gulp')
gutil= require('gulp-util')
$    = require('gulp-load-plugins')()

env  = require('../env')
config = require('../config')
moment = require('moment')

gulp.task 'connect', ->
  # ブラウザプロセスでgcを晒す
  #opt = ["--debug", "--js-flags=--expose_gc"]
  opt = ["--js-flags=--expose_gc"]
  connect = require('electron-connect').server.create(path: "#{config.APP}/")

  connect.on 'RELOAD_APP', ->
    gutil.log('RELOADING APP')
    connect.restart(opt)

  connect.start(opt)

  gutil.log('watch@browser')
  $.watch(config.connect.browser, (file) ->
    gutil.log("electron-connect restart:", file.event, gutil.colors.red(file.path))
    connect.restart(opt)
  )

  gutil.log('watch@renderer')
  $.watch(config.connect.renderer, (file) ->
    gutil.log("electron-connect reload:", file.event, gutil.colors.green(file.path))
    connect.reload()
  )
