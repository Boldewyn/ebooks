var $ = require('jquery');

var Combokeys = require('combokeys');

var get_scroll_to = require("./_aligned_scroll_to");

var settings = require('./_settings');

var ui = require('./_ui');

var scroll_element = require('./_scroll_element');

var mt = new Combokeys(document);

var dialog_open = false;


module.exports = function($book) {
  var $window = $(window),
      wh = $window.height(),
      lh = parseInt($book.css('line-height')),
      _scroll_to = get_scroll_to($book, lh, wh),
      scroll_to = function(pos) {
        if (dialog_open) {
          return true;
        }
        _scroll_to(pos);
        return false;
      };

  $window
    .on('resize', function() {
      wh = $window.height();
    })
    .on('dialogopen', function() {
      dialog_open = true;
    })
    .on('dialogclose', function() {
      dialog_open = $(".ui-dialog").is(":visible");
    });

  mt.bind([settings.linesdown, 'enter', 'down'], function() {
    /* 3 lines down */
    return scroll_to(scroll_element.scrollTop()+3*lh);
  });

  mt.bind([settings.linesup, 'up'], function() {
    /* 3 lines up */
    return scroll_to(scroll_element.scrollTop()-3*lh);
  });

  mt.bind([settings.pagedown, 'pagedown', 'space'], function() {
    /* one screen wide down */
    return scroll_to(scroll_element.scrollTop() +
              (Math.floor(wh/lh) - 1) * lh);
  });

  mt.bind([settings.pageup, 'pageup'], function() {
    /* one screen wide up */
    return scroll_to(scroll_element.scrollTop() -
              (Math.floor(wh/lh) - 1) * lh);
  });

  mt.bind(settings.halfpagedown, function() {
    /* half a screen wide down */
    return scroll_to(scroll_element.scrollTop() +
              (Math.floor(wh/lh)/2 + 1) * lh);
  });

  mt.bind(settings.halfpageup, function() {
    /* half a screen wide up */
    return scroll_to(scroll_element.scrollTop() -
              (Math.floor(wh/lh)/2 + 1) * lh);
  });

  mt.bind('home', function() {
    /* to top */
    return scroll_to(0);
  });

  mt.bind('end', function() {
    /* to bottom */
    return scroll_to($(document).height());
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
