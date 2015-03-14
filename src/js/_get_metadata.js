var $ = require('jquery');
var _ = require('./_gettext');

var interesting_meta = ["dc.title", "dc.description", "dc.subject",
    "dc.subject", "dc.creator", "dc.publisher", "dc.issued",
    "dc.language", "dc.rights",];

var interesting_link = ["dc.license", "dc.source", "dc.description",];


function prettify_name(name) {
  if (name === 'dc.creator') {
    return _('Author');
  }
  if (name.substr(0, 3) === 'dc.') {
    return name.substr(3, 1).toUpperCase() + name.substr(4);
  }
  return name;
}


module.exports = function(full) {
  var data = [];
  $('meta').each(function() {
    if (this.name && (full || $.inArray(this.name, interesting_meta) > -1)) {
      data.push([prettify_name(this.name), this.content, false]);
    }
  });
  $('link').each(function() {
    if (this.rel && (full || $.inArray(this.rel, interesting_link) > -1)) {
      data.push([prettify_name(this.rel), this.href, true]);
    }
  });
  return data;
};
