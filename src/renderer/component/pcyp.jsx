// lib
import ThemeManager from 'material-ui/lib/styles/theme-manager';
import ThemeDecorator from 'material-ui/lib/styles/theme-decorator';
import {RefreshIndicator} from 'material-ui';

// app
import MyMui    from './mui';
import MyAppBar from './app-bar';
import ChannelList from './channel-list';

import PcypActions from '../actions/pcyp-actions';
import PcypStore from '../stores/pcyp-store';

class App extends React.Component {
  constructor(props){
    super(props);
    this.state = {
      muiTheme: ThemeManager.getMuiTheme(MyMui),
      yp_loading: 'hide',
    };
    this._onChange = this._onChange.bind(this);
  }
  _onChange() {
    this.setState(PcypStore.getLoadingStatus());
  }
  getChildContext() {
    return {
      muiTheme: this.state.muiTheme,
    };
  }
  componentDidMount(){
    console.log('componentDidMount');
    PcypStore.addChangeListener(this._onChange);
    PcypActions.crawl_yp();
  }
  componentWillUnmount(){
    console.log('componentWillUnmount');
    PcypStore.removeChangeListener(this._onChange);
  }
  render() {
    return(
      <div>
        <div className="appbar">
          <MyAppBar zIndex={1} yp_status={this.state.yp_loading} />
        </div>
        <div className="content">
          <ChannelList />
        </div>
      </div>
    );
  }
};
App.childContextTypes = {
  muiTheme: React.PropTypes.object,
};

// some
ReactDOM.render(
  <App />,
  document.getElementById('app')
);
