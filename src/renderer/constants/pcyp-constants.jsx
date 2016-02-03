
import _ from 'lodash';
import keyMirror from 'keyMirror';

import MainConstants from '../../constants/app-constants';


var PcypConstants = _.merge(MainConstants, {
  ActionTypes: keyMirror({
        VIEW_RELOAD: null
  })
});

module.exports = PcypConstants;
