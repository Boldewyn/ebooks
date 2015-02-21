/**
 * Return the <p> element (jQuery object) at a specific position or an
 * empty jQuery set, if none is found
 */
var $ = require('jquery');

module.exports = function($book) {
  return function(position) {
    var p;
    $('p', $book).each(function () {
      var off = this.offsetTop,
          height = this.offsetHeight;
      if (off <= position && off + height >= position) {
        p = this;
        return false;
      }
    });
    return $(p);
  };
};
