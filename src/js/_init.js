var $ = require('jquery');

var get_scroll_to = require("./_aligned_scroll_to");

module.exports = function($book) {
  var $window = $(window),
      wh = $window.height(),
      lh = parseInt($book.css('line-height')),
      scroll_to = get_scroll_to($book, lh, wh);

  $book
    /* start font downloading now */
    .addClass('crimsonized')
    .find('.footnote')
      /* add aria role to footnotes */
      .attr('role', 'note')
    .end()
    .find('p')
      .filter(function() {
        return ['\u201C', '\u201E'].indexOf(this.textContent.substr(0, 1)) > -1;
      })
        /* mark p's starting with quotes */
        .addClass('starts-with-quote');

  /* load the tools stylesheet */
  $('<link>', {
    rel: "stylesheet",
    href: "static/tools.css"
  })
    .appendTo(document.head);

  $(document).on('click', 'a[href^="#"]', function(evt) {
    var $target = $(this.hash);
    if ($target.length) {
      evt.preventDefault();
      scroll_to($target.offset().top - 4*lh);
      window.location.hash = this.hash;
    }
  });
};
