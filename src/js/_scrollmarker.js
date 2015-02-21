/**
 * display a marker, that shows the reading position when scrolling
 * starts
 */

var $ = require("jquery");

var get_find_p_at = require("./_find_p_at");

var scroll_element = require("./_scroll_element");

var td = require("./_throttle-debounce");

module.exports = function($book) {
  var timeout_ref;
  var $marker = $('<div>', {
      'class': 'scrollmarker',
    })
    .appendTo(document.body);
  var find_p_at = get_find_p_at($book);

  function hide_marker() {
    $marker.css('opacity', 0);
  }

  function getLineHeight() {
    return parseInt($book.css('line-height'));
  }

  $(window).on('scroll', td.throttle(100, function() {
    var $p, styles, lh = getLineHeight(),
        st = scroll_element.scrollTop() + $(window).height();

    if ($marker.css('opacity') === '0') {
      $p = find_p_at(st - lh);
      if ($p.length) {
        styles = $p.offset(); /* set top and left */
        styles.top = styles.top - lh + Math.floor((st - styles.top) / lh) * lh;
        styles.opacity = 1;
        $marker
          .css(styles);
      }
    }

    window.clearTimeout(timeout_ref);
    timeout_ref = window.setTimeout(hide_marker, 500);
  }));
};
