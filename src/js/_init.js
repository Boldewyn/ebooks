var $ = require('jquery');

module.exports = function($book) {

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
};
