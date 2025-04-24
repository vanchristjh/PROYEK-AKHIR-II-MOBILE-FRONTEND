// This file is loaded by index.html and handles initializing Flutter web

// Create a global _flutter object to match the expected syntax in index.html
window._flutter = window._flutter || {};

window._flutter.loader = {
  loadEntrypoint: function(options) {
    // Wait for Flutter.js to be fully loaded
    const flutterJs = document.querySelector('script[src="flutter.js"]');
    if (flutterJs) {
      // If flutter.js is still loading, wait for it
      if (!window.flutterConfiguration) {
        flutterJs.addEventListener('load', function() {
          _initializeFlutter(options);
        });
      } else {
        _initializeFlutter(options);
      }
    } else {
      console.error('Flutter.js script not found. Please ensure it is included in your HTML.');
    }
  }
};

function _initializeFlutter(options) {
  // Now initialize Flutter using the provided options
  _flutter_web_init().then(function(engineInitializer) {
    options.onEntrypointLoaded(engineInitializer);
  });
}

// This is required for compatibility with the original Flutter web loader
function _flutter_web_init() {
  return new Promise(function(resolve) {
    if (window.flutterConfiguration) {
      // Call the Flutter web initialization function
      resolve(window.flutterConfiguration);
    } else {
      // If Flutter.js doesn't provide the expected API, create a minimal compatible version
      resolve({
        initializeEngine: function() {
          return new Promise(function(resolveEngine) {
            resolveEngine({
              runApp: function() {
                console.log("Flutter web app is running");
              }
            });
          });
        }
      });
    }
  });
}
