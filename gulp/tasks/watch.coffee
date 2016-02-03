gulp = require('gulp')
$    = require('gulp-load-plugins')()
del  = require('del')

env  = require('../env')
config = require('../config')

#gulp.task 'watch:jsx', ->
#  $.watch config.src.jsx, ->
#    gulp.start("compile:jsx")

gulp.task 'watch:set_watch', ->
  global.isWatching = true

gulp.task 'watch:browserify', ->
  gulp.start('browserify')

gulp.task 'watch:less', ->
  $.watch config.src.less, ->
    gulp.start("compile:less")

gulp.task 'watch:jade', ->
  $.watch config.src.jade, ->
    gulp.start("compile:jade")

gulp.task 'watch:coffee', ->
  $.watch config.src.coffee, ->
    gulp.start('compile:coffee')

gulp.task 'watch:doc', ->
  $.watch config.doc.src, ->
    gulp.start("doc")

gulp.task 'watch', ['watch:set_watch', 'watch:coffee', 'watch:jade', 'watch:browserify', 'watch:less', 'watch:doc']
