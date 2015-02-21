var $ = require("jquery");
window.$=$;

var _init = require('./_init');

var $book = $('.book');

_init($book);

require('./_scrollmarker')($book);

var keycontrol = require('./_keycontrol');

keycontrol($book);
