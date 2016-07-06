#--------------------------------------------------
# environment setting
#--------------------------------------------------
colors    = require('colors/safe')
exec      = require('child_process').execSync
args      = require('yargs')
  .option('env',
    default: process.env.NODE_ENV || 'development'
  ).option('watch',
    default: false
  ).argv

isProduction = (args.env == 'production') ? true : false

console.log('args', colors.yellow(JSON.stringify(args)))
console.log('[NODE_ENV]', colors.yellow(process.env.NODE_ENV))
console.log('[name]', colors.yellow(args.env), '[isProduction]', colors.yellow(isProduction))
console.log('[watch]', colors.yellow(args.watch))

#
revision = exec('git rev-parse HEAD').utf8Slice().split('\n').join('')
console.log('[git revision]', colors.yellow(revision))

module.exports = {
  name: args.env
  isProduction:   isProduction
  revision:       revision
  watch:          args.watch
}
