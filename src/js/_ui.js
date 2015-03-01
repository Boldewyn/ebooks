var $ = require('jquery');

/* jshint -W098 */
var dialog = require('jquery-ui/dialog');


function show(name) {
  if (name === 'help') {
    $('<div>')
      .text('ABC')
      .dialog({
        modal: true
      });
  }
}


exports.show = show;
