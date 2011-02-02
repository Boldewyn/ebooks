var __hasLoaded = false;
jQuery(window).load(function () { __hasLoaded = true; });
jQuery(function ($) {

  var settings = {
    'hide_display': false
  };

  var co = [], didScroll = true, $html = $('html'),
      chapter = undefined;
  var display = $('<div id="__display"></div>');

  var bookmark = $('<a class="bookmark" title="'+_('Jump to bookmark')+'" href="#">\u00B6</a>')
                  .click(jump_to_bookmark).appendTo(display)
                  .mouseenter(function(){
                    $(this).data('pulse_stop', true);
                  });

  var home_button = $('<a class="home" title="'+_('Go to start')+'" href="#">\u21B8</a>')
                     .click(function () { $('html, body').animate({'scrollTop': 0}, 1000); })
                     .appendTo(display);

  var bm_indicator = $('<img style="position:absolute;top:0;right:0" src="here.png" alt="'+
                       _('current bookmark')+'" title="'+_('current bookmark')+'" />');

  var config = new Modal('config', _('Settings'), $('<p></p>'));
  var config_opener = $('<img class="__ctrl" style="right:46px" src="tool.png" alt="'+_('settings')+
                        '" title="'+_('settings')+'" />')
      .click(function () {
        config.show();
      }).appendTo($('body'));

  var toc = new Modal('toc', _('Contents'), $('#Table_of_Contents ol').clone(false).find('a').click(function () {
      toc.hide();
    }).end());
  var toc_opener = $('<img class="__ctrl" style="right:76px" src="toc.png" alt="'+_('show contents')+
                        '" title="'+_('show contents')+'" />')
      .click(function () {
        toc.show();
      }).appendTo($('body'));

  /**
   * Modal window
   */
  function Modal(id, title, $content) {
    var that = this;
    this.frame = $('<div id="__'+id+'" class="__modal""><div><h3>'+title+'</h3></div></div>')
              .children('div:eq(0)').append($content).end().hide()
              .bind('click', function (e) { if (e.target === this) { that.hide(); } });
    this.frame.prepend($('<a href="#" title="'+_('close window')+'" class="__modal_close">X</a>')
                       .click(function () { that.hide(); }));
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
    $('.book > section:not(#Table_of_Contents)').each(function () {
      co.push([$(this), $(this).offset().top, $(this).innerHeight()]);
    });
  };

  /**
   * Scroll the view to the bookmark position
   */
  function jump_to_bookmark() {
    $('html, body').animate({'scrollTop': get_bookmark().offset().top}, 1000);
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
        return $('*:eq('+c+')', $('.book'));
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
      height = $html.scrollTop();
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

  $('head').append($('<link rel="stylesheet" href="tools.css">'));

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
    if (! settings.hide_display) {
      display.show();
    }
    update_offsets();
    var name = $('<a class="cur" href="#" title="">\u2192</a>'),
        prev = $('<a class="prev" href="#" title="">\u2191</a>');
        next = $('<a class="next" href="#" title="">\u2193</a>');
    display.append(prev).append(next).append(name);
    window.setInterval(function () {
      if (! settings.hide_display && didScroll) {
        didScroll = false;
        var found = false, opacity = 1, id;
        var pos = $html.scrollTop()+scroll_var;
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
          display.css('opacity', opacity).find('.prev, .cur, .next').show();
        }
      }
    }, 100);

    var bm_setter = $('<img class="__ctrl" style="right:16px" '+
                      'src="bookmark.png" alt="'+_('set bookmark')+
                      '" title="'+_('set bookmark')+'" />')
    .click(function () {
      set_bookmark();
    }).appendTo($('body'));

    if (bookmark_exists()) {
      _pulse(bookmark);
      $('body').append(bm_indicator);
      bm_indicator.css('top', get_bookmark().offse().top+"px");
    }
  });
  if (__hasLoaded) {
    $(window).load();
  }

  $(window).unload(function () {
    if (! bookmark_exists()) {
      set_bookmark();
    }
  });

  /**
   * Smooth scrolling away from the table of contents
   */
  $('#Table_of_Contents a').click(function () {
    var v = $(this).attr("href");
    if (v.substr(0, 1) === "#" && $(v).length > 0) {
      $('html, body').animate({'scrollTop': $(v).offset().top}, 1000, function () {
        window.location.hash = v;
      });
      return false;
    }
  });
});
