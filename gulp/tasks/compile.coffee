gulp = require('gulp')
$    = require('gulp-load-plugins')()
del  = require('del')
bower= require('main-bower-files')
envify= require('envify/custom')

env  = require('../env')
config = require('../config')
debug = require('../debug')

{wrapPlumber} = require('../utils/wrapPlumber')
nameLogger    = require('../utils/nameLogger')

lessdir = ->
  dirs = []
  for p in bower({filter: "**/*.less"})
    dir = require('path').dirname(p)
    dirs.push(dir) unless dir in dirs
  dirs

gulp.task 'compile:jade', ->
  gulp.src config.src.jade
  .pipe wrapPlumber()
  .pipe $.jade({pretty: true})
  .pipe $.inject( gulp.src(bower(), read: false), relative: true )
  .pipe gulp.dest( config.APP )

# debug用に残しておく
gulp.task 'compile:jsx', ->
  gulp.src config.src.jsx
  .pipe wrapPlumber()
  .pipe $.babel()
  .pipe $.envify( {NODE_ENV: env.name} )
  .pipe gulp.dest( config.APP )

gulp.task 'compile:less', ->
  gulp.src "#{config.src.root}/**/*.less"
  .pipe wrapPlumber()
  .pipe $.inject( gulp.src(bower(), read:false), relative: true )
  .pipe $.less(paths: lessdir())
  .pipe gulp.dest( config.APP )

gulp.task 'compile:coffee', ->
  gulp.src config.src.coffee
  .pipe nameLogger()
  .pipe wrapPlumber()
  .pipe $.coffee({bare: true})
  .pipe $.envify( {NODE_ENV: env.name} )
  .pipe gulp.dest( config.APP )

gulp.task 'compile:copy_resource', ->
  gulp.src config.src.resource
  .pipe wrapPlumber()
  .pipe gulp.dest( config.APP )

gulp.task 'compile:copy_bower_resource', ->
  font_filter= $.filter ["**/*webfont*", "**/Font*", "**/glyphicons-*"], restore: true
  gulp.src bower(), base: "bower_components"
  .pipe font_filter
  .pipe $.flatten({includeParents:-1})
  .pipe gulp.dest( "#{config.APP}/styles" )

gulp.task 'compile',
  $.sequence 'clean:compile', ['compile:jade', 'browserify', 'compile:coffee', 'compile:less', 'compile:copy_resource', 'compile:copy_bower_resource']


#console.log bower()
