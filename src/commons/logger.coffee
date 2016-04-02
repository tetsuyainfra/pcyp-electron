log4js = require 'log4js'

log4js.configure('log4js.json',{})

#log4js.loadAppender('file')
#log4js.loadAppender('logstashUDP')

#filename = 'pcyp-electron.log'
#log4js.addAppender(log4js.appenders.file("logs/#{filename}"), 'default')
logger = log4js.getLogger('default')

#logger.setLevel('ERROR')

module.exports = logger

if require.main == module
  console.log "main"
  logger.debug('debug message')
  logger.error('error')
  logger.trace 'trace'
