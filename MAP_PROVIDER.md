# SafeTrack map providers

SafeTrack Family displays a fictional last-known position near central Bishkek. The marker and accuracy radius are generated locally from the selected demo scenario. No geolocation permission, USB location data, address lookup or server-side tracking is used.

## Provider selection

| Platform | Primary | Fallback |
| --- | --- | --- |
| Web | 2GIS MapGL JS with an authorized browser key | MapLibre GL, then the illustrated demo if the map cannot initialize |
| Android and iOS | MapLibre Native through Flutter MapLibre GL | Illustrated demo if the map cannot initialize |

The shared Flutter controls provide zoom and recentering. MapLibre uses the OpenFreeMap Positron style. The basemap contains real public geography, and all tracker positions and accuracy values are fictional. Keep the 2GIS logo and legal links visible and retain OpenFreeMap, OpenMapTiles and OpenStreetMap attribution. There is no tile download or offline caching feature.

## Configure a 2GIS web key

1. Sign in to 2GIS Platform Manager and obtain the browser access key for MapGL JS / Map Tiles API. The downloaded mobile SDK file named `dgissdk.key` is a different artifact. It stays outside SafeTrack.
2. Confirm the demo subscription is active and authorized for your intended use. Configure allowed domains in the provider account where available. Use a browser-scoped key because MapGL necessarily sends it to the browser, where it can be inspected.
3. For local testing, serve the release bundle on localhost and set the browser session key on that origin, then reload. For example, use `sessionStorage.setItem('safetrack.mapgl.key', prompt('2GIS browser demo key'))` in the browser developer console. Remove it after the check with `sessionStorage.removeItem('safetrack.mapgl.key')`.
4. An operator-managed web deployment can serve a same-origin runtime `map-provider.json` with a `mapglKey` value. The checked-in file and published Git bundle intentionally contain an empty value and use MapLibre. Keep browser key provisioning outside Git. A Vercel environment variable alone does not configure this prebuilt static site.

The web adapter falls back to MapLibre when the browser key is absent, the script fails, the API reports an error, or initialization times out. An expired or invalid key is handled by the same path. The supplied mobile SDK file is excluded by `.gitignore`, and the deployment script rejects a populated config or key files in the staged build directory.

## References

- [2GIS MapGL JS setup](https://docs.2gis.com/en/mapgl/start/first-steps) and [mobile SDK key format](https://docs.2gis.com/flutter/sdk/start).
- [OpenFreeMap tile hosting and attribution](https://openfreemap.org/) and [mobile setup](https://openfreemap.org/quick_start/).
- [OpenStreetMap data attribution and ODbL](https://www.openstreetmap.org/copyright).
