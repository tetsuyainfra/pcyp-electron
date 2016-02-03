#--------------------------------------------------
# environment setting
#--------------------------------------------------
minimist  = require('minimist')
$         = require('gulp-load-plugins')()
exec      = require('child_process').execSync

knownOptions = {
  string : 'env',
  default: { env: process.env.NODE_ENV || 'development' }
}
options      = minimist( process.argv.slice(2), knownOptions)
isProduction = (options.env == 'production') ? true : false

$.util.log('[NODE_ENV]', $.util.colors.yellow(process.env.NODE_ENV));
$.util.log('[env]', $.util.colors.yellow(options.env), '[isProduction]', $.util.colors.yellow(isProduction));

#
revision = exec('git rev-parse HEAD').utf8Slice().split('\n').join('')
$.util.log('[git revision]', $.util.colors.yellow(revision))

module.exports = {
  name: knownOptions.default.env
  isProduction: isProduction
  revision: revision
}
