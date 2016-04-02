gulp = require('gulp')
$    = require('gulp-load-plugins')()
del  = require('del')

env  = require('../env')
config = require('../config')

{ nameLogger, wrapPlumber } = require('../utils')

gulp.task 'compile:jade', ['clean:compile'], ->
  stream = gulp.src(config.src.jade)
  if config.isWatching
    stream = stream.pipe $.watch(config.src.jade)
  stream.pipe nameLogger()
  .pipe wrapPlumber()
  .pipe $.jade({pretty: true})
  .pipe $.inject( gulp.src( bower(), read: false ), relative: true )
  .pipe gulp.dest(config.app)


gulp.task 'compile:resource', ['clean:compile'], ->
  stream = gulp.src(config.src.resource)
  if config.isWatching
    stream = stream.pipe $.watch(config.src.resource)
  stream.pipe nameLogger()
  .pipe wrapPlumber()
  .pipe gulp.dest(config.app)


gulp.task 'compile', ['compile:jade', 'compile:resource']
