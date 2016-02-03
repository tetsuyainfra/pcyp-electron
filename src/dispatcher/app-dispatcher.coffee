# electron
ipc = require('electron').ipcMain

# lib
_            = require('lodash')
Dispatcher   = require('flux').Dispatcher

# app
{ActionTypes} = require('../constants/app-constants')
logger        = require('../util/logger')


class AppDispatcher extends Dispatcher
  # new instance
  constructor: () ->
    super()
    #console.log('constructor')
    #console.log ActionTypes
    # ipc.on ActionTypes.IPC_EVENT, ((event, action) ->
    #   logger.trace event.sender.getId(), action.type
    #   #logger.trace event, arg
    #   #console.log event.sender.getId()
    #   this.dispatch(action)
    # ).bind(@)
    #ipc.on 'event', (ev, action, payload, opts, browser_id) =>
    #  this.dispatch(action, payload, opts, browser_id)

  # dispatch info
  # dispatch: (action, payload, opts, browser_id) ->
  #   browser_id = browser_id || 'node'
  #   _.each(global.application.windows, (window, window_id) ->
  #     if window_id != browser_id
  #       window.browserWindow.webContents.send('event', action, payload, opts, browser_id)
  #   )

# dispatcher instance
module.exports = new AppDispatcher()
