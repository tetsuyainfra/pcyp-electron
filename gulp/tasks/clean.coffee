
gulp = require('gulp')
del  = require('del')
config = require('../config')

gulp.task 'clean:compile', ->
  del(["#{config.APP}/*"])


gulp.task 'clean:electron', ->
  del([config.BUILD, config.DIST])

gulp.task 'clean',   ['clean:electron', 'clean:compile']
