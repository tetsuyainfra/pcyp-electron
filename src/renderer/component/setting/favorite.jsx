var React = require('react');

import {List, ListItem, Toggle, TextField, Divider} from 'material-ui';

import ActionInfo from 'material-ui/lib/svg-icons/action/info';
import {FileFolder} from 'material-ui/lib/svg-icons';
import FontIcon from 'material-ui/lib/font-icon';
import Colors from 'material-ui/lib/styles/colors';




export default class Favorite extends React.Component {
  constructor (props) {
    super(props);
    var { config } = props;
    console.log('Favorite.constructor() props:', props);
  }
  render () {
    return (
      <div id="favorite">
        {"工事中"}
      </div>
    );
  }
};
