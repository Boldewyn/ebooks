/**
 * fetch all relevant metadata tags from <head>
 */
var $ = require('jquery');
var _ = require('./_gettext');

var interesting_meta = ["dc.creator", "dc.description", "dc.issued",
  "dc.language", "dc.license", "dc.publisher", "dc.rights", "dc.source",
  "dc.spacial", "dc.subject", "dc.temporal", "dc.title", ];

var interesting_link = ["dc.license", "dc.source", "dc.description",];


/**
 * prettify the label (like dc.creator) of a meta entry
 */
function prettify_name(name) {
  if (name === 'dc.creator') {
    return _('Author');
  }
  if (name.substr(0, 3) === 'dc.') {
    return name.substr(3, 1).toUpperCase() + name.substr(4);
  }
  return name;
}


function prettify_content(content, name) {
  var r;
  if (name === 'dc.language') {
    if (content.substr(0, 2) === 'en') {
      r = _('english');
      if (content.substr(3) === '-GB') {
        r += _(' (Great-Britain)');
      } else if (content.substr(3) === '-US') {
        r += _(' (USA)');
      } else if (content.substr(3) === '-IE') {
        r += _(' (Ireland)');
      }
      return r;
    } else if (content.substr(0, 2) === 'de') {
      r = _('german');
      if (content.substr(3) === '-DE') {
        r += _(' (Germany)');
      }
      return r;
    }
  } else if (name === 'dc.issued') {
    try {
      r = new Date(content);
      r = r.toLocaleDateString();
    } catch(err) {
      r = content;
    }
    return r;
  }
  return content;
}


module.exports = function(full) {
  var data = [];
  $('meta').each(function() {
    if (this.name && (full || $.inArray(this.name, interesting_meta) > -1)) {
      data.push([
        prettify_name(this.name),
        prettify_content(this.content, this.name),
        false
      ]);
    }
  });
  $('link').each(function() {
    if (this.rel && (full || $.inArray(this.rel, interesting_link) > -1)) {
      data.push([prettify_name(this.rel), this.href, true]);
    }
  });
  return data;
};
