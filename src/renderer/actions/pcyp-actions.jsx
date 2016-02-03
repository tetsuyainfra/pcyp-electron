
const Dispatcher = require('../dispatcher/pcyp-dispatcher');
const {ActionTypes} = require('../constants/pcyp-constants');


const PcypActions = {

  /**
  * ypを読み込む指示を出す
  */
  crawl_yp : () => {
    Dispatcher.dispatch({
      type: ActionTypes.CRAWL_YP
    });
  },

  /**
  * config windowを開く指示を出す
  */
  open_config_window: () => {
    Dispatcher.dispatch({
      type: ActionTypes.CONFIG_WINDOW_OPEN
    });
  },

  /**
  *
  */
  play_channel: (ch_info) => {
    Dispatcher.dispatch({
      type: ActionTypes.PLAY_CHANNEL,
      data: ch_info,
    });
  },

};

module.exports = PcypActions
