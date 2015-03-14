var $ = require('jquery');

var Combokeys = require('combokeys');

var get_scroll_to = require("./_aligned_scroll_to");

var settings = require('./_settings');

var ui = require('./_ui');

var scroll_element = require('./_scroll_element');

var mt = new Combokeys(document);


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

  mt.bind('c', function() {
    ui.show('toc');
    return false;
  });
};


module.exports.mt = mt;
