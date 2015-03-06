var $ = require('jquery');
var _ = require('./_gettext');

/* jshint -W098 */
var dialog = require('jquery-ui/dialog');

var $dialogs = {};


function show(name) {
  if (name === 'help') {
    if (!(name in $dialogs)) {
      $dialogs[name] = $('<div>')
        .text('ABC')
        .html(
          '<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut a sapien. Aliquam aliquet purus molestie dolor. Integer quis eros ut erat posuere dictum. Curabitur dignissim. Integer orci. Fusce vulputate lacus at ipsum. Quisque in libero nec mi laoreet volutpat. Aliquam eros pede, scelerisque quis, tristique cursus, placerat convallis, velit. Nam condimentum. Nulla ut mauris. Curabitur adipiscing, mauris non dictum aliquam, arcu risus dapibus diam, nec sollicitudin quam erat quis ligula. Aenean massa nulla, volutpat eu, accumsan et, fringilla eget, odio. Nulla placerat porta justo. Nulla vitae turpis. Praesent lacus.</p>'+
          '<p>Nam iaculis blandit purus. Mauris odio nibh, hendrerit id, cursus vel, sagittis a, dolor. Nullam turpis lacus, ultrices vel, sagittis vitae, dapibus vel, elit. Suspendisse auctor, sapien et suscipit tempor, turpis enim consequat sem, eu dictum nunc lorem at massa. Pellentesque scelerisque purus. Etiam sed enim. Maecenas sed tortor id turpis consequat consequat. Curabitur fringilla. Sed risus wisi, dictum a, sagittis nec, luctus ac, neque. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Sed nibh neque, aliquam ut, sagittis id, gravida et, est. Aenean consectetuer pretium enim. Aenean tellus quam, condimentum a, adipiscing et, lacinia vel, ante. Praesent faucibus dignissim enim. Aliquam tincidunt. Mauris leo ante, condimentum eget, vestibulum sit amet, fringilla eget, diam. Nam ultricies ullamcorper nibh. Etiam neque. Ut posuere laoreet pede.</p>'
        )
        .attr('title', _('Help'));
    }
    $dialogs[name].dialog({
      modal: true,
      width: $(document).width() - 20,
    });
  }
}


exports.show = show;
