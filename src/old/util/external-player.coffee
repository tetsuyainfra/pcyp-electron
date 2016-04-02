

#
# "<stream/> <type/> <channelname/> <contact/>"

_      = require 'lodash'


logger = require './logger'

# PLAYER : ChannelInfo(pcyp-electron)
key_map = {
  stream: "stream_url"
  type  : "file_type"
  channelname: "name"
  contact: "contact_url"
}


getArgs = (config, channel) ->
  {peercast}      = config

  ch = _.cloneDeep(channel)
  ch.stream_url = "http://#{peercast.hostname}:#{peercast.port}/pls/#{ch.id}?tip=#{ch.address}"

  for player in config.player.user_players
    break if ch.file_type == player.ext

  args = []
  player.command.split(/\s+/).map((tag)->
    match = tag.match(/<([^\/]+)\/>/)
    if match?
      s = match[1]
      if s of key_map && key_map[s] of ch
        args.push(ch[key_map[s]])
      else
        logger.error "no match of <#{s}/>"
    else
      args.push(tag)
  )
  [player.path, args]

module.exports = {
  getArgs: getArgs
}
