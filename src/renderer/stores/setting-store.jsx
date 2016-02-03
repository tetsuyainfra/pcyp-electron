import _ from 'lodash';

var ipc = require('electron').ipcRenderer;

var SettingDispatcher = require('../dispatcher/setting-dispatcher');
var EventEmitter = require('events').EventEmitter;
var {ActionTypes} = require('../constants/setting-constants');

var CHANGE_EVENT = 'change';

var _settings = {};

function load_config(config){
  _.each(config.player.user_players, function(e, idx){
    e.id = idx;
  });
  //console.log('load_config', config);
  _settings = config;
}

function update_setting(key, data){
  console.log('update_setting:', key, data );
  _.set(_settings, key, data);
}


var SettingStore = Object.assign({}, EventEmitter.prototype, {
  /**
   * Get the entire collection of TODOs.
   * @return {object}
   */
  getAll: function() {
    return _settings;
  },

  getByName: function(name){
    return _settings[name];
  },

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
  }
});


// Register callback to handle all updates
SettingDispatcher.register(function(action) {
  switch(action.type) {
    case ActionTypes.CONFIG_LOAD:
      var config = ipc.sendSync(ActionTypes.SYNC_IPC_EVENT, action);
      load_config(config);
      break;

    case ActionTypes.CONFIG_SAVE:
      ipc.send(ActionTypes.IPC_EVENT, action);
      break;

    default:
      // no op
  }
});

module.exports = SettingStore;
