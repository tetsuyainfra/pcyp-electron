through  = require('through2')
gutil    = require('gulp-util')
PluginError = gutil.PluginError

PLUGIN_NAME = 'gulp-namelogger';

prefixStream = (prefixText) ->
  stream = through()
  stream.write(prefixText)
  return stream

module.exports = (options) ->
  transform = (file, error, callback) ->
    if file.isNull()
      console.log('isnull')
    #   return cb(null, file)
    if file.isBuffer()
      gutil.log('processing ', gutil.colors.green(file.path))

    if file.isStream()
      gutil.log('processing ', gutil.colors.green(file.path))
      # return callback(new PluginError(PLUGIN_NAME, 'Stream is not supported'));

    callback(null, file)

  # 処理の一番最後に呼ばれる
  flush     = (callback) ->
    callback()

  return through.obj(transform, flush)
