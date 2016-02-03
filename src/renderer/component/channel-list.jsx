
var React = require('react');

// lib
import ThemeManager from 'material-ui/lib/styles/theme-manager';
import {List, ListItem, Toggle, TextField, Divider, Avatar} from 'material-ui';
import ActionGrade from 'material-ui/lib/svg-icons/action/grade';
import Colors from 'material-ui/lib/styles/colors';

// app
import PcypActions from '../actions/pcyp-actions'
import PcypStore from '../stores/pcyp-store'
import clone from '../util/clone';


//import MyMui    from  '../mui';

function getChannels() {
  return {
    channels: PcypStore.getAll(),
    favorites: []
  };
}

class ChannelList extends React.Component {
  constructor(props){
    super(props);
    console.log(PcypStore);
    this.state = getChannels();
    this._onChange = this._onChange.bind(this); // extendsだとthisをbindしないと外部から参照出来ない
  }
  componentDidMount(){
    console.log('componentDidMount');
    PcypStore.addChangeListener(this._onChange);
  }
  componentWillUnmount(){
    console.log('componentWillUnmount');
    PcypStore.removeChangeListener(this._onChange);
  }

  _onChange(){
    console.log('ChannelList._onChange()');
    this.setState(getChannels());
  }

  _channelitems(channels) {
    return channels.map((c)=>{
      //console.log(c);
      return (
        <ListItem
          className="channel-info"
          primaryText={c.name}
          secondaryText={c.detail + ":" + c.address}
          secondaryTextLines={1}
          rightAvatar={
            <Avatar
             size={24}
             disabled={true}>
              {c.viewer}
            </Avatar>
          }
          key={c.name+c.id}
          onDoubleClick={PcypActions.play_channel.bind(null, c)}
          />
      );
    });
  }

  render() {
    return (
      <div>
        {/*
        <List>
          <ListItem primaryText="お気に入り"
            leftIcon={<ActionGrade color={Colors.pinkA200} />}
            initiallyOpen={true}
            primaryTogglesNestedList={true}
            nestedItems={ this._channelitems(this.state.favorites) }
          />
        </List>
        <Divider inset={true} />
        */}
        <List>
          { this._channelitems(this.state.channels) }
        </List>
      </div>
    );
  }
};


export default ChannelList;
