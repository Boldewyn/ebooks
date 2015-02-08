/**
 * Add a pulsing effect to element a
 *
 * Stops, when the 'pulse_stop' data item is set.
 */
module.exports = function _pulse($a) {
  $a
    .delay(2000)
    .fadeOut('slow')
    .fadeIn('slow', function() {
      if (! $a.data('pulse_stop')) {
        _pulse($a);
      }
    });
};
