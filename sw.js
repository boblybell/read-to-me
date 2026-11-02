// Keeps the app working offline. Your books and voices are in IndexedDB, not here.
const CACHE='readtome-v112';
const FILES=['./','index.html','manifest.webmanifest','icon-v180.png','icon-v192.png','icon-v512.png','lib-bg-paper.jpg'];
self.addEventListener('install',e=>{e.waitUntil(caches.open(CACHE).then(c=>c.addAll(FILES.map(f=>new Request(f,{cache:'reload'})))));self.skipWaiting()});
self.addEventListener('activate',e=>{e.waitUntil(caches.keys().then(ks=>Promise.all(ks.filter(k=>k!==CACHE).map(k=>caches.delete(k)))));self.clients.claim()});
self.addEventListener('fetch',e=>{
  if(e.request.method!=='GET') return;
  const same=new URL(e.request.url).origin===location.origin;
  // Network first and skip the browser cache, so a new version shows at once; use the saved copy when offline.
  e.respondWith(fetch(same?new Request(e.request,{cache:'no-cache'}):e.request).then(r=>{if(r.ok&&(same||e.request.url.includes('fonts.g'))){const c=r.clone();caches.open(CACHE).then(x=>x.put(e.request,c))}return r}).catch(()=>caches.match(e.request,{ignoreSearch:true}).then(r=>r||caches.match('index.html'))));
});
