logger        = require('../util/logger')

AppDispatcher = require('../dispatcher/app-dispatcher')
EventEmitter  = require('events').EventEmitter
{ActionTypes, PayloadSources} = require('../constants/app-constants')
AppActionCreator = require '../actions/app-action-creator'

CHANGE_EVENT = 'change'

# 初期設定の読み込み
loadConfig = (config) ->
  logger.trace config


# 外部に公開する実装
AppStore = Object.assign({}, EventEmitter.prototype, {
  emitChange: ()->
    this.emit CHANGE_EVENT

  addChangeListener: (cb) ->
    this.on CHANGE_EVENT, cb

  removeChangeListener: (cb) ->
    this.removeListener CHANGE_EVENT, cb

  getAllForYP: (yp) ->
    yp_channels = {}
    for c in _channels
      if c.yp? == yp
        s.push c
    yp_channels
})


AppStore.dispatchToken = AppDispatcher.register (action) ->
  logger.trace 'AppStore.dispatchToken', action.type
  switch action.type
    when ActionTypes.APP_INIT
      logger.trace 'APP_INIT'
    when ActionTypes.RELOAD_YP
      logger.trace 'RELOAD_YP'
      yp = 'http://temp.orz.hm/yp/index.txt'
      getYp(yp ,
        (chs)-> AppActionCreator.addChannelsToStore(chs),
        null
      )
    when ActionTypes.CRAWL_YP
      logger.trace 'CRAWL_YP'
    else
      logger.trace 'UNKNOW dispatch token'

  return

module.exports = AppStore
