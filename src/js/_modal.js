/**
 * Modal window
 */
var $ = require("jquery");
var _ = require("./_gettext");

module.export = function(id, title, $content) {
  var that = this;
  this.frame = $('<div id="__'+id+'" class="__modal"><div class="__modal_payload"><h3>'+title+'</h3></div></div>')
            .children('div:eq(0)').append($content).end().hide()
            .bind('click', function (e) { if (e.target === this) { that.hide(); } });
  this.frame.prepend($('<a href="#" title="'+_('close window')+'" class="__modal_close">X</a>')
                     .click(function () { that.hide(); return false; })).data('__modal', that);
  this.show = function () {
    that.frame
      .appendTo($('body')).fadeIn().focus()
      .find('a.__modal_close').attr('tabindex', '0'); };
  this.hide = function () {
    that.frame
      .fadeOut()
      .find('a.__modal_close').removeAttr('tabindex');
  };
  this.destroy = function () {
    that.frame
      .find('a.__modal_close').removeAttr('tabindex').end()
      .fadeOut(function () {
        that.frame.remove();
        that.frame = undefined;
        that = undefined;
      });
  };
  return this;
};
