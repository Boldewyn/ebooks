var settings = {
  save: false,
  linesdown: 'j',
  linesup: 'k',
  pagedown: 'ctrl+f',
  pageup: 'ctrl+b',
  halfpagedown: 'ctrl+d',
  halfpageup: 'ctrl+u',
};

if ('localStorage' in window) {
  var x, obj = JSON.parse(window.localStorage.getItem('ebookSettings'));
  if (obj) {
    for (x in settings) {
      if (x in obj) {
        settings[x] = obj[x];
      }
    }
  }

  /**
   * save the settings if localStorage available
   */
  settings.save = function() {
    var x, obj = {};
    for (x in settings) {
      if (typeof x !== 'function') {
        obj[x] = settings[x];
      }
    }
    window.localStorage.setItem('ebookSettings', JSON.stringify(settings));
  };
}

module.exports = settings;
