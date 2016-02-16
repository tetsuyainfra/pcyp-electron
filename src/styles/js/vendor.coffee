
if process.env.NODE_ENV == 'development'
  console.log('[mode is development]')
  global.DEBUG = true
  try
    global.connect = require('electron-connect').client.create(sendBounds: false)
    # global.connect.on('RELOAD_APP', (opt) ->
    #   console.log('RELOAD_APP', opt)
    # )
  catch error
    console.log "can't create electron-connect.client"
    console.log error
else
  console.log('[mode is production]')

this.React = require('react')
this.ReactDOM = require('react-dom')
this.injectTapEventPlugin = require('react-tap-event-plugin')

this.injectTapEventPlugin()
