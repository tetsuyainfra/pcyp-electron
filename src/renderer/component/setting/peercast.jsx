
// lib
import _ from 'lodash';

import {List, ListItem, Toggle, TextField, Divider} from 'material-ui';
import {RaisedButton} from 'material-ui';

import ActionInfo from 'material-ui/lib/svg-icons/action/info';
import {FileFolder} from 'material-ui/lib/svg-icons';
import FontIcon from 'material-ui/lib/font-icon';
import Colors from 'material-ui/lib/styles/colors';

// app
import SettingActions from '../../actions/setting-actions';
import SettingStore from '../../stores/setting-store';

const getDefaultSettings = function(){
  return _.merge({is_changed: false}, SettingStore.getByName("peercast"));
}

const PeerCast = React.createClass({
  propTypes: {
    onConfigChange: React.PropTypes.func.isRequired,
  },

  getInitialState: function(){
    return getDefaultSettings();
  },

  _handleToggleStartPeca: function(evt){
    this.setState({start_peca: !this.state.start_peca });
    this.onConfigChange(true);
  },
  _handleGetProgramPath: function(){
    const remote = require('electron').remote;
    const app    = remote.require('app');
    const dialog = remote.require('dialog');
    var options = {
      title: 'PeerCast実行ファイルを指定',
      defaultPath: 'c:\\', //app.getPath('userDesktop'),
      filters: [
        {name: 'Execution', extensions: ['exe']}
      ],
      properties: ['openFile', 'multiSelections', 'createDirectory']
    };
    var win = remote.getCurrentWindow()
    dialog.showOpenDialog(win, options, (function(arg){
      console.log(arg);
      console.log(this);
      if (arg == null){ return; }
      this.setState({ exe_path: arg[0] });
      this.onConfigChange(true);
    }).bind(this));
  },
  onConfigChange: function(is_changed){
    this.setState({is_changed: is_changed});
    this.props.onConfigChange("peercast", is_changed);
  },
  _handleRequestClose: function(evt){
    console.log('handleRequestClose', evt);
  },

  setDefault: function(){
    this.setState(getDefaultSettings());
    this.onConfigChange(false);
  },
  render: function() {
    return (
      <div className="peercast_page">
        <List>
          <ListItem primaryText="pcyp起動時にPecaを起動する"
            secondaryText="※再起動後に有効化"
            rightToggle={
              <Toggle toggled={this.state.start_peca} onToggle={this._handleToggleStartPeca} />
            }
            initiallyOpen={true}
            primaryTogglesNestedList={true}
            nestedItems={[
              <ListItem key={1}
                primaryText={this.state.exe_path}
                secondaryText="実行ファイル(exe)へのパス"
                rightIcon={<FileFolder onTouchTap={this._handleGetProgramPath}/>}
              />,
            ]}
          />
        </List>
        <Divider />
        <List subheader="接続先設定">
          <ListItem
            primaryText={this.state.hostname}
            secondaryText="ホスト名"
          />,
          <ListItem
            primaryText={this.state.port}
            secondaryText="ポート番号"
          />
        </List>
        <div className="btn-container" style={{textAlign: 'right'}}>
          <RaisedButton label="元に戻す" disabled={!this.state.is_changed} onTouchTap={this.setDefault}/>
          <RaisedButton label="保存"  disabled={this.state.is_changed} onTouchTap={this.setDefault}/>
        </div>
      </div>
    );
  }
});

module.exports = PeerCast;
