
gutil = require('gulp-util')
prettyHrTime = require('pretty-hrtime')

startTime = 0

module.exports = {
  start: (filepath) ->
    startTime = process.hrtime()
    gutil.log('Bundling', gutil.colors.green(filepath)+ '...')

  end:   (filepath) ->
    taskTime = process.hrtime(startTime)
    prettyTime = prettyHrTime(taskTime)
    gutil.log('Bundled', gutil.colors.green(filepath), 'in', gutil.colors.magenta(prettyTime))

  createLogger: () ->
    dat = new Object()
    start = (filepath) ->
      this.startTime = process.hrtime()
      gutil.log('Bundling', gutil.colors.green(filepath)+ '...')

    end = (filepath) ->
      this.taskTime = process.hrtime(this.startTime)
      prettyTime = prettyHrTime(this.taskTime)
      gutil.log('Bundled', gutil.colors.green(filepath), 'in', gutil.colors.magenta(prettyTime))

    return {
      start: start.bind(dat)
      end:   end.bind(dat)
    }
}
