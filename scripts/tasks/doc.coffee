gulp = require('gulp')
$    = require('gulp-load-plugins')()

config = require('../config')
{ wrapPlumber, nameLogger } = require('../utils')

gulp.task 'doc:generate', ['clean:doc'], ->
  stream = gulp.src(config.doc.src)
  if config.isWatching
    stream = stream.pipe $.watch(config.doc.src)

  stream.pipe nameLogger()
  .pipe wrapPlumber()
  .pipe $.markdown()
  .pipe gulp.dest(config.doc.dest)
