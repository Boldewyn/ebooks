

/**
 * Determine the scrolling element
 *
 * @see http://stackoverflow.com/questions/2837178
 */
var scrollElement = (function (tags) {
  var el, $el;
  while (el = tags.pop()) {
    $el = $(el);
    if ($el.scrollTop() > 0){
      return $el;
    } else if($el.scrollTop(1).scrollTop() > 0) {
      return $el.scrollTop(0);
    }
  }
  return $();
})(["html", "body"]);


/**
 * Easing function ~ jquery.easing's easeOutCirc
 */
$.extend($.easing, {
  pgmove: function (x, t, b, c, d) {
    return c*Math.sqrt(1-(t=t/d-1)*t)+b;
  }
});

/**
 * Add styles and metadata
 */
$('<meta name="viewport" content="width=device-width, initial-scale=1.0" />').appendTo('head');
$('<link rel="stylesheet" href="tools.css" />').appendTo('head');

/**
 * Start onDOMReady
 */
jQuery(function ($) {

  var settings = {
    '__bool': ['hide_display', 'full_width', 'sans_serif'],
    'hide_display': false,
    '__hide_display': function () {
      settings.hide_display = !settings.hide_display;
      if (settings.hide_display) {
        document.cookie = "ebook_hide_display=1";
        display.hide();
      } else {
        document.cookie = "ebook_hide_display=0";
        display.show();
      }
    },
    'font_size': '100%',
    '__font_size': function (mode) {
      if (mode === "__cfg_fs_dwn") {
        $('html').css('font-size', function(index, value) {
          settings.font_size = Math.max(parseFloat(value) - 2, 6);
          return settings.font_size;
        });
      } else if (mode === "__cfg_fs_std") {
        settings.font_size = '100%';
        $('html').css('font-size', '100%');
      } else {
        $('html').css('font-size', function(index, value) {
          settings.font_size = Math.min(parseFloat(value) + 2, 48);
          return settings.font_size;
        });
      }
      document.cookie = 'ebook_font_size='+settings.font_size;
      update_offsets();
    },
    'full_width': false,
    '__full_width': function () {
      settings.full_width = !settings.full_width;
      if (settings.full_width) {
        document.cookie = "ebook_full_width=1";
        $('body').addClass('full-width');
      } else {
        document.cookie = "ebook_full_width=0";
        $('body').removeClass('full-width');
      }
      update_offsets();
    },
    'sans_serif': false,
    '__sans_serif': function () {
      settings.sans_serif = !settings.sans_serif;
      if (settings.sans_serif) {
        document.cookie = "ebook_sans_serif=1";
        $('body').addClass('sans-serif');
      } else {
        document.cookie = "ebook_sans_serif=0";
        $('body').removeClass('sans-serif');
      }
      update_offsets();
    }
  };
  $.each(settings.__bool, function(i, x) {
    if (document.cookie.indexOf('ebook_'+x+'=1') > -1) {
      settings['__'+x]();
    }
  });
  if (document.cookie.indexOf('ebook_font_size=') > -1) {
    settings.font_size = document.cookie.replace(/.*ebook_font_size=([^;]*).*/, '$1');
    $('html').css('font-size', settings.font_size);
  }

  var co = [], didScroll = true;
      chapter = undefined;
  var display = $('<div id="__display"></div>');
  var ctrl_container = $('<div id="__ctrl_container"></div>').appendTo('body');

  var bookmark = $('<a class="bookmark" title="'+_('Jump to bookmark')+'" href="#">\u00B6</a>')
                  .click(jump_to_bookmark).appendTo(display)
                  .mouseenter(function(){
                    $(this).data('pulse_stop', true).stop(true, true).show();
                  });

  var home_button = $('<a class="home" title="'+_('Go to start')+'" href="#">\u21B8</a>')
                     .click(function () { scrollElement.animate({'scrollTop': 0}, 1000); })
                     .appendTo(display);

  var bm_indicator = $('<img style="position:absolute;top:0;right:0" src="data:image/png;base64,'+
                       'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAN1wAADdcBQiibeAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAACbSURBVDiNnZLBEcMgDAQXxn0ZWkhchopwES4jRdiNRfmEGSJbQHz/vVsxBFXlTl7bloA03QEjrAFmhTxcYEACHE+RvVtgwZI3rABugQdSrV8WtEC7/lMwAtp1gGkUvFoHiANMM3ER2R8iSSEHOLqAMQj2J5aTFGavRCEv33c4nTBiVFucDGw8o2LRfUTPqFh0DVpGCvnvgroISB9kz1/6dVLwMwAAAABJRU5ErkJggg=='+
                       '" alt="'+_('current bookmark')+'" title="'+_('current bookmark')+'" />');

  var config_content = $('<section></section>');
  config_content.append($('<p><input type="checkbox" id="__cfg_full" '+(settings.full_width?'checked="checked"':'')+'/> <label for="__cfg_full">'+_('View in full width')+'</label></p>')
      .find('input').change(settings.__full_width).end()
  ).append($('<p><input type="checkbox" id="__cfg_sans" '+(settings.sans_serif?'checked="checked"':'')+'/> <label for="__cfg_sans">'+_('View in sans-serif font')+'</label></p>')
      .find('input').change(settings.__sans_serif).end()
  ).append($('<p><input type="checkbox" id="__cfg_hide_dspl" '+(settings.hide_display?'checked="checked"':'')+'/> <label for="__cfg_hide_dspl">'+_('Hide the quick navigation')+'</label></p>')
      .find('input').change(settings.__hide_display).end()
  ).append($('<p>'+_('Font size:')+' <button type="button" id="__cfg_fs_dwn">\u25BC</button> '+
                                    '<button type="button" id="__cfg_fs_std">\u25CF</button> '+
                                    '<button type="button" id="__cfg_fs_up">\u25B2</button></p>')
    .find('button').click(function () { settings.__font_size(this.getAttribute("id")); }).end()
  ).append($('<p><button type="button">'+_('Exit')+'</button></p>')
    .find('button').click(function () { $(this).closest('.__modal').data('__modal').hide(); }).end());
  var config = new Modal('config', _('Settings'), config_content);
  var config_opener = $('<img class="__ctrl" style="right:46px" src="data:image/png;base64,'+
                        'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAN1wAADdcBQiibeAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAEnSURBVDiNnZGxSgNBFEXPm6SIdULQSssIAVsrsbNcw/6Alm4ytjZapPADTCZYpbRzRexFsAn+gGhhY/ADTCUszLNINiSwWchONe/Cue9enqgqea/b7ZpmtWqBU2Bb4VXgIux0PgDKuTTQrNWGqJ6ks6j+hNZ+LsyrEzz0+/sqMpoLqrehtW1A48Hg5s/7K5O7XuRgAX5O4Xvneqieb4gc5lZQVUVk+heZPDm3laheisjZTKvkG8CXpGGglUArNQSSsshoZYXYuYaIDFa2g+sgisaZCWLnGsALsDmTJsA3sCPw7lV7obV3kHHGDPgXkaOw3X7LWrZUYV14yaAIPDcoCgOU9ur1XVUtBAMY9X5YFJ4aQKUoDFD23h+XjAlKxjwGUTReBwb4B+LUggpBuvHaAAAAAElFTkSuQmCC'+
                        '" alt="'+_('settings')+
                        '" title="'+_('settings')+'" />')
      .click(function () {
        config.show();
      }).appendTo(ctrl_container);

  var toc = new Modal('toc', _('Contents'), $('#Table_of_Contents ol').clone(false).find('a').click(function () {
      toc.hide();
    }).end());
  var toc_opener = $('<img class="__ctrl" style="right:76px" src="data:image/png;base64,'+
                     'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAN1wAADdcBQiibeAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAABISURBVDiNY1wzefIOBgYGhuCcHI+1U6b8ZyARMJGqAR0w/v9PsqUogAWZs3bKFJK9M+oFansBGRDrnUHgBXJCHhkMvBcodgEArpUxNVDPcqwAAAAASUVORK5CYII='+
                     '" alt="'+_('show contents')+
                        '" title="'+_('show contents')+'" />')
      .click(function () {
        toc.show();
      }).appendTo(ctrl_container);

  /**
   * Modal window
   */
  function Modal(id, title, $content) {
    var that = this;
    this.frame = $('<div id="__'+id+'" class="__modal"><div class="__modal_payload"><h3>'+title+'</h3></div></div>')
              .children('div:eq(0)').append($content).end().hide()
              .bind('click', function (e) { if (e.target === this) { that.hide(); } });
    this.frame.prepend($('<a href="#" title="'+_('close window')+'" class="__modal_close">X</a>')
                       .click(function () { that.hide(); return false; })).data('__modal', that);
    this.show = function () {
      that.frame
        .appendTo($('body')).fadeIn()
        .find('a.__modal_close').attr('tabindex', '0'); };
    this.hide = function () {
      that.frame
        .fadeOut()
        .find('a.__modal_close').removeAttr('tabindex');
    };
    this.destroy = function () {
      that.frame
        .find('a.__modal_close').removeAttr('tabindex').end()
        .fadeOut(function () {
          that.frame.remove();
          that.frame = undefined;
          that = undefined;
        });
    };
    return this;
  };

  /**
   * Unobstrusive messaging system
   */
  var Message = function (str) {
    this.str = str;
    var $container = $('#__messages');
    if ($container.length == 0) {
      $container = $('<ul id="__messages"></ul>');
      $('body').append($container);
    }
    $('<li>'+str+'</li>').hide().appendTo($container)
      .fadeIn('slow').delay(2000).fadeOut('slow', function () {
        $(this).remove();
      });
    return this;
  };

  /**
   * i18n stub
   */
  function _(s) { return s; }

  /**
   * Add a pulsing effect to element a
   *
   * Stops, when the 'pulse_stop' data item is set.
   */
  function _pulse(a) {
    a.delay(2000).fadeOut('slow').fadeIn('slow', function() {
      if (! a.data('pulse_stop')) {
        _pulse(a);
      }
    });
  };

  /**
   * Return the basename of a path
   */
  function basename(path) {
    if (path === undefined) {
      path = window.location.pathname;
    }
    var t = path.split("/");
    return t[t.length - 1];
  };

  /**
   * Convert ems to px in the context of a certain element
   */
  function em2px(em, ctx) {
    if (! ctx) { ctx = $('body'); }
    return Number(ctx.css('font-size').replace(/px/, ''))*Number(em);
  };

  /**
   * Set the offsets of chapters
   */
  function update_offsets() {
    co = [];
    $('.book > section:not(#Table_of_Contents)').each(function () {
      co.push([$(this), $(this).offset().top, $(this).innerHeight()]);
    });
  };

  /**
   * Scroll the view to the bookmark position
   */
  function jump_to_bookmark() {
    scrollElement.animate({'scrollTop': get_bookmark().offset().top}, 1000);
    return false;
  };

  /**
   * Get the position if the bookmark
   */
  function get_bookmark() {
    if (bookmark_exists()) {
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
  };

  /**
   * Check, if the user has already set the bookmark
   */
  function bookmark_exists() {
    return (document.cookie.indexOf('bookmark_'+basename()+'=') > -1);
  };

  /**
   * Set the bookmark
   */
  function set_bookmark(height) {
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
    document.cookie = 'bookmark_'+basename()+'='+best_index+';expires=Thu, 31 Dec 2099 23:59:59 GMT';
    new Message(_('Bookmark successfully set.'));
    $('body').append(bm_indicator);
    bm_indicator.css('top', get_bookmark().offset().top+'px');
    return false;
  };

  // if resized, update the offsets of chapters
  $(window).resize(update_offsets);

  // update infos, if scrolled
  $(window).scroll(function () {
    didScroll = true;
  });

  // we start onLoad to give the fonts time to arrive
  $(window).load(function () {
    var scroll_var = em2px(5); // switch display 5em above a chapter
    var hide_var = em2px(20); // do the "hide me-show me" trick in +/- this area around a section
    $('body').append(display);
    update_offsets();
    var name = $('<a class="cur" href="#" title="">\u2192</a>'),
        prev = $('<a class="prev" href="#" title="">\u2191</a>');
        next = $('<a class="next" href="#" title="">\u2193</a>');
    display.appendTo('body').append(prev).append(next).append(name);
    if (! settings.hide_display) {
      display.show();
    }
    window.setInterval(function () {
      if (! settings.hide_display && didScroll) {
        didScroll = false;
        var found = false, opacity = 1, id;
        var pos = scrollElement.scrollTop()+scroll_var;
        for (var i = 0; i < co.length; i++) {
          if (pos >= co[i][1]) {
            if (co.length == 1+i ||
                (co.length > 1+i &&
                 pos < co[1+i][1])) {
              found = true;

              // between sections fade me out
              if (pos < co[i][1] + hide_var) {
                opacity = Math.max(0.1, (pos-co[i][1])/hide_var);
              } else if (co.length > 1+i && pos > co[1+i][1]-hide_var) {
                opacity = Math.max(0.1, (co[1+i][1]-pos)/hide_var);
              }

              // if the chapter has changed since last time, update display
              if (chapter != co[i][0]) {
                chapter = co[i][0];
                id = co[i][0].attr('id');
                if (! id) {
                  co[i][0].attr('id', '__chapter_'+(1+i));
                  id = '__chapter_'+(1+i);
                }
                var cur_title = chapter.find('h2:eq(0)').text();
                name.text("\u2192 "+cur_title).attr('href', '#'+id)
                    .attr('title', _("Chapter start: ")+cur_title);
                if (i > 0) {
                  id = co[i-1][0].attr('id');
                  if (! id) {
                    co[i-1][0].attr('id', '__chapter_'+i);
                    id = '__chapter_'+i;
                  }
                  prev.show().attr('href', '#'+id).attr('title', _("Previous chapter: ")+co[i-1][0].find('h2:eq(0)').text());
                } else {
                  prev.hide();
                }
                if (co.length > 1+i) {
                  id = co[i+1][0].attr('id');
                  if (! id) {
                    co[i+1][0].attr('id', '__chapter_'+(i+2));
                    id = '__chapter_'+(i+2);
                  }
                  next.show().attr('href', '#'+id).attr('title', _("Next chapter: ")+co[i+1][0].find('h2:eq(0)').text());
                } else {
                  next.hide();
                }
                break;
              }
            }
          }
        }

        // hide the display, if we're not in a chapter
        if (found === false) {
          display.css('opacity', 0.1).find('.prev, .cur, .next').hide();
        } else {
          display.css('opacity', opacity).find('.prev, .next').show();
          if (! settings.full_width) {
            display.find('.cur').show();
          }
        }
      }
    }, 100);

    var bm_setter = $('<img class="__ctrl" style="right:16px" '+
                      'src="data:image/png;base64,'+
                      'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAN1wAADdcBQiibeAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAACWSURBVDiN7ZNBCsIwEEVfpNS7uPcW3UmukIVtTtNewL1eJ0cJ2EW/C01pIYrRhRsfDExmJp+BzxhJAFyG4Z4sOHSdydVTD6DKFUvYlH74C/xY4PSIFVVmMEfY1vUR4DqOe2BXskGcJNs4Fxvn4iRZIL4tYKTWeh/S23ofjNTOA5KQxLnvlfKS+MiF5YF9bePKhWen+4obbQZdAg19UokAAAAASUVORK5CYII='+
                      '" alt="'+_('set bookmark')+'" title="'+_('set bookmark')+'" />')
    .click(function () {
      set_bookmark();
    }).appendTo(ctrl_container);

    if (bookmark_exists()) {
      _pulse(bookmark);
      $('body').append(bm_indicator);
      bm_indicator.css('top', get_bookmark().offset().top+"px");
    }
  });

  $(window).unload(function () {
    if (! bookmark_exists()) {
      set_bookmark();
    }
  });

});

/**
  * Smooth scrolling away from the table of contents
  */
$('#Table_of_Contents a').click(function () {
  var v = $(this).attr("href");
  if (v.substr(0, 1) === "#" && $(v).length > 0) {
    scrollElement.animate({'scrollTop': $(v).offset().top}, 1000, function () {
      window.location.hash = v;
    });
    return false;
  }
});

/**
 * Register basic key bindings
 */
$(document).keydown(function (e) {
  var r = true;
  switch(e.which) {
    case 66: // b
    case 33: // PgUp
      if (e.which === 66 && (! e.ctrlKey || e.altKey || e.shiftKey)) {
        return true;
      }
      scrollElement.stop(true,true).animate({'scrollTop':
                            scrollElement.scrollTop()-$(window).height()+
                            2*parseFloat($('.book').css('line-height'))},
                            {'duration':400,'easing':'pgmove'});
      r = false;
      break;
    case 70: // f
    case 34: // PgDwn
      if (e.which === 70 && (! e.ctrlKey || e.altKey || e.shiftKey)) {
        return true;
      }
      scrollElement.stop(true,true).animate({'scrollTop':
                            scrollElement.scrollTop()+$(window).height()-
                            2*parseFloat($('.book').css('line-height'))},
                            {'duration':400,'easing':'pgmove'});
      r = false;
      break;
    case 75: // k
    case 38: // ArrUp
      scrollElement.stop(true,true).animate({'scrollTop':
                            scrollElement.scrollTop()-
                            3*parseFloat($('.book').css('line-height'))}, 200);
      r = false;
      break;
    case 74: // j
    case 13: // Enter
    case 32: // Space
    case 40: // ArrDwn
      scrollElement.stop(true,true).animate({'scrollTop':
                            scrollElement.scrollTop()+
                            3*parseFloat($('.book').css('line-height'))}, 200);
      r = false;
      break;
    case 36: // Home
      scrollElement.stop(true,true).animate({'scrollTop': 0}, {'duration':750, 'easing':'pgmove'});
      r = false;
      break;
    case 35: // End
      scrollElement.stop(true,true).animate({'scrollTop': $(document).height()},
                            {'duration':750, 'easing':'pgmove'});
      r = false;
      break;
    case 68: // d
      if (e.ctrlKey && ! e.altKey && ! e.shiftKey) {
        scrollElement.stop(true,true).animate({'scrollTop': scrollElement.scrollTop()+0.5*$(window).height()},
                              {'duration':400,'easing':'pgmove'});
        r = false;
      }
      break;
    case 85: // u
      if (e.ctrlKey && ! e.altKey && ! e.shiftKey) {
        scrollElement.stop(true,true).animate({'scrollTop': scrollElement.scrollTop()-0.5*$(window).height()},
                              {'duration':400,'easing':'pgmove'});
        r = false;
      }
      break;
  }
  if (! r) {
    e.preventDefault();
    e.stopPropagation();
  }
  return e;
});
