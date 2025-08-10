'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "75379ebc65444174a7bfcb25b15a74d6",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"manifest.json": "1a9f754d5876e143f146d73ba21c7a3a",
"version.json": "8e0a1e74717a16dd167b61be866eae0b",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"main.dart.js": "bea16d08c85c9c8e0dd51a886b53595f",
"index.html": "5b87a94838c11b4335498329f4127c0b",
"/": "5b87a94838c11b4335498329f4127c0b",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/NOTICES": "8903ec3716e4545d5e1e14c38da44e1a",
"assets/AssetManifest.json": "deae4d796e1be1d80f269471f5374e0a",
"assets/AssetManifest.bin": "bd6be91a5fb632d2af7076d83c19fbd2",
"assets/AssetManifest.bin.json": "42e2d685fddca0b1ea51bf47ea782e22",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/fonts/MaterialIcons-Regular.otf": "550a5ae8111eaeb3d091e30bb4ad5fab",
"assets/assets/images/cards/Seahorse.jpg": "2454f435c14a25df7c7a8678eca0e211",
"assets/assets/images/cards/Cat.jpg": "5b658e250659e9843581c7e7cba04f21",
"assets/assets/images/cards/Bear.jpg": "7b5be3c778559c01bf185fac2f70a515",
"assets/assets/images/cards/Monkey.jpg": "beb8f5fee1fea35efb034a3a54a1f477",
"assets/assets/images/cards/Frog.jpg": "1df2b9679e29edb9ecb3812f4edba058",
"assets/assets/images/cards/Butterfly.jpg": "cda4796b97825cbec2882b7242eb2d8d",
"assets/assets/images/cards/Swans.jpg": "83fbf6febfedac2ce8d7da9c3ad795d0",
"assets/assets/images/cards/RedPanda.jpg": "d0ebd2a00753e0b80d7317bec5c1d0c9",
"assets/assets/images/cards/Hyena.jpg": "04c9e140d0847fa4640223b5fe58870a",
"assets/assets/images/cards/Albatross.jpg": "de919c10a00d0c97315194db371e5c20",
"assets/assets/images/cards/Gorilla.jpg": "bd4f0f33e26050fdc374270e44b27361",
"assets/assets/images/cards/LoveBirds.jpg": "8196cbca0b63b3096afc91e26252669b",
"assets/assets/images/cards/Crow.jpg": "64ba7daa1d31e4a26b2cedfba4053c0f",
"assets/assets/images/cards/SnowLeopard.jpg": "5a17a34ab7d35dd47f576b452ebfe9af",
"assets/assets/images/cards/Gecko.jpg": "c37a7dab6fa59322eb13b205e6c4ca24",
"assets/assets/images/cards/Wolverine.jpg": "5b1558637bd543f140d7a97b696343af",
"assets/assets/images/cards/SeaTurtle.jpg": "d020548dc29d511f42bcb1a5af78eee4",
"assets/assets/images/cards/Parrot.jpg": "51f1283a90b35050f5fdea9129585600",
"assets/assets/images/cards/Penguin.jpg": "72d3e54796f5d06a293bda0303d6ceb7",
"assets/assets/images/cards/Whale.jpg": "e5abcaf0485c5ffc375f820a72cbdc40",
"assets/assets/images/cards/Owl.jpg": "5d26514ef7679da0c8fb3900248e933f",
"assets/assets/images/cards/Donkey.jpg": "a25e9969b33f328cf5779ff10c649c1a",
"assets/assets/images/cards/Ram.jpg": "690e2f60fc0ac7032550428ecabedcfa",
"assets/assets/images/cards/Squirrel.jpg": "b62b2851c0d8f10bec04cd634eb875d1",
"assets/assets/images/cards/Dragon.jpg": "e04d7a10ef584b67d88cf7e823a3ab88",
"assets/assets/images/cards/Bull.jpg": "8faaf04b5a0b669981e38e6fcfe3ed99",
"assets/assets/images/cards/Lynx.jpg": "a6924398f74d77ab82befc2f64c3f6d0",
"assets/assets/images/cards/Eagle.jpg": "62a3fe98a4980ac783847fd0eb9fdcb7",
"assets/assets/images/cards/Vulture.jpg": "2c9b7ddc23fa8d6e6f7b6331527a1032",
"assets/assets/images/cards/Bison.jpg": "39aff3b1080f8e7ad4cf8aa25696790f",
"assets/assets/images/cards/Racoon.jpg": "8c45d74d4c23a6e6a7d7edf264998bd9",
"assets/assets/images/cards/Swallow.jpg": "d920b0bd2e876af83190d0307d837e1f",
"assets/assets/images/cards/Deer.jpg": "367406c17b91f7f0eacbfbef1dfbf018",
"assets/assets/images/cards/Tortoise.jpg": "2db7ce6723a7e183bada4bd4be069b3b",
"assets/assets/images/cards/Ants.jpg": "95ddd979c012f5c11ac1ed83b07e5cb3",
"assets/assets/images/cards/Panther.jpg": "57e4cb0138779f50b7b8e958db628b97",
"assets/assets/images/cards/Fox.jpg": "90414bd380f6fae08cfa5a6a77d7a981",
"assets/assets/images/cards/Ox.jpg": "111ebff32c6f17f3de4d40924144397f",
"assets/assets/images/cards/Flamingo.jpg": "9c9eac02fb9422de86406a08f5bcea12",
"assets/assets/images/cards/Bat.jpg": "526bd2667d9d8f24b0d9a94ee6fd933d",
"assets/assets/images/cards/Elephant.jpg": "911798a3dc8919940a74bc5d2288335d",
"assets/assets/images/cards/Coyote.jpg": "897e309eb687caf4b8f5953cfaeb8015",
"assets/assets/images/cards/Bee.jpg": "83a5442a3b7bb7f4dc510ea8626b0076",
"assets/assets/images/cards/Spider.jpg": "8c94f48e0b5b9b0ef5c4e5cf3391e5bb",
"assets/assets/images/cards/Tiger.jpg": "d4b61538d2516ee945f6706f12c67ec7",
"assets/assets/images/cards/Moth.jpg": "727c4cc28ddd070afca6d643680aa78b",
"assets/assets/images/cards/Wild%2520Boar.jpg": "80a33f0df363093cd5964a75b585908c",
"assets/assets/images/cards/Goat.jpg": "9abc09fe14fcdd71d4bfd32d8fe24e8d",
"assets/assets/images/cards/Ladybug.jpg": "bdfbbb1913b731d4c3e546e120aa3552",
"assets/assets/images/cards/Golden%2520Retriever.jpg": "102ee0dd672336a62aa1d51539e6bd07",
"assets/assets/images/cards/wild_boar.jpg": "80a33f0df363093cd5964a75b585908c",
"assets/assets/images/cards/Horse.jpg": "8faf00da0c8840619e3b73f304b47076",
"assets/assets/images/cards/Octopus.jpg": "84d88e48925b324335e7d87a09535984",
"assets/assets/images/cards/Snake.jpg": "a89db0bee98e11fe4f28eba66840360a",
"assets/assets/images/cards/Otters.jpg": "b94255a0893ba4cedce675ea2b9eec05",
"assets/assets/images/cards/Cow.jpg": "71133de9c7b0be1b4526a5e12c6ab9b7",
"assets/assets/images/cards/Rabbits.jpg": "71e8150345b7fb13c8edea65ba35bf97",
"assets/assets/images/cards/Stag.jpg": "06a548690e7ff686ca5e2c1c2360b633",
"assets/assets/images/cards/Dolphin.jpg": "ce931d24ebfe891552c727db81bf9bbc",
"assets/assets/images/cards/Hummingbird.jpg": "32a35ee7b6cd30dd95bfa193d1618ca9",
"assets/assets/images/cards/Heron.jpg": "6adf0af8e29d9249c3d432c98590bc0e",
"assets/assets/images/cards/Hen.jpg": "2e1046d98f3626c10779219dd2fc3471",
"assets/assets/images/cards/Shark.jpg": "0b0e86b4483886ccf12ef161c955f391",
"assets/assets/images/cards/Lion.jpg": "790ce429280a168f4e9f5c5f4a76160e",
"assets/assets/images/cards/BlackSwan.jpg": "584f1743ec99534bf7823fbe7a5482ad",
"assets/assets/images/cards/Badger.jpg": "b6cdae77cc851b062c9989811fe7e2f7",
"assets/assets/images/cards/Jelleyfish.jpg": "877ba80acfa13ef3e72ab25cf6603f45",
"assets/assets/images/cards/Wolf.jpg": "c16b026a85889ab85ad477b17c5c2040",
"assets/assets/images/cards/Pheonix.jpg": "66f5c3ca1e35fa55d09fa7e6b3e41491",
"assets/assets/images/cards/Rooster.jpg": "15b15c8af26743dab743d1bbbf29d998",
"assets/assets/images/cards/Lioness.jpg": "94f96752136db713886398e92226d6ce",
"assets/assets/images/cards/Vixen.jpg": "fa3ba1b9b807c34b93578652fdc009b7",
"assets/assets/images/cards/Gazelle.jpg": "399d56ee3898a88cf48d4cddeeb8952b",
"assets/assets/images/cards/Porcupine.jpg": "7804677b8714c33d810781770552cede",
"assets/assets/images/cards/Beaver.jpg": "1023328f6d8457ab0ff632b0f1406780",
"assets/assets/images/cards/KoiFish.jpg": "eb929d99722c72b16fea9ceb39e2570b",
"assets/assets/images/cards/golden_retriever.jpg": "102ee0dd672336a62aa1d51539e6bd07",
"assets/assets/images/cards/Peacock.jpg": "2532eef0e5ac49b75056d6f6c9c4171b",
"assets/assets/images/cards/Salamander.jpg": "afeb590e1d2d0ccc7125add7d0e686e1",
"assets/assets/images/cards/Scorpion.jpg": "875626aea86821fd19af9bb2679cac78",
"assets/assets/images/placeholder_card.jng": "de919c10a00d0c97315194db371e5c20",
"assets/assets/spreads/three_card.json": "af27dbc1535995eb3cbe3910ff792f9c",
"assets/assets/themes/animal_tarot.json": "362ecf64ddc49042a44f967eb35c83e7",
"assets/assets/decks/animal_tarot.json": "11609dd15cde3a1d710eae9f6074e3d2"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
