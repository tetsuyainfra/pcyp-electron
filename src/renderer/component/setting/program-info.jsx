
var React = require('react');

import {List, ListItem, Toggle, TextField} from 'material-ui'
import ActionInfo from 'material-ui/lib/svg-icons/action/info';
import {FileFolder} from 'material-ui/lib/svg-icons';
import FontIcon from 'material-ui/lib/font-icon';
import Colors from 'material-ui/lib/styles/colors';
import remote from 'remote';

export default class ProgramInfo extends React.Component {
  constructor (props) {
    super(props);
    this.state = {
      NODE_VERSION: remote.process.version,
      NODE_ENV    : process.env.NODE_ENV,
      arch        : remote.process.arch,
      electron    : remote.process.versions['electron'],
      program_version: process.env.PROGRAM_VERSION,
      program_revision: process.env.PROGRAM_REVISION
    };
  }
  render () {
    return (
      <div className="program_info_page">
        <List className="page">
          <ListItem primaryText="NODE_VERSION"
            secondaryText={this.state.NODE_VERSION}  />
          <ListItem primaryText="実行環境"
            secondaryText={this.state.NODE_ENV}  />
          <ListItem primaryText="アーキテクチャ"
            secondaryText={this.state.arch}  />
          <ListItem primaryText="Electron version"
            secondaryText={this.state.electron}  />
          <ListItem primaryText="Program version"
            secondaryText={this.state.program_version}  />
          <ListItem primaryText="Program revision"
            secondaryText={this.state.program_revision}  />
        </List>
      </div>
    );
  }
};
