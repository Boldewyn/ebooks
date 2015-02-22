var $ = require('jquery');

var Combokeys = require('combokeys');

var get_find_p_at = require("./_find_p_at");

var settings = require('./_settings');

var ui = require('./_ui');

var scroll_element = require('./_scroll_element');

var mt = new Combokeys(document);


/**
 * generator for the "scroll_to" function
 */
function get_scroll_to($book, lh, wh) {
  var find_p_at = get_find_p_at($book);

  return function(pos) {
    var current = scroll_element[0].scrollTop,
        /* scrolling backwards? mod===0 */
        mod = current > pos? 0 : 1,
        $p = find_p_at(pos + mod*wh),
        pot;

    if ($p.length) {
      /* change pos so that it ends at a whole line */
      pot = ( pos + wh - $p.offset().top ) % lh;
      if (pot > 0 && pot < lh) {
        if (pot > lh / 3) {
          pos += lh - pot;
        } else {
          pos -= pot;
        }
      }
    }

    scroll_element
      .stop(true)
      .animate({ 'scrollTop': pos }, 200);

  };
}


module.exports = function($book) {
  var $window = $(window),
      wh = $window.height(),
      lh = parseInt($book.css('line-height')),
      scroll_to = get_scroll_to($book, lh, wh);

  $window.on('resize', function() {
    wh = $window.height();
  });

  mt.bind([settings.linesdown, 'enter', 'down'], function() {
    /* 3 lines down */
    scroll_to(scroll_element.scrollTop()+3*lh);
    return false;
  });

  mt.bind([settings.linesup, 'up'], function() {
    /* 3 lines up */
    scroll_to(scroll_element.scrollTop()-3*lh);
    return false;
  });

  mt.bind([settings.pagedown, 'pagedown', 'space'], function() {
    /* one screen wide down */
    scroll_to(scroll_element.scrollTop() +
              (Math.floor(wh/lh) - 1) * lh);
    return false;
  });

  mt.bind([settings.pageup, 'pageup'], function() {
    /* one screen wide up */
    scroll_to(scroll_element.scrollTop() -
              (Math.floor(wh/lh) - 1) * lh);
    return false;
  });

  mt.bind(settings.halfpagedown, function() {
    /* half a screen wide down */
    scroll_to(scroll_element.scrollTop() +
              (Math.floor(wh/lh)/2 + 1) * lh);
    return false;
  });

  mt.bind(settings.halfpageup, function() {
    /* half a screen wide up */
    scroll_to(scroll_element.scrollTop() -
              (Math.floor(wh/lh)/2 + 1) * lh);
    return false;
  });

  mt.bind('home', function() {
    /* to top */
    scroll_to(0);
    return false;
  });

  mt.bind('end', function() {
    /* to bottom */
    scroll_to($(document).height());
    return false;
  });

  mt.bind('?', function() {
    ui.show('help');
    return false;
  });
};


module.exports.mt = mt;
