import _ from 'lodash';

import {List, ListItem, Divider, Toggle, Checkbox, Paper} from 'material-ui';
import {FlatButton, RaisedButton, IconButton, FloatingActionButton} from 'material-ui';
import {Dialog} from 'material-ui';
import {TextField} from 'material-ui';


import ActionInfo from 'material-ui/lib/svg-icons/action/info';
import {FileFolder, ContentAdd, ContentRemove} from 'material-ui/lib/svg-icons';
import FontIcon from 'material-ui/lib/font-icon';
import Colors from 'material-ui/lib/styles/colors';

import {Table, Column, Cell} from 'fixed-data-table';

// app
import SettingActions from '../../actions/setting-actions';
import SettingStore from '../../stores/setting-store';
import PlayerDialog from './player-dialog';

const getDefaultSettings = function(){
  var config =  _.merge(
    {
      is_changed: false,
      selected:   [],
      dialog_open: false,
    },
    SettingStore.getByName("player")
  );
  config.user_players.map(function(e){
      return e.checked = false;
  });
  return config;
};

const PlayerItem = React.createClass({
  propTypes: {
    checked: React.PropTypes.bool.isRequired,
    ext: React.PropTypes.string.isRequired,
    path: React.PropTypes.string.isRequired,
    command: React.PropTypes.string.isRequired,
    // parents function
    onToggleCheck: React.PropTypes.func.isRequired,
  },
  _onToggleCheck: function(evt){
    this.props.onToggleCheck(this.props.id);
  },
  render: function(){
    return (
      <ListItem
        leftCheckbox={
          <Checkbox defaultChecked={this.props.checked}
                    onCheck={this._onToggleCheck} />
        }
        primaryText={this.props.ext}
        secondaryText={
          <p>
          exe: {this.props.path} <br />
          コマンド: {this.props.command}
          </p>
        }
        secondaryTextLines={2}
      />
    );
  }
});


const Player = React.createClass({
  getInitialState: function(){
    var config = getDefaultSettings();
    config.user_players.map(function(e){
      return e.checked = false;
    });
    return config;
  },
  _handleUsePlayerToggle: function(){
    this.setState({
       use_inner_player: !this.state.use_inner_player
    });
    this.onConfigChange(true);
  },

  _addDialogOpen: function(evt){
    this.refs.player_dialog.setState({open: true});
  },
  _addPlayer: function(player){
    console.log(player);
    var max_id = this.state.user_players.reduce(function(prev, cur){
      return prev < cur.id ? cur.id: prev;
    }, -1);
    console.log("max_id", max_id);
  },
  _handleDelete: function(evt){
    var new_players = this.state.user_players.filter(function(e){
      return !e.checked;
    });
    if (new_players.length != this.state.user_players.length){
      this.setState({
        user_players: new_players
      })
      this.onConfigChange(true);
    }
  },

  _onToggleCheck: function(key){
    var checked_players = this.state.user_players.map(function(e){
        if(e.id == key){ e.checked = !e.checked; }
        return e;
    });
    this.setState({
      user_players: checked_players,
      selected: checked_players.filter(function(e){return e.checked;})
    });
  },
  _createItem: function(e){
    var props = e;
    return (<PlayerItem key={e.id} onToggleCheck={this._onToggleCheck} {...props} />);
  },
  onConfigChange: function(is_changed){
    this.setState({is_changed: is_changed});
    this.props.onConfigChange("player", is_changed);
  },
  setDefault: function(){
    this.onConfigChange(false);
    this.setState(getDefaultSettings());
  },

  updateSetting: function() {
    var {use_inner_player, user_players} = this.state;
    SettingActions.update_setting('player', {
      use_inner_player: use_inner_player,
      user_players: user_players,
    });
  },

  render () {
    var {use_inner_player, user_players} = this.state;
    return (
      <div ref="player_div">
        <List className="player">
          <ListItem
           primaryText="内臓プレイヤーを使う"
           secondaryText="※工事中につき無効"
           rightToggle={
             <Toggle
              defaultToggled={use_inner_player}
              onToggle={this._handleUsePlayerToggle}
             />
           }
          />
        </List>
        <Divider />
        <div style={{position: "absolute", right: 0, padding: "8px"}}>
          <IconButton
           tooltip="選択したプレイヤーを削除"
            tooltipPosition="bottom-center"
           disabled={this.state.selected.length == 0}
           onTouchTap={this._handleDelete}
           >
            <ContentRemove />
          </IconButton>
          <IconButton
            tooltip="プレイヤーを追加"
            tooltipPosition="bottom-left"
            onTouchTap={this._addDialogOpen}
          >
            <ContentAdd />
          </IconButton>
        </div>
        <List ref="player_list" className="player_list"
          subheader="外部プレイヤー" >
          {user_players.map(this._createItem)}
        </List>
        <PlayerDialog ref="player_dialog" addPlayer={this._addPlayer} />

        <div className="btn-container" style={{textAlign: 'right'}}>
          <RaisedButton label="元に戻す"
            primary={true} disabled={!this.state.is_changed}
            onTouchTap={this.setDefault} />
          <RaisedButton label="保存"
            secondary={true} disabled={!this.state.is_changed}
            onTouchTap={this.updateSetting} />
        </div>
      </div>
    );
  }
});

module.exports = Player;
