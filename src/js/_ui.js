var $ = require('jquery');
var _ = require('./_gettext');
var settings = require('./_settings');

/* jshint -W098 */
var dialog = require('jquery-ui/dialog');
require('jquery-ui/effect-scale');

var $dialogs = {};

var dialog_help = require('../views/dialog_help.mustache');

var get_metadata = require('./_get_metadata');


function show(name) {
  if (name === 'help') {
    if (!(name in $dialogs)) {
      $dialogs[name] = $('<div>')
        .html(
          dialog_help.render({
            kbd: {
              pagedown: settings.pagedown,
              pageup: settings.pageup,
              halfpagedown: settings.halfpagedown,
              halfpageup: settings.halfpageup,
              linesdown: settings.linesdown,
              linesup: settings.linesup,
            },
            meta: get_metadata(),
            scrolldir: settings.scrolldir === -1? _('traditional') : _('natural'),
            source_link: '<a href="https://github.com/Boldewyn/ebooks/">GitHub</a>',
            _: function() {
              return function(text, render) {
                return render(_(text));
              };
            },
          })
        )
        .attr('title', _('Help & Settings'));
    }
    $dialogs[name].dialog({
      modal: true,
      width: $(document).width() - 20,
      show: {
        effect: 'scale',
      },
      hide: {
        effect: 'scale',
      },
      buttons: [
        {
          text: _('Close Help'),
          icons: { primary: 'ui-icon-circle-close' },
          click: function() { $dialogs[name].dialog('close'); },
        },
      ],
    });
  } else if (name === 'toc') {
    if (!(name in $dialogs)) {
      var $toc = $('#Table_of_Contents').find('ol:eq(0)');
      if (! $toc.length) {
        $toc = $('<p>').text(_('No table of contents found :('));
      }
      $dialogs[name] = $('<div>')
        .html(
          $toc
            .clone()
            .on('click', 'a', function() {
              $dialogs[name].dialog('close');
            }))
        .attr('title', _('Table of Contents'))
        .dialog({
          autoOpen: false,
          modal: true,
          width: $(document).width() - 20,
          show: {
            effect: 'scale',
          },
          hide: {
            effect: 'scale',
          },
          buttons: [
            {
              text: _('Close'),
              icons: { primary: 'ui-icon-circle-close' },
              click: function() { $dialogs[name].dialog('close'); },
            },
          ],
        });
    }
    if ($dialogs[name].dialog('isOpen') === true) {
      $dialogs[name].dialog('close');
    } else {
      $dialogs[name].dialog('open');
    }
  }
}


exports.show = show;
