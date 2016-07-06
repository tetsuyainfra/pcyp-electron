
keyMirror = require('keymirror');

# /*
# module.exports = {
#   ActionTypes: keyMirror({
#     RECEIVE_TRACKS_BY_ARTIST: null,
#     RECEIVE_TRACKS_BY_COUNTRY: null
#   }),
#   PayloadSources: keyMirror({
#     VIEW_ACTION: null
#   })
# };
# */

module.exports = {
  ActionTypes: keyMirror(
    APP_INIT : null

    IPC_EVENT: null        # 非同期のIPCイベント
    SYNC_IPC_EVENT: null        # 同期するIPCイベント

    CRAWL_YP : null        # YPのクローリング
    FAILED_CRAWL_YP: null  # クローリングに失敗した
    BROADCAST_CHANNELS: null   # チャンネル情報の配信

    CONFIG_WINDOW_OPEN: null   # CONFIG_WINDOWを開く指示
    CONFIG_WINDOW_OPENED: null # CONFIG_WINDOWが開いた
    CONFIG_WINDOW_CLOSED: null # CONFIG_WINDOWが閉じた

    CONFIG_LOAD:   null        # CONFIGを保存する (renderer -> main)
    CONFIG_SAVE:   null        # CONFIGを保存する (renderer -> main)
    CONFIG_UPDATED: null       # CONFIGが更新された (main -> renderer)

    PLAY_CHANNEL: null         # 動画を表示する
  )
  PayloadSources: keyMirror(
    DATA: null
    URL:  null
    VIEW_ACTION: null
  )
  IGNORE_ID: '00000000000000000000000000000000'
  IGNORE_BROADCAST_TIME: '0:00'
}
