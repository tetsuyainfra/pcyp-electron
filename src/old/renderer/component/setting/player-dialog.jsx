// lib
import {FlatButton, RaisedButton, IconButton, FloatingActionButton} from 'material-ui';
import {Dialog} from 'material-ui';
import {TextField} from 'material-ui';


const PlayerDialog = React.createClass({
  propTypes: {
    addPlayer : React.PropTypes.func.isRequired
  },
  getInitialState: function(){
    return {
      open: 'open' in this.props ? this.props.open : false,
      ext: "",
      exe_path: "",
      command: "",
    };
  },
  dialogClose: function(evt){
    this.setState({open: false});
  },
  addPlayer: function(evt){
    console.log("addPlayer");
    this.props.addPlayer({});
    this.setState({open: false});
  },
  render: function(){
    return (
      <Dialog title="プレイヤーの追加"
       actions={[
         <FlatButton label="Cancel" onTouchTap={this.dialogClose}/>,
         <FlatButton label="OK" onTouchTap={this.addPlayer}/>,
       ]}
       open={this.state.open}
       modal={false}
       onRequestClose={this.dialogClose}
      >
        <TextField hintText="拡張子" />
        <TextField hintText="実行ファイルのパス" fullWidth={true} />
        <TextField hintText="コマンド" fullWidth={true}/>
      </Dialog>
    );
  },
});

module.exports = PlayerDialog
