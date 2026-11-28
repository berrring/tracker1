// Only a browser-scoped MapGL access key belongs in the optional runtime configuration.
window.safeTrackMapGl = (() => {
  let library;
  let keyRequest;

  function getKey() {
    return keyRequest ??= (async () => {
      try {
        const local = sessionStorage.getItem('safetrack.mapgl.key')?.trim();
        if (local) return local;
      } catch (_) {
        // Storage can be unavailable in a restricted browser.
      }
      try {
        const response = await fetch(new URL('map-provider.json', document.baseURI), {
          cache: 'no-store',
          signal: AbortSignal.timeout(3000),
        });
        if (!response.ok) return '';
        const configuration = await response.json();
        return typeof configuration.mapglKey === 'string' ? configuration.mapglKey.trim() : '';
      } catch (_) {
        return '';
      }
    })();
  }

  function loadLibrary() {
    return library ??= new Promise((resolve, reject) => {
      const script = document.createElement('script');
      script.src = 'https://mapgl.2gis.com/api/js/v1';
      script.onload = () => resolve(window.mapgl);
      script.onerror = reject;
      document.head.append(script);
    });
  }

  function mount(element, longitude, latitude, accuracy, onReady, onUnavailable) {
    let map;
    let observer;
    let disposed = false;
    const center = [longitude, latitude];
    const dispose = () => {
      if (disposed) return;
      disposed = true;
      observer?.disconnect();
      map?.destroy();
    };
    const fail = () => {
      if (disposed) return;
      dispose();
      onUnavailable();
    };

    (async () => {
      const key = await getKey();
      if (!key) return fail();
      const sdk = await loadLibrary();
      if (disposed) return;
      // Flutter may invoke the view-created callback before DOM attachment.
      await new Promise(resolve => requestAnimationFrame(resolve));
      if (disposed) return;
      map = new sdk.Map(element, {key, center, zoom: 16, zoomControl: false});
      observer = new ResizeObserver(() => map?.invalidateSize());
      observer.observe(element);
      map.on('error', fail);
      map.once('styleload', () => {
        if (disposed) return;
        try {
          if (accuracy != null) {
            new sdk.Circle(map, {coordinates: center, radius: accuracy,
              color: '#17493b35', strokeColor: '#17493b', strokeWidth: 1});
            new sdk.CircleMarker(map, {coordinates: center, radius: 9,
              color: '#17493b', strokeColor: '#ffffff', strokeWidth: 3});
          }
          onReady(delta => map.setZoom(Math.min(19, Math.max(3, map.getZoom() + delta))),
            () => map.setCenter(center));
        } catch (_) {
          fail();
        }
      });
    })().catch(fail);
    return dispose;
  }

  return {mount};
})();
