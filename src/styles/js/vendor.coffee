
if process.env.NODE_ENV == 'development'
  console.log('[mode is development]')
  global.DEBUG = true
  try
    require('electron-connect').client.create(sendBounds: false)
  catch error
    console.log "can't create electron-connect.client"
    console.log error
else
  console.log('[mode is production]')

this.React = require('react')
this.ReactDOM = require('react-dom')
this.injectTapEventPlugin = require('react-tap-event-plugin')

this.injectTapEventPlugin()
