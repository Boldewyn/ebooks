import { default as $ } from 'jquery';
window.$ = $;

navigator.serviceWorker.register('static/sw.js', {
  scope: '.',
});

//var _init = require('./_init');
//
//var $book = $('.book');
//
//_init($book);
//
//require('./_scrollmarker')($book);
//
//require('./_keycontrol')($book);
//
//require('./_mousecontrol')($book);
