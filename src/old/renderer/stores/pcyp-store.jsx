
// electron-connect
var ipc = require('electron').ipcRenderer;

// app
import {EventEmitter} from 'events';
import {ActionTypes}  from'../constants/pcyp-constants';
import PcypDispatcher  from'../dispatcher/pcyp-dispatcher'

var CHANGE_EVENT = "CHANGE_EVENT";

var _channels = [];
var _crawl_yp = 'loading';

var PcypStore = Object.assign({}, EventEmitter.prototype, {

  emitChange: function() {
    this.emit(CHANGE_EVENT);
  },

  /**
   * @param {function} callback
   */
  addChangeListener: function(callback) {
    this.on(CHANGE_EVENT, callback);
  },

  /**
   * @param {function} callback
   */
  removeChangeListener: function(callback) {
    this.removeListener(CHANGE_EVENT, callback);
  },

  getAll: function() {
    return _channels;
  },

  getLoadingStatus: function() {
    return {yp_loading: _crawl_yp};
  }

}); // PcypStore

// Recieve events from main process
ipc.on(ActionTypes.IPC_EVENT, function(event, action){
  PcypDispatcher.dispatch(action)
});


/**
 *
 */
PcypStore.dispatchToken = PcypDispatcher.register(function(action) {
  //console.log(ActionTypes, action);
  switch(action.type) {
    case ActionTypes.CRAWL_YP:
      console.log('PcypDispatcher::' + action.type );
      _crawl_yp = 'loading'
      PcypStore.emitChange();
      ipc.send(ActionTypes.IPC_EVENT, action);
      break;

    case ActionTypes.CONFIG_WINDOW_OPEN:
      console.log('PcypDispatcher::' + action.type );
      ipc.send(ActionTypes.IPC_EVENT, action);
      break;

    case ActionTypes.BROADCAST_CHANNELS:
      console.log('PcypDispatcher::BROADCAST_CHANNELS');
      console.log(action);
      _crawl_yp = 'hide';
      _channels = action.data;
      PcypStore.emitChange();
      break;
    case ActionTypes.PLAY_CHANNEL:
      console.log('PcypDispatcher::PLAY_CHANNEL');
      console.log(action.data);
      ipc.send(ActionTypes.IPC_EVENT, action);
      break;
    default:
      console.log('PcypDispatcher::UNKNOWN TYPE');
      // no op
  }
});


module.exports = PcypStore;
