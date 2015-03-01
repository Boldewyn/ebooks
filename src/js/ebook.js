var $ = require("jquery");
window.$=$;

var _init = require('./_init');

var $book = $('.book');

_init($book);

require('./_scrollmarker')($book);

require('./_keycontrol')($book);

require('./_mousecontrol')($book);
