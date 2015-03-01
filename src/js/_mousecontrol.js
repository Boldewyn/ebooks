var $ = require("jquery");

require("jquery-mousewheel")($);

var get_scroll_to = require("./_aligned_scroll_to");

var scroll_element = require('./_scroll_element');

var settings = require('./_settings');

var td = require("./_throttle-debounce");


module.exports = function($book) {
  var $window = $(window),
      $doc = $(document),
      $body = $(document.body),
      wh = $window.height(),
      lh = parseInt($book.css('line-height')),
      scroll_to = get_scroll_to($book, lh, wh);

  $doc.on('mousewheel', function(evt) {
    var mod;
    if (! evt.deltaX && evt.deltaY) {
      mod = settings.scrolldir * evt.deltaY / Math.abs(evt.deltaY);
      scroll_to(scroll_element.scrollTop() + mod*3*lh);
      evt.preventDefault();
    }
  });

  function show_mouse() {
    $body.removeClass('no-pointer');
  }

  function hide_mouse() {
    $body.addClass('no-pointer');
    $doc.one('mousemove', show_mouse);
  }

  $doc
    .on('mousemove', td.debounce(3000, hide_mouse))
    .triggerHandler('mousemove');
};
