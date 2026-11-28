import 'package:material_ui/material_ui.dart';

import 'map_model.dart';

Widget createMapGlSurface({
  required MapPoint point,
  required int? accuracy,
  required ValueChanged<MapActions> onReady,
  required VoidCallback onUnavailable,
}) => const SizedBox.shrink();
