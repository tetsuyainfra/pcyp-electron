gulp = require('gulp')
$    = require('gulp-load-plugins')()
gutil    = require('gulp-util')

config = require('../config')

gulp.task 'watch:set_watch', (cb)->
  config.isWatching = true
  gutil.log('config.isWatching', gutil.colors.green(config.isWatching))
  cb()

gulp.task 'watch:jade',       ['watch:set_watch', 'compile:jade']
gulp.task 'watch:resource',   ['watch:set_watch', 'compile:resource']
gulp.task 'watch:doc',        ['watch:set_watch', 'doc:generate']

#gulp.task 'watch:test',        ['watch:set_watch', 'test']
# task for test
gulp.task 'watch:test', () ->
  gulp.watch config.src.coffee, ['test']

gulp.task 'watch',
    [
      'watch:jade',
      'watch:resource',
      'watch:doc',
    ]
