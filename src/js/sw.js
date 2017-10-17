var CACHE = 'ebook-cache-v0.1.0';

self.addEventListener('install', function(evt) {
  evt.waitUntil(caches.open(CACHE).then(function (cache) {
    cache.addAll([
      'index.html',
      'favicon.ico',
      'static/ebook.css',
      'static/fonts/AlegreyaSC-Italic.woff2',
      'static/fonts/Alegreya-BlackItalic.woff2',
      'static/fonts/AlegreyaSC-Medium.woff2',
      'static/fonts/Alegreya-MediumItalic.woff2',
      'static/fonts/AlegreyaSC-ExtraBoldItalic.woff2',
      'static/fonts/AlegreyaSC-BlackItalic.woff2',
      'static/fonts/AlegreyaSC-BoldItalic.woff2',
      'static/fonts/Alegreya-Regular.woff2',
      'static/fonts/AlegreyaSC-Bold.woff2',
      'static/fonts/AlegreyaSC-Black.woff2',
      'static/fonts/AlegreyaSC-Regular.woff2',
      'static/fonts/Alegreya-ExtraBoldItalic.woff2',
      'static/fonts/Alegreya-ExtraBold.woff2',
      'static/fonts/Alegreya-BoldItalic.woff2',
      'static/fonts/AlegreyaSC-ExtraBold.woff2',
      'static/fonts/Alegreya-Italic.woff2',
      'static/fonts/AlegreyaSC-MediumItalic.woff2',
      'static/fonts/Alegreya-Medium.woff2',
      'static/fonts/Alegreya-Black.woff2',
      'static/fonts/Alegreya-Bold.woff2',
      'static/ebook.js',
    ]);
  }));
});

self.addEventListener('fetch', function(evt) {
  console.log('The service worker is serving the asset.');
  evt.respondWith(fromCache(evt.request));
  evt.waitUntil(
    update(evt.request)
    .then(refresh)
  );
});


function fromCache(request) {
  return caches.open(CACHE).then(function (cache) {
    return cache.match(request);
  });
}


function update(request) {
  return caches.open(CACHE).then(function (cache) {
    return fetch(request).then(function (response) {
      return cache.put(request, response.clone()).then(function () {
        return response;
      });
    });
  });
}


function refresh(response) {
  // TODO
}
