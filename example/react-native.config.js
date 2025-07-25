const path = require('path');
const pak = require('../package.json');

module.exports = {
  dependencies: {
    'react-native-image-picker': {
      platforms: {
        ios: null, // 👈 disable auto-linking for iOS
      },
    },
    [pak.name]: {
      root: path.join(__dirname, '..'),
    },
  },
};
