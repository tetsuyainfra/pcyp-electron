process.env.VLC_PLUGIN_PATH = require('wcjs-prebuilt').vlc_plugin_path

electron      = require('electron')  # Module to control application life.
app           = electron.app
BrowserWindow = electron.BrowserWindow
crashReporter = electron.crashReporter
ipcMain       = electron.ipcMain
spawn         = require 'cross-spawn'

logger        = require('./util/logger')
AppStore      = require('./stores/app-store')
ChannelStore  = require('./stores/channel-store')

{ActionTypes} = require './constants/app-constants'
{getYp, getYPs} = require './util/yp-utils'
{getArgs}     = require './util/external-player'
PcypConfig    = require './util/pcyp-config'
win32api     = require './util/win32api'

try
  if process.env.NODE_ENV == "development"
    connect_client = require('electron-connect').client
catch e
  logger.warning "can't require electron-connect client"

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

      if connect_client?
        connect_client.create().socket.on('error', (err) ->
          logger.error "electron-connect CONNECTION ERROR", err
        )


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
              #useContentSize: true
              # border-width = 5px
              width: 330, height: 250
              x: 100, y: 100
              frame: false
              show: false
              #fullscreen: true
            )
            win.on 'closed', =>
              logger.trace "playerWindow closed pid: #{process.pid}"
              logger.trace "win :", win
              @_playerWindows.filter((w) ->
                # logger.trace "filter win.id: ", win.id
                # logger.trace "filter   w.id: ",   w.id
                return w is win
               )
              logger.trace '@_playerWindows.length:', @_playerWindows.length
            win.on 'enter-full-screen', =>
              logger.trace "playerWindow enter fullscreen pid: #{process.pid}"
            enc_url = encodeURIComponent(spawn_args[1][0])
            win.loadURL("file://#{__dirname}/renderer/player.html?url=#{enc_url}")
            @_playerWindows.push(win)
            logger.trace 'win.id:', win.id
            logger.trace '@_playerWindows.length:', @_playerWindows.length
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
    logger.info "process.argv:",        process.argv
    logger.info "process.arch:",        process.arch
    logger.info "process.versions:",    process.versions
    logger.info "PcypApp.start(argv):", argv


    #new PcypApp(argv)
    new PcypApplication(argv)

  version: app.getVersion()
