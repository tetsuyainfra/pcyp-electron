gulp = require('gulp')
$    = require('gulp-load-plugins')()
envify= require('envify/custom')
gutil    = require('gulp-util')
reporters = require('jasmine-reporters')

env  = require('../env')
config = require('../config')

{ nameLogger, wrapPlumber } = require('../utils')

# gulp.task 'compile:coffee', ['clean:compile'], ->
#   stream = gulp.src(config.src.coffee)
#   if config.isWatching
#     stream = stream.pipe $.watch(config.src.coffee)
#   stream.pipe nameLogger()
#   .pipe wrapPlumber()
#   .pipe $.coffee({bare: true})
#   .pipe $.envify( {NODE_ENV: env.name} )
#   .pipe gulp.dest(config.app)

gulp.task 'test:coffee', (cb) ->
  gulp.src(config.test.target)
  .pipe $.jasmine(
    reporter: new reporters.TerminalReporter(
      color: true
      verbosity: 3
      showStack: true
    )
  )

gulp.task 'test', ['test:coffee']
