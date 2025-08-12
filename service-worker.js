const CACHE_NAME = 'ne-travaux-v16'; // Incrémenté pour forcer le cache refresh
const urlsToCache = [
  './',
  './index.html',
  './manifest.json',
  './background.jpg.jpg',
  './logo.jpg.jpg'
];

// Installation du service worker
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => {
        console.log('Opened cache');
        return cache.addAll(urlsToCache);
      })
  );
});

// Activation du service worker
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cacheName) => {
          if (cacheName !== CACHE_NAME) {
            console.log('Deleting old cache:', cacheName);
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
});

// Interception des requêtes - EXCLUSION DES REQUÊTES SUPABASE
self.addEventListener('fetch', (event) => {
  const url = new URL(event.request.url);
  
  // EXCLURE TOUTES LES REQUÊTES SUPABASE DU CACHE
  if (url.hostname.includes('supabase.co') || 
      url.hostname.includes('sltmmvuxcanzhqakrtrw.supabase.co') ||
      event.request.method !== 'GET') {
    console.log('🚫 Service Worker: Requête Supabase exclue du cache:', url.href);
    // Toujours faire un appel réseau pour Supabase
    event.respondWith(fetch(event.request));
    return;
  }
  
  // Pour les autres ressources, utiliser le cache
  event.respondWith(
    caches.match(event.request)
      .then((response) => {
        // Retourner la réponse du cache si elle existe
        if (response) {
          return response;
        }
        
        // Sinon, faire la requête réseau
        return fetch(event.request);
      })
  );
});
