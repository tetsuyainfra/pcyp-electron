process.env.VLC_PLUGIN_PATH = require('wcjs-prebuilt').vlc_plugin_path

electron      = require('electron')  # Module to control application life.
app           = electron.app
BrowserWindow = electron.BrowserWindow
crashReporter = electron.crashReporter
ipcMain       = electron.ipcMain

client        = require('electron-connect').client # to debug

AppStore      = require('./stores/app-store')
ChannelStore  = require('./stores/channel-store')
logger        = require('./util/logger')

{ActionTypes} = require './constants/app-constants'
{getYp, getYPs} = require './util/yp-utils'
{getArgs}     = require './util/external-player'
PcypConfig    = require './util/pcyp-config'

spawn         = require 'cross-spawn'

logger.info "process.argv: ",      process.argv
logger.info "process.arch: ",      process.arch
logger.info "process.versions: ",  process.versions

class PcypApplication
  constructor: (props) ->
    logger.info "ARGV:", props
    {@devMode} = props
    @_mainWindow = null
    @_configWindow = null
    @_playerWindows = []
    @config     = PcypConfig.loadConfig(props)
    @.start()

  start: () ->
    if process.env.NODE_ENV == "development"
      logger.info "global.gc: ", global.gc
      logger.info "start crash-reporter"
      crashReporter.start()

    app.on 'window-all-closed', ->
      logger.info("window-all-closed pid:#{process.pid}")
      if process.platform != 'darwin'
        app.quit()

    app.on 'ready', () =>
      @.create_main_window()

    # async events
    ipcMain.on ActionTypes.IPC_EVENT, ((event, action) =>
      logger.trace "id:#{event.sender.getId()}, action.type:#{action.type}"
      logger.trace "@: #{@}"
      switch action.type
        when ActionTypes.CONFIG_WINDOW_OPEN
          @.create_config_window(()->
            logger.trace "config_window_opened"
            act = {type: ActionTypes.CONFIG_WINDOW_OPENED}
            event.sender.send(ActionTypes.IPC_EVENT, act)
          )
        when ActionTypes.CRAWL_YP
          logger.trace "CRAWL_YP"
          yps = @config.yellow_pages.map((yp) -> yp.url)
          getYPs(yps,
          # getYp(yp1,
            (channels)->
              act = {
                type: ActionTypes.BROADCAST_CHANNELS
                data: channels
              }
              event.sender.send(ActionTypes.IPC_EVENT, act)
            ,(response)->
              act = {
                type: ActionTypes.FAILED_CRAWL_YP
              }
              event.sender.send(ActionTypes.IPC_EVENT, act)
          )
        when ActionTypes.CONFIG_SAVE
          logger.trace "CONFIG_SAVE"

        when ActionTypes.CONFIG_UPDATED
          logger.trace "CONFIG_UPDATED"
          act = {
            type: ActionTypes.UPDATE_CONFIG
            data: @config
          }
          @_mainWindow?.webContents.send(ActionTypes.IPC_EVENT, act)
        when ActionTypes.PLAY_CHANNEL
          logger.trace "PLAY_CHANNEL"
          logger.trace action.data
          spawn_args = getArgs(@config, action.data)
          if @config.player.use_inner_player
            win = new BrowserWindow(
              width: 320, height: 240
              x: 0, y: 0
            )
            win.on 'closed', =>
              logger.trace "mainWindow closed pid: #{process.pid}"
              @_playerWindows.filter((w) ->
                return w is this
              , this)
            enc_url = encodeURIComponent(spawn_args[1][0])
            win.loadURL("file://#{__dirname}/renderer/player.html?url=#{enc_url}")
            @_playerWindows.push(win)
          else
            logger.trace 'getargs', spawn_args
            child = spawn(spawn_args[0], spawn_args[1])
        else
          logger.trace "action.type: UNKWON"
    ) # async events

    # sync events
    ipcMain.on ActionTypes.SYNC_IPC_EVENT, ((event, action) =>
      logger.trace "SYNC_IPC_EVENT id:#{event.sender.getId()}, action.type:#{action.type}"
      logger.trace "@: #{@}"
      event.returnValue = @config
    ) # sync events

  create_main_window: () ->
    logger.trace 'PcypWindow.create_main_window'
    @_mainWindow = new BrowserWindow(
      width: 480, height: 800
      x: 0, y: 0
    )
    @_mainWindow.on 'closed', =>
      logger.trace "mainWindow closed pid: #{process.pid}"
      @_mainWindow = null
    @_mainWindow.on 'page-title-updated', ->
      logger.trace "mainWindow page-title-updated"

    @_mainWindow.loadURL("file://#{__dirname}/renderer/pcyp.html")


  create_config_window: (callback)->
    logger.trace 'PcypWindow.create_setting_window'
    if @_configWindow?
      logger.warn 'PcypApplication._configWindow is available'
      @_configWindow.focus()
      return
    @_configWindow = new BrowserWindow(
      width: 600, height: 800
      x: 100, y: 100
    )
    @_configWindow.on 'closed', =>
      logger.trace "configWindow closed pid: #{process.pid}"
      @_configWindow = null

    @_configWindow.loadURL("file://#{__dirname}/renderer/setting.html")
    callback()


module.exports =
  start: (argv)->
    #new PcypApp(argv)
    new PcypApplication(argv)

  version: app.getVersion()
