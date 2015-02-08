/**
 * Unobstrusive messaging system
 */
var $ = require("jquery");

module.exports = function(str) {
  this.str = str;
  var $container = $('#__messages');
  if ($container.length === 0) {
    $container = $('<ul id="__messages"></ul>');
    $('body').append($container);
  }
  $('<li>'+str+'</li>')
    .hide()
    .appendTo($container)
    .fadeIn('slow')
    .delay(2000)
    .fadeOut('slow', function () {
      $(this).remove();
    });
  return this;
};
