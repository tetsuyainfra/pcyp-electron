process = require('process')

if process.env.NODE_ENV == 'development'
  console.log('[mode is development]')
  global.DEBUG = true
  try
    global.connect = require('electron-connect').client.create(sendBounds: false)
  catch error
    console.log "can't create electron-connect.client"
    console.log error
else
  console.log('[mode is production]')
