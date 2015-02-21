/**
 * Determine the scrolling element
 *
 * @see http://stackoverflow.com/questions/2837178
 */
var $ = require("jquery");

module.exports = (function (tags) {
  var el, $el;
  /* jshint -W084 */
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
