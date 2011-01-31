var __hasLoaded = false;
jQuery(window).load(function () { __hasLoaded = true; });
jQuery(function ($) {

  var co = [], didScroll = true, $html = $('html'),
      chapter = undefined, section = undefined;
  var display = $('<div id="__display"></div>');

  var bookmark = $('<a class="bookmark-set" title="Jump to bookmark" href="#">\u00B6</a>')
                  .click(jump_to_bookmark).appendTo(display)
                  .mouseenter(function(){
                    $(this).data('pulse_stop', true);
                  });

  var bm_indicator = $('<img style="position:absolute;top:0;right:0" src="here.png" alt="bookmark" title="current bookmark" />');

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
  };

  /**
   *
   */
  function _pulse(a) {
    a.delay(2000).fadeOut('slow').fadeIn('slow', function() {
      if (! a.data('pulse_stop')) {
        _pulse(a);
      }
    });
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
    $('html, body').animate({'scrollTop': get_bookmark()}, 1000);
    return false;
  };

  /**
   * Get the position if the bookmark
   */
  function get_bookmark() {
    var c = document.cookie;
    if (c.indexOf('bookmark=') > -1) {
      c = parseFloat(c.replace(/(^|.*;)bookmark=([^;]*)($|;.*)/, '$2'));
      if (! isNaN(c)) {
        return c;
      }
    }
    return $html.scrollTop();
  };

  /**
   *
   */
  function bookmark_exists() {
    return (document.cookie.indexOf('bookmark=') > -1);
  };

  /**
   * Set the bookmark
   *
   * @TODO: Doesn't survive window size changes
   */
  function set_bookmark(height) {
    if (isNaN(height)) {
      height = $html.scrollTop();
    }
    document.cookie = 'bookmark='+height+';expires=Thu, 31 Dec 2099 23:59:59 GMT';
    new Message('Bookmark set.');
    bm_indicator.css('top', get_bookmark());
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
    display.show();
    update_offsets();
    var name = $('<a class="cur" href="#" title="">\u2192</a>'),
        prev = $('<a class="prev" href="#" title="">\u2191</a>');
        next = $('<a class="next" href="#" title="">\u2193</a>');
    display.append(prev).append(name).append(next);
    window.setInterval(function () {
      if (didScroll) {
        didScroll = false;
        var found = false, id;
        var pos = $html.scrollTop()+scroll_var;
        for (var i = 0; i < co.length; i++) {
          if (pos >= co[i][1]) {
            if (co.length == 1+i ||
                (co.length > 1+i &&
                 pos < co[1+i][1])) {
              found = true;

              // between sections fade me out
              if (pos < co[i][1] + hide_var) {
                display.css('opacity', Math.max(0.1, (pos-co[i][1])/hide_var));
              } else if (co.length > 1+i && pos > co[1+i][1]-hide_var) {
                display.css('opacity', Math.max(0.1, (co[1+i][1]-pos)/hide_var));
              } else {
                display.css('opacity', 1);
              }

              // if the chapter has changed since last time, update display
              if (chapter != co[i][0]) {
                chapter = co[i][0];
                id = co[i][0].attr('id');
                if (! id) {
                  co[i][0].attr('id', '__chapter_'+(1+i));
                  id = '__chapter_'+(1+i);
                }
                name.attr('href', '#'+id).attr('title', "Chapter start: "+chapter.find('h2:eq(0)').text());
                if (i > 0) {
                  id = co[i-1][0].attr('id');
                  if (! id) {
                    co[i-1][0].attr('id', '__chapter_'+i);
                    id = '__chapter_'+i;
                  }
                  prev.show().attr('href', '#'+id).attr('title', "Previous chapter: "+co[i-1][0].find('h2:eq(0)').text());
                } else {
                  prev.hide();
                }
                if (co.length > 1+i) {
                  id = co[i+1][0].attr('id');
                  if (! id) {
                    co[i+1][0].attr('id', '__chapter_'+(i+2));
                    id = '__chapter_'+(i+2);
                  }
                  next.show().attr('href', '#'+id).attr('title', "Next chapter: "+co[i+1][0].find('h2:eq(0)').text());
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
          display.hide();
        } else {
          display.show();
        }
      }
    }, 100);

    var bm_setter = $('<img style="position:fixed;top:10px;right:16px" \
          src="bookmark.png" alt="set bookmark" title="set bookmark" />')
    .click(function () {
      set_bookmark();
    }).appendTo($('body'));

    if (bookmark_exists()) {
      _pulse(bookmark);
      $('body').append(bm_indicator);
      bm_indicator.css('top', get_bookmark());
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
});
