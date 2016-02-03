


var SettingDispatcher = require('../dispatcher/setting-dispatcher');
var {ActionTypes}     = require('../constants/setting-constants');


var SettingActions = {
  /**
  * @param  {string} text
  */
  load: function() {
    SettingDispatcher.dispatch({
      type: ActionTypes.CONFIG_LOAD
    });
  },

  update_setting: function(key, data){
    SettingDispatcher.dispatch({
      type: ActionTypes.CONFIG_SAVE,
      data: data
    });
  },

};



module.exports = SettingActions;
