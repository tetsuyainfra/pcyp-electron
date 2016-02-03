
AppDispatcher = require '../dispatcher/app-dispatcher'
{ActionTypes, PayloadSources} = require '../constants/app-constants'
logger        = require('../util/logger')


class AppActionCreator
  @execInitialize: () ->
    logger.trace "AppActionCreator.execInitialize()"
    AppDispatcher.dispatch {
      type: ActionTypes.APP_INIT
      payload_type: PayloadSources.DATA
      data: 'hello world'
    }

  @crawlYP: (url) ->
    logger.trace "AppActionCreator.getYP(#{url})"
    AppDispatcher.dispatch {
      type: ActionTypes.CRAWL_YP
      payload_type: PayloadSources.URL
      data: url.toString()
    }

  @addChannelsToStore: (channels) ->
    logger.trace "AppActionCreator.addChannelsToStore(#{channels.length})"
    AppDispatcher.dispatch {
      type: ActionTypes.ADD_CHANNELS
      payload_type: PayloadSources.DATA
      data: channels
    }

  @broadcastChannels: (browser_window, channels) ->
    logger.trace "AppActionCreator.recieveChannels(#{channels.length})"
    opt = {
      type: ActionTypes.BROADCAST_CHANNELS
      payload_type: PayloadSources.DATA
      data: channels
    }
    browser_window.webContents.send(ActionTypes.IPC_EVENT, opt)

module.exports = AppActionCreator
