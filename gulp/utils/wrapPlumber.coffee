gulp = require('gulp')
$    = require('gulp-load-plugins')()

wrapPlumber = ->
  $.plumber({
    errorHandler: (err) ->
      if err.plugin == 'gulp-coffee'
        $.notify.onError({
          message: "#{err.plugin}\n#{err.stack}",
          sound: false
        })(err)
      else
        console.log(err)
        $.notify.onError({
          message: "Error: <%= error %> <%= error.message %>",
          sound: false
        })(err)
  })

module.exports = {
  wrapPlumber: wrapPlumber
}
