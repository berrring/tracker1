import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:maplibre_gl/maplibre_gl.dart' as ml;
import 'package:material_ui/material_ui.dart';

import '../app/design.dart';
import '../data/mock_tracker_repository.dart';
import 'map_model.dart';
import 'mapgl_stub.dart' if (dart.library.js_interop) 'mapgl_web.dart';

enum _Provider { mapGl, mapLibre, illustrated }

class TrackerMap extends StatefulWidget {
  const TrackerMap({
    super.key,
    required this.sample,
    required this.status,
    required this.interactive,
    required this.illustration,
  });

  final LocationSample? sample;
  final TrackerStatus status;
  final bool interactive;
  final Widget illustration;

  @override
  State<TrackerMap> createState() => _TrackerMapState();
}

class _TrackerMapState extends State<TrackerMap> {
  late _Provider provider;
  Timer? timeout;
  MapActions? actions;
  var fallback = false;

  @override
  void initState() {
    super.initState();
    final mobile =
        defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
    provider = !widget.interactive
        ? _Provider.illustrated
        : kIsWeb
        ? _Provider.mapGl
        : mobile
        ? _Provider.mapLibre
        : _Provider.illustrated;
    startTimeout();
  }

  void startTimeout() {
    timeout?.cancel();
    if (provider == _Provider.illustrated) return;
    final attempted = provider;
    timeout = Timer(const Duration(seconds: 9), () => unavailable(attempted));
  }

  void unavailable(_Provider attempted) {
    if (!mounted || attempted != provider) return;
    setState(() {
      actions = null;
      fallback = attempted == _Provider.mapLibre;
      provider = switch (attempted) {
        _Provider.mapGl => _Provider.mapLibre,
        _ => _Provider.illustrated,
      };
    });
    startTimeout();
  }

  void ready(_Provider attempted, MapActions next) {
    if (!mounted || attempted != provider) return;
    timeout?.cancel();
    setState(() => actions = next);
  }

  @override
  void didUpdateWidget(covariant TrackerMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.sample != oldWidget.sample) {
      actions = null;
      startTimeout();
    }
  }

  @override
  void dispose() {
    timeout?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    if (provider == _Provider.illustrated) {
      return fallback
          ? Stack(
              fit: StackFit.expand,
              children: [
                widget.illustration,
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Align(
                    alignment: AlignmentDirectional.bottomStart,
                    child: Tag(
                      s.mapServiceUnavailable,
                      Icons.cloud_off_outlined,
                    ),
                  ),
                ),
              ],
            )
          : widget.illustration;
    }
    final sample = widget.sample;
    final point = MapPoint.demo(sample);
    final current = provider;
    final map = current == _Provider.mapGl
        ? createMapGlSurface(
            point: point,
            accuracy: sample?.accuracy,
            onReady: (next) => ready(current, next),
            onUnavailable: () => unavailable(current),
          )
        : _MapLibreSurface(
            point: point,
            accuracy: sample?.accuracy,
            onReady: (next) => ready(current, next),
            onUnavailable: () => unavailable(current),
          );
    return ClipRRect(
      borderRadius: BorderRadius.circular(SafeRadius.map),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: Color(0xffe4ece4)),
          KeyedSubtree(key: ValueKey((current, sample)), child: map),
          Positioned(
            top: 12,
            left: 12,
            right: 68,
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: Tag(s.mapLegend, Icons.layers_outlined),
            ),
          ),
          if (actions case final active?)
            Positioned(
              top: 12,
              right: 12,
              child: MapControls(actions: active, hasTracker: sample != null),
            ),
          if (!kIsWeb && current == _Provider.mapLibre && actions != null)
            Positioned(
              left: 0,
              bottom: 0,
              child: ColoredBox(
                color: surface,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  child: Text(
                    '© OpenStreetMap · © OpenMapTiles',
                    style: context.type.labelSmall?.copyWith(color: ink),
                  ),
                ),
              ),
            ),
          if (widget.status == TrackerStatus.loading || actions == null)
            Center(child: CircularProgressIndicator(semanticsLabel: s.loading)),
        ],
      ),
    );
  }
}

class _MapLibreSurface extends StatefulWidget {
  const _MapLibreSurface({
    required this.point,
    required this.accuracy,
    required this.onReady,
    required this.onUnavailable,
  });

  final MapPoint point;
  final int? accuracy;
  final ValueChanged<MapActions> onReady;
  final VoidCallback onUnavailable;

  @override
  State<_MapLibreSurface> createState() => _MapLibreSurfaceState();
}

class _MapLibreSurfaceState extends State<_MapLibreSurface> {
  late ml.MapLibreMapController controller;
  ml.LatLng get target =>
      ml.LatLng(widget.point.latitude, widget.point.longitude);

  Future<void> loadAnnotations() async {
    try {
      if (widget.accuracy case final meters?) {
        final latScale =
            111320 * math.cos(widget.point.latitude * math.pi / 180);
        await controller.addFill(
          ml.FillOptions(
            geometry: [
              [
                for (var n = 0; n <= 48; n++)
                  ml.LatLng(
                    target.latitude +
                        math.sin(n * math.pi / 24) * meters / 111320,
                    target.longitude +
                        math.cos(n * math.pi / 24) * meters / latScale,
                  ),
              ],
            ],
            fillColor: '#17493b',
            fillOpacity: .23,
            fillOutlineColor: '#17493b',
          ),
        );
        if (!mounted) return;
        await controller.addCircle(
          ml.CircleOptions(
            geometry: target,
            circleRadius: 9,
            circleColor: '#17493b',
            circleStrokeColor: '#ffffff',
            circleStrokeWidth: 3,
          ),
        );
      }
      if (!mounted) return;
      widget.onReady(
        MapActions(
          zoom: (delta) {
            final next = ((controller.cameraPosition?.zoom ?? 16) + delta)
                .clamp(3.0, 19.0);
            unawaited(controller.animateCamera(ml.CameraUpdate.zoomTo(next)));
          },
          recenter: () => unawaited(
            controller.animateCamera(ml.CameraUpdate.newLatLng(target)),
          ),
        ),
      );
    } catch (_) {
      if (mounted) widget.onUnavailable();
    }
  }

  @override
  Widget build(BuildContext context) => ml.MapLibreMap(
    styleString: 'https://tiles.openfreemap.org/styles/positron',
    initialCameraPosition: ml.CameraPosition(target: target, zoom: 16),
    onMapCreated: (created) => controller = created,
    onStyleLoadedCallback: loadAnnotations,
    trackCameraPosition: true,
    rotateGesturesEnabled: false,
    tiltGesturesEnabled: false,
    minMaxZoomPreference: const ml.MinMaxZoomPreference(3, 19),
    annotationOrder: const [ml.AnnotationType.fill, ml.AnnotationType.circle],
  );
}
