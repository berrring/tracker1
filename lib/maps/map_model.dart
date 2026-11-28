import 'package:material_ui/material_ui.dart';

import '../app/design.dart';
import '../data/mock_tracker_repository.dart';

class MapPoint {
  const MapPoint(this.latitude, this.longitude);

  static const bishkek = MapPoint(42.8757, 74.6026);

  factory MapPoint.demo(LocationSample? sample) => sample == null
      ? bishkek
      : MapPoint(
          bishkek.latitude + (.5 - sample.y) * .015,
          bishkek.longitude + (sample.x - .5) * .020,
        );

  final double latitude;
  final double longitude;
}

class MapActions {
  const MapActions({required this.zoom, required this.recenter});
  final ValueChanged<int> zoom;
  final VoidCallback recenter;
}

class MapControls extends StatelessWidget {
  const MapControls({
    super.key,
    required this.actions,
    required this.hasTracker,
  });
  final MapActions actions;
  final bool hasTracker;

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    return Material(
      color: surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SafeRadius.control),
        side: const BorderSide(color: line),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: s.mapZoomIn,
            onPressed: () => actions.zoom(1),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            tooltip: s.mapZoomOut,
            onPressed: () => actions.zoom(-1),
            icon: const Icon(Icons.remove),
          ),
          if (hasTracker)
            IconButton(
              tooltip: s.recenter,
              onPressed: actions.recenter,
              icon: const Icon(SafeIcons.center),
            ),
        ],
      ),
    );
  }
}
