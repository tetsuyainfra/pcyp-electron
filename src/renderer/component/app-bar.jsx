// lib
import {AppBar, AutoComplete, IconButton, MenuItem} from 'material-ui';
import {CircularProgress, RefreshIndicator} from 'material-ui';
import IconMenu from 'material-ui/lib/menus/icon-menu';
import {ActionAutorenew, NavigationMoreVert} from 'material-ui/lib/svg-icons';

// my class
import PcypActions from '../actions/pcyp-actions';

class MyAppBar extends React.Component{
  reload_app(e) {
    console.log('reload_application');
    var client = require('electron-connect').client.create();
    setInterval( ()=>{client.sendMessage('RELOAD_APP', {});}, 1000);
  }

  crawl_yp() {
    console.log('crawl_yp');
    PcypActions.crawl_yp();
  }

  open_config_window() {
    console.log('open_config_window()');
    PcypActions.open_config_window();
  }

  render() {
    return (
      <AppBar
        title={
          <AutoComplete
            hintText="keyword"
            dataSource={["aaa","bbb","ddd"]}
            fullWidth={true}
          />
        }
        iconElementLeft={
          <IconButton onTouchTap={this.crawl_yp}>
            <ActionAutorenew />
          </IconButton>
        }
        iconElementRight={
          <IconMenu
            iconButtonElement={
              <IconButton>
                <NavigationMoreVert />
              </IconButton>
            }
            targetOrigin={{horizontal: 'right', vertical: 'top'}}
            anchorOrigin={{horizontal: 'right', vertical: 'top'}}
          >
            <MenuItem primaryText="工事中" style={{color: "red"}} />
            <MenuItem primaryText="Help" />
            <MenuItem primaryText="Setting"
             onTouchTap={this.open_config_window} />
            <MenuItem primaryText="DevTool" />
            <MenuItem primaryText="ReStart"
             onTouchTap={this.reload_app} />
          </IconMenu>
        }

      />
    );
  }
}

module.exports = MyAppBar;
