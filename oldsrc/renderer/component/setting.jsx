import _ from 'lodash';

import {Tabs, Tab} from 'material-ui/lib/tabs';
import Snackbar from 'material-ui/lib/snackbar';


// app
import PeerCast    from './setting/peercast';
import Player from './setting/player';
import Favorite from './setting/favorite';
import ProgramInfo from './setting/program-info';

import SettingActions from '../actions/setting-actions';
import SettingStore from '../stores/setting-store';

SettingActions.load()

const Settings = React.createClass({
  getInitialState: function(){
    console.log(this);
    var config = _.merge({
      open: false,
      //select_tab: "peercast",
      select_tab: "player",
      peercast:{ is_changed: false },
      player:{ is_changed: false },
      favorite:{ is_changed: false },
      info:{ is_changed: false },
    }, this.props.config);
    return config;
  },

  componentDidMount: function(){
    console.log('Setting mount');
    SettingStore.addChangeListener(this.getSettings);
  },

  componentWillUnMount: function(){
    console.log('Setting unmount');
    SettingStore.removeChangeListener(this.getSettings);
  },

  getSettings: function() {
    console.log('getSettings()', this);
    var setting = SettingStore.getAll();
    console.log('setting: ', setting);
    this.setState(setting);
  },
  _handleTabChange: function(value){
    if (typeof value != "string"){
      return;
    }
    console.log("      now tab", this.state.select_tab);
    console.log("will next tab", value);
    if (this.state[this.state.select_tab].is_changed == true){
      this.setState({
        open:  true,
        select_tab: this.state.select_tab
      });
      return;
    }
    this.setState({select_tab: value});
  },

  _handleConfigChange: function(id, is_changed){
    console.log(id + ' is changed?:', is_changed)
    this.state[id].is_changed = is_changed;
  },

  _handleRequestClose: function(evt){
    this.setState({open: false});
  },

  render: function(){
    var {peercast} = this.state;
    var props = {
      onConfigChange: this._handleConfigChange
    };
    return (
      <div>
      <Tabs className="setting_tabs" onChange={this._handleTabChange} value={this.state.select_tab}>
        <Tab label="PeerCast" value="peercast">
          <PeerCast ref="peercast" {...props} />
        </Tab>
        <Tab label="プレイヤー" value="player">
          <Player ref="player" {...props} />
        </Tab>
        <Tab label="お気に入り" value="favorite">
          <Favorite ref="favorite" {...props} />
        </Tab>
        <Tab label="Info" value="info">
          <ProgramInfo {...props} />
        </Tab>
      </Tabs>
      <Snackbar key="settings_bar"
        open={this.state.open}
        message="設定が保存されていません"
        autoHideDuration={1000}
        onRequestClose={this._handleRequestClose}
       />
      </div>
    );
  }
});

/*
class Settings extends React.Component {
  render() {
    return (
      <div>
        hello world
      </div>
    );
  }
};
*/

// some
ReactDOM.render(
  <Settings config={SettingStore.getAll()} />,
  document.getElementById('app')
);
