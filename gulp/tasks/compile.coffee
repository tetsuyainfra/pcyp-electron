gulp = require('gulp')
$    = require('gulp-load-plugins')()
del  = require('del')
bower= require('main-bower-files')
envify= require('envify/custom')

env  = require('../env')
config = require('../config')

{ nameLogger, wrapPlumber } = require('../utils')

lessdir = ->
  dirs = []
  for p in bower({filter: "**/*.less"})
    dir = require('path').dirname(p)
    dirs.push(dir) unless dir in dirs
  dirs

gulp.task 'compile:jade', ['clean:compile'], ->
  stream = gulp.src(config.src.jade)
  if config.isWatching
    stream = stream.pipe $.watch(config.src.jade)
  stream.pipe nameLogger()
  .pipe wrapPlumber()
  .pipe $.jade({pretty: true})
  .pipe $.inject( gulp.src( bower(), read: false ), relative: true )
  .pipe gulp.dest(config.app)


# debug用に残しておく
gulp.task 'compile:jsx', ['clean:compile'], ->
  stream = gulp.src(config.src.jsx)
  if config.isWatching
    stream = stream.pipe $.watch(config.src.jsx)
  stream.pipe nameLogger()
  .pipe wrapPlumber()
  .pipe $.babel()
  .pipe $.envify( {NODE_ENV: env.name} )
  .pipe gulp.dest(config.app)


gulp.task 'compile:less', ['clean:compile'], ->
  stream = gulp.src(config.src.less)
  if config.isWatching
    stream = stream.pipe $.watch(config.src.less)
  stream.pipe nameLogger()
  .pipe wrapPlumber()
  .pipe $.inject( gulp.src(bower(), read:false), relative: true )
  .pipe $.less(paths: lessdir())
  .pipe gulp.dest(config.app)


gulp.task 'compile:coffee', ['clean:compile'], ->
  stream = gulp.src(config.src.coffee)
  if config.isWatching
    stream = stream.pipe $.watch(config.src.coffee)
  stream.pipe nameLogger()
  .pipe wrapPlumber()
  .pipe $.coffee({bare: true})
  .pipe $.envify( {NODE_ENV: env.name} )
  .pipe gulp.dest(config.app)


gulp.task 'compile:resource', ['clean:compile'], ->
  stream = gulp.src(config.src.resource)
  if config.isWatching
    stream = stream.pipe $.watch(config.src.resource)
  stream.pipe nameLogger()
  .pipe wrapPlumber()
  .pipe gulp.dest(config.app)


gulp.task 'compile:copy_bower_resource', ['clean:compile'], ->
  font_filter = $.filter( ["**/*webfont*", "**/Font*", "**/glyphicons-*"], restore: true )
  gulp.src bower(), base: "bower_components"
  .pipe font_filter
  .pipe $.flatten({ includeParents: -1 })
  .pipe gulp.dest( "#{config.app}/styles" )


gulp.task 'compile', ['compile:jade', 'browserify', 'compile:coffee', 'compile:less', 'compile:resource', 'compile:copy_bower_resource']


#console.log bower()
