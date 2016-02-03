#
# gulpfile.coffee
#
gulp = require('gulp')

# read task files
requireDir = require 'require-dir'
requireDir "./gulp/tasks", { recurse: true }

gulp.task 'default', ['compile']
