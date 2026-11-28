const {readFileSync} = require('node:fs');
const {runInNewContext} = require('node:vm');
const {test} = require('node:test');
const assert = require('node:assert/strict');

const script = readFileSync('web/safetrack_map.js', 'utf8');

function createSandbox({key, failLoading = false, invalid = false}) {
  const record = {scripts: 0, destroyed: 0, radius: null};
  const window = {
    mapgl: {
      Map: class {
        on(event, callback) {
          if (event === 'error' && invalid) queueMicrotask(callback);
        }
        once(event, callback) {
          if (event === 'styleload' && !invalid) queueMicrotask(callback);
        }
        invalidateSize() {}
        getZoom() { return 16; }
        setZoom(zoom) { record.zoom = zoom; }
        setCenter(point) { record.center = Array.from(point); }
        destroy() { record.destroyed++; }
      },
      Circle: class {
        constructor(_map, options) { record.radius = options.radius; }
      },
      CircleMarker: class {},
    },
  };
  runInNewContext(script, {
    window,
    sessionStorage: {getItem: () => null},
    fetch: async () => ({ok: true, json: async () => ({mapglKey: key})}),
    URL,
    AbortSignal,
    requestAnimationFrame: callback => queueMicrotask(callback),
    ResizeObserver: class { observe() {} disconnect() {} },
    document: {
      baseURI: 'https://example.test/',
      createElement: () => ({}),
      head: {append(element) {
        record.scripts++;
        queueMicrotask(failLoading ? element.onerror : element.onload);
      }},
    },
  });
  let dispose;
  const result = new Promise(resolve => {
    dispose = window.safeTrackMapGl.mount({}, 74.6, 42.8, 18,
      (zoom, recenter) => resolve({zoom, recenter}), () => resolve(null));
  });
  return {record, result, dispose};
}

test('missing key falls back without requesting the MapGL script', async () => {
  const {record, result} = createSandbox({key: ''});
  assert.equal(await result, null);
  assert.equal(record.scripts, 0);
});

test('failed MapGL download and rejected key fall back', async () => {
  const failed = createSandbox({key: 'synthetic-web-fixture', failLoading: true});
  assert.equal(await failed.result, null);
  assert.equal(failed.record.scripts, 1);

  const invalid = createSandbox({key: 'synthetic-web-fixture', invalid: true});
  assert.equal(await invalid.result, null);
  assert.equal(invalid.record.destroyed, 1);
});

test('shared controls and accuracy reach the MapGL renderer', async () => {
  const valid = createSandbox({key: 'synthetic-web-fixture'});
  const {zoom, recenter} = await valid.result;
  zoom(1);
  recenter();
  assert.equal(valid.record.radius, 18);
  assert.equal(valid.record.zoom, 17);
  assert.deepEqual(valid.record.center, [74.6, 42.8]);
  valid.dispose();
  assert.equal(valid.record.destroyed, 1);
});
