
gulp = require('gulp')
del  = require('del')
config = require('../config')

gulp.task 'clean:compile', (cb) ->
  del.sync(["#{config.APP}/*"])
  cb()

gulp.task 'clean:doc', (cb) ->
  del.sync(["#{config.src.doc}/*"])
  cb()


gulp.task 'clean:packaging', (cb) ->
  del.sync([config.BUILD, config.DIST])
  cb()

gulp.task 'clean',   ['clean:compile', 'clean:doc', 'clean:packaging']
