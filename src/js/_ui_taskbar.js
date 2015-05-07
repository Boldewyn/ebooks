var $ = require('jquery');
//var _ = require('./_gettext');

var ui = require('./_ui');

var taskbar_markup = require('../views/taskbar.mustache').render(),
    $taskbar;

exports.create = function($book) {
  $book = $book;
  $taskbar = $(taskbar_markup);
  $taskbar
    .on('click', '.taskbar__item--content', function() {
      ui.show('toc');
    })
    .on('click', '.taskbar__item--help', function() {
      ui.show('help');
    });
  $taskbar.appendTo(document.body);
};
