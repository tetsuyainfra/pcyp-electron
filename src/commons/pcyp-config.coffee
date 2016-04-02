#
_     = require('lodash')
fs    = require('fs')
Path  = require('path')
keymirror = require('keymirror')

# electron
app = require('electron').app

# app
logger = require('./logger')

# 定数
CONFIG_NAME = "pcyp-config.json"

# MEMO
# コンフィグファイルの保存はホワイトリスト形式にした方が良いかもねぇ

class PcypConfig
  CONFIG_MODE = keymirror({
    DEFAULT: null
    APP_LOCAL: null
    USR_LOCAL: null
  })
  CONFIG_PATHS = {
    DEFAULT: Path.join(app.getAppPath(), 'default.json')
    APP_LOCAL: Path.join(app.getAppPath(), CONFIG_NAME)
    USR_LOCAL: Path.join(app.getPath('appData'), app.getName(), CONFIG_NAME)
  }
  CONFIG_VAR = ["yellow_pages", "peercast", "player", "favorite"]
  constructor: (props) ->
    logger.trace("PcypConfig()", props)
    {@mode, config, force_save} = props
    for k in CONFIG_VAR then  @[k] = config[k]
    @.saveSync() if force_save == true

  stringify: () ->
    config = {}
    for k in CONFIG_VAR then config[k] = @[k]
    config = _.cloneDeep(config)

    config.yellow_pages = _.map(config.yellow_pages, (o) ->
      _.omit(o, ['date'])
    )

    return JSON.stringify( config, null, ' ')

  # async save config file
  save: (cb, error_callback) ->
    logger.trace("PcypConfig.save()")
    cb = cb || () ->
    error_callback = error_callback || () ->

    fs.writeFile(CONFIG_PATHS[@mode], @.stringify(), (err) ->
      if (err) then error_callback(err)
      cb()
    )

  # sync save config file
  saveSync: () ->
    logger.trace("PcypConfig.saveSync()")
    file = CONFIG_PATHS[@mode]
    try
      fs.writeFileSync(file , @.stringify())
      logger.info("config file(#{file}) is written")
      return true
    catch
      logger.error("config file(#{file}) couldn't written")
      return false

  @openFile: (file) ->
    try
      logger.trace('open file:', file)
      bytes = fs.readFileSync(file)
      json = JSON.parse(bytes.toString())
      logger.trace('opened json:', json)
      return json
    catch e
      logger.trace('open error')
      return null


  @loadConfig: (props) ->
    # {force_new_config} = props

    for m in [CONFIG_MODE.APP_LOCAL, CONFIG_MODE.USR_LOCAL, CONFIG_MODE.DEFAULT]
      unless config?
        mode = m
        config = @openFile(CONFIG_PATHS[mode])

    # デフォルトファイルから読み込んだ場合保存先を指定
    if mode == CONFIG_MODE.DEFAULT
      force_save = true
      try
        if fs.statSync(CONFIG_PATHS.APP_LOCAL).isFile()
          mode = CONFIG_MODE.APP_LOCAL
      catch e
        mode = CONFIG_MODE.USR_LOCAL

    return new PcypConfig({
      force_save: force_save || false,
      mode: mode
      config: config
    })


module.exports = PcypConfig
