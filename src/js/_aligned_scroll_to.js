/**
 * generator for an enhanced "scroll_to" function
 *
 * The function scrolls to a certain position, then checks if there
 * is a <p> tag at the end of the viewport and aligns the scroll
 * position with a whole line of that paragraph, so that you never
 * end on a half line.
 */
var get_find_p_at = require("./_find_p_at");

var scroll_element = require('./_scroll_element');


module.exports = function($book, lh, wh) {
  var find_p_at = get_find_p_at($book);

  return function(pos) {
    var current = scroll_element[0].scrollTop,
        /* scrolling backwards? mod===0 */
        mod = current > pos? 0 : 1,
        $p = find_p_at(pos + mod*wh),
        pot;

    if ($p.length) {
      /* change pos so that it ends at a whole line */
      pot = ( pos + wh - $p.offset().top ) % lh;
      if (pot > 0 && pot < lh) {
        if (pot > lh / 3) {
          pos += lh - pot;
        } else {
          pos -= pot;
        }
      }
    }

    scroll_element
      .stop(true, true)
      .animate({ 'scrollTop': pos }, 200);

  };
};
