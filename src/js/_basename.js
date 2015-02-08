/**
 * Return the basename of a path
 */
module.exports = function(path) {
  if (path === undefined) {
    path = window.location.pathname;
  }
  var t = path.split("/");
  return t[t.length - 1];
};
