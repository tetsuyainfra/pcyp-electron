# lib
_             = require 'lodash'

# app
logger        = require('../util/logger')

AppDispatcher = require('../dispatcher/app-dispatcher')
EventEmitter  = require('events').EventEmitter
{ActionTypes, PayloadSources, IGNORE_ID, IGNORE_BROADCAST_TIME} = require('../constants/app-constants')

CHANGE_EVENT = 'change'

_channels = []

# 外部に公開する実装
ChannelStore = Object.assign({}, EventEmitter.prototype, {
  emitChange: ()->
    this.emit CHANGE_EVENT

  addChangeListener: (cb) ->
    logger.trace 'addChangeListener', cb
    this.on CHANGE_EVENT, cb

  removeChangeListener: (cb) ->
    logger.trace 'removeChangeListener', cb
    this.removeListener CHANGE_EVENT, cb

  get: (id)->
    for ch in _channels
      if ch.id == id
        return ch
    return


  getAll: ()->
    _channels

  getChannels: ()->
    chs = []
    for ch in _channels
      if ch.id != IGNORE_ID and ch.broadcast_time != IGNORE_BROADCAST_TIME
        chs.push ch
    chs
})

_addChannels = (channels) ->
  logger.trace '_channels.length', _channels.length
  _channels = channels
  logger.trace '_channels.length', _channels.length

ChannelStore.dispatchToken = AppDispatcher.register (action) ->
  logger.trace 'ChannelStore.dispatchToken', action.type
  switch action.type
    when ActionTypes.ADD_CHANNELS
      logger.trace "ChannelStore ADD_CHANNELS"
      _addChannels action.data
      ChannelStore.emitChange()
    else
      logger.trace 'UNKNOW dispatch token'

  return

module.exports = ChannelStore
