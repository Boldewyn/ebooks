var $ = require("jquery");
var _ = require("./_gettext");

var scrollElement = require("./_scrollelement");
var basename = require("./_basename");
var Message = require("./_message");


var bm_indicator = $('<img>', {
  id: "__bookmark",
  src: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAN1wAADdcBQiibeAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAACbSURBVDiNnZLBEcMgDAQXxn0ZWkhchopwES4jRdiNRfmEGSJbQHz/vVsxBFXlTl7bloA03QEjrAFmhTxcYEACHE+RvVtgwZI3rABugQdSrV8WtEC7/lMwAtp1gGkUvFoHiANMM3ER2R8iSSEHOLqAMQj2J5aTFGavRCEv33c4nTBiVFucDGw8o2LRfUTPqFh0DVpGCvnvgroISB9kz1/6dVLwMwAAAABJRU5ErkJggg==',
  alt: _('current bookmark'),
  title: _('current bookmark')
});


/**
 * Check, if the user has already set the bookmark
 */
function exists() {
  return (document.cookie.indexOf('bookmark_'+basename()+'=') > -1);
}


/**
 * Get the bookmarked element or the book root
 */
function get_element() {
  if (exists()) {
    var c = parseInt(document.cookie.replace(
              new RegExp('(^|.*;\\s*)bookmark_'+
                          basename().replace(/[.?()\[\]()]/, '\\$&')+
                          '=([^;]*)($|\\s*;.*)'), '$2'));
    if (! isNaN(c)) {
      c = $('.book').find('*').eq(c);
      if (c.length) {
        return c;
      }
    }
  }
  return $('.book');
}


/**
 * Scroll the view to the bookmark position
 */
function jump_to() {
  scrollElement.animate({'scrollTop': get_element().offset().top}, 1000);
  return false;
}


/**
 * Do the low level bookmarking
 */
function set_cookie(best_index) {
  document.cookie = 'bookmark_'+basename()+'='+best_index+';expires=Thu, 31 Dec 2099 23:59:59 GMT';
  new Message(_('Bookmark set'));
  $('body').append(bm_indicator);
  bm_indicator.css('top', get_element().offset().top+'px');
  return false;
}


/**
 * Set the bookmark
 */
function set(height) {
  if (isNaN(height)) {
    height = scrollElement.scrollTop();
  }
  var el, off, index = 0, best_index = 0, diff = height;
  $('*', $('.book')).each(function () {
    off = $(this).offset().top;
    if (off > height) {
      if (off - height < diff) {
        el = $(this);
        best_index = index;
        diff = el.offset().top - height;
      }
    }
    index++;
  });
  set_cookie(best_index);
  return false;
}


/**
 * Set the bookmark directly to an element
 */
function set_by_element(el) {
  var n = 0, found = false;
  $('*', $('.book')).each(function () {
    if (this === el) {
      found = true;
      return false;
    }
    n += 1;
  });
  if (found) {
    set_cookie(n);
    return true;
  } else {
    new Message(_('Couldn\u2019t set bookmark'));
    return false;
  }
}


/**
 * initialize bookmark setting
 */
function init() {
  if (exists()) {
    bm_indicator.css('top', get_element().offset().top+"px");
    $('body').append(bm_indicator);
  }

  $(window).unload(function() {
    if (! exists()) {
      set();
    }
  });
}


module.exports.jump_to = jump_to;
module.exports.set = set;
module.exports.set_by_element = set_by_element;
module.exports.init = init;
