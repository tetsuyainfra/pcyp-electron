gulp = require('gulp')
$    = require('gulp-load-plugins')()
del  = require('del')
bower= require('main-bower-files')

env  = require('../env')
config = require('../config')
debug = require('../debug')
{wrapPlumber} = require('../utils/wrapPlumber.coffee')



gulp.task 'doc', ->
  gulp.src config.doc.src
  .pipe wrapPlumber()
  .pipe $.markdown()
  .pipe gulp.dest(config.doc.dest)
