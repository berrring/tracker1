import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:material_ui/material_ui.dart';
import 'package:web/web.dart' as web;

import 'map_model.dart';

@JS('safeTrackMapGl.mount')
external JSFunction _mount(
  web.HTMLDivElement element,
  JSNumber longitude,
  JSNumber latitude,
  JSNumber? accuracy,
  JSFunction onReady,
  JSFunction onUnavailable,
);

Widget createMapGlSurface({
  required MapPoint point,
  required int? accuracy,
  required ValueChanged<MapActions> onReady,
  required VoidCallback onUnavailable,
}) => _MapGlSurface(
  point: point,
  accuracy: accuracy,
  onReady: onReady,
  onUnavailable: onUnavailable,
);

class _MapGlSurface extends StatefulWidget {
  const _MapGlSurface({
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
  State<_MapGlSurface> createState() => _MapGlSurfaceState();
}

class _MapGlSurfaceState extends State<_MapGlSurface> {
  static const viewType = 'safetrack-mapgl';
  static final registered = ui_web.platformViewRegistry.registerViewFactory(
    viewType,
    (_) => web.HTMLDivElement()
      ..style.width = '100%'
      ..style.height = '100%',
  );
  JSFunction? disposeMap;

  void attach(int id) {
    try {
      disposeMap = _mount(
        ui_web.platformViewRegistry.getViewById(id) as web.HTMLDivElement,
        widget.point.longitude.toJS,
        widget.point.latitude.toJS,
        widget.accuracy?.toJS,
        ((JSFunction zoom, JSFunction center) {
          if (!mounted) return;
          widget.onReady(
            MapActions(
              zoom: (delta) => zoom.callAsFunction(null, delta.toJS),
              recenter: () => center.callAsFunction(),
            ),
          );
        }).toJS,
        (() {
          if (mounted) widget.onUnavailable();
        }).toJS,
      );
    } catch (_) {
      if (mounted) widget.onUnavailable();
    }
  }

  @override
  void dispose() {
    disposeMap?.callAsFunction();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => registered
      ? HtmlElementView(viewType: viewType, onPlatformViewCreated: attach)
      : const SizedBox.shrink();
}
