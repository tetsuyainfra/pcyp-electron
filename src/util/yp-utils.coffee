# electron
app = require('electron').app

# lib
request = require('request')
util    = require('util')

# app
logger = require './logger'
ChannelInfo = require './channel-info'



##
# @public {Array}
# @param {String} url
# @param {Function} callback
# @param {Function} errror_callback
#
getYp = (url, cb, error_cb) ->
  option =
    url: url
    headers:
      "User-Agent": "#{app.getName()} v#{app.getVersion()}"

  logger.trace 'request option', option
  request option, (error, response, body) ->
    logger.trace 'requested'
    instances = []
    if !error && response.statusCode == 200
      lines = body.match /[^\r\n]+/g
      lines.map (line) ->
        o = ChannelInfo.from_line(line)
        instances.push o
    else
      logger.trace "request is failed, #{error}"
      logger.trace("response.statusCode: #{response.statusCode}") if response?.statusCode?
      error_cb(response)

    logger.trace "ChannelInfo.length", instances.length
    cb(instances)
  return

##
#  @param {Array.<String>} urlのリスト
#  @param {Function(Array.<ChannelInfo>)} callback 結果を受け取るコールバック関数
#  @param {Function(Error)} error_cb エラーを受け取るコールバック関数
getYPs_Promise = (urls, callback, error_cb) ->
  promises = urls.map((u) ->
    curried = getYp.bind(null,u)
    () -> new Promise(curried)
  )

  result = []
  concatChannel = (channels) ->
    #logger.trace("ret inspect", util.inspect(channels, showHidden:true, depth: 1))
    result = result.concat(channels) # スコープ外に保存しておく
    return result # 呼ばれるたびにその時点での結果を返す

  retval = promises.reduce((prevProm, curProm) ->
    return prevProm.then(curProm).then(concatChannel)
  , Promise.resolve())

  return retval.then(callback).catch(error_cb)


module.exports = {
  getYp: getYp
  getYPs: getYPs_Promise
}
