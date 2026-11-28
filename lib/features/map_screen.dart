import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../app/design.dart';
import '../data/mock_tracker_repository.dart';
import '../maps/map_model.dart';
import '../maps/tracker_map.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({
    super.key,
    required this.repo,
    required this.onPair,
    required this.interactiveMaps,
    required this.onOpenDevice,
  });
  final MockTrackerRepository repo;
  final VoidCallback onPair;
  final VoidCallback onOpenDevice;
  final bool interactiveMaps;

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final status = repo.status;
    final sample = repo.location;
    final selector = Panel(
      padding: EdgeInsets.zero,
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SafeRadius.card),
        ),
        leading: const CircleAvatar(
          backgroundColor: primaryContainer,
          foregroundColor: primary,
          child: Icon(SafeIcons.person),
        ),
        title: Text(repo.hasTracker ? s.ayan : s.empty),
        subtitle: repo.hasTracker ? Text(s.tracker) : null,
        trailing: const Icon(SafeIcons.expand),
        onTap: () async {
          final add = await showModalBottomSheet<bool>(
            context: context,
            showDragHandle: true,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (context) => SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  SafeSpace.lg,
                  0,
                  SafeSpace.lg,
                  SafeSpace.lg,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(s.selectTracker, style: context.type.titleLarge),
                    if (repo.hasTracker)
                      ListTile(
                        leading: const Icon(SafeIcons.success),
                        title: Text(s.tracker),
                        onTap: () => Navigator.pop(context, false),
                      ),
                    TextButton.icon(
                      icon: const Icon(SafeIcons.addTracker),
                      onPressed: () => Navigator.pop(context, true),
                      label: Text(s.add),
                    ),
                  ],
                ),
              ),
            ),
          );
          if (add == true && context.mounted) onPair();
        },
      ),
    );
    final wide =
        MediaQuery.sizeOf(context).width >= SafeLayout.desktopBreakpoint;
    final map = SizedBox(
      key: const ValueKey('dashboard-map'),
      height: wide
          ? (MediaQuery.sizeOf(context).height - 135).clamp(400, 760).toDouble()
          : (MediaQuery.sizeOf(context).height * .43)
                .clamp(235, 460)
                .toDouble(),
      child: TrackerMap(
        sample: sample,
        status: status,
        interactive: interactiveMaps,
        illustration: DemoMap(sample: sample, status: status),
      ),
    );
    final details = <Widget>[
      if (sample != null) ...[
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatusTag(status),
              const SizedBox(height: SafeSpace.sm),
              Semantics(
                header: true,
                child: Text(s.sample, style: context.type.titleLarge),
              ),
              if (status != TrackerStatus.fresh) ...[
                const SizedBox(height: SafeSpace.xs),
                Text(status.detail(s)),
              ],
              const SizedBox(height: SafeSpace.md),
              MetricGrid(
                metrics: [
                  Metric(SafeIcons.time, s.time, locationTime(s, status)),
                  Metric(
                    SafeIcons.accuracy,
                    s.accuracy,
                    switch (sample.accuracy) {
                      32 => s.accuracyStale,
                      24 => s.accuracyOffline,
                      _ => s.accuracyGood,
                    },
                  ),
                  Metric(
                    status == TrackerStatus.lowBattery
                        ? SafeIcons.batteryAlert
                        : SafeIcons.battery,
                    s.battery,
                    '${repo.battery}%',
                  ),
                  Metric(
                    repo.isOffline
                        ? Icons.cloud_off_outlined
                        : SafeIcons.network,
                    s.network,
                    networkLabel(s, repo),
                  ),
                ],
              ),
              const Divider(height: SafeSpace.xl),
              Metric(Icons.update, s.lastContact, lastContact(s, repo)),
              const SizedBox(height: SafeSpace.sm),
              Text(s.mapDemoDetails),
            ],
          ),
        ),
      ] else ...[
        StatusPanel(
          status,
          action: switch (status) {
            TrackerStatus.empty => FilledButton.icon(
              onPressed: onPair,
              icon: const Icon(SafeIcons.addTracker),
              label: Text(s.add),
            ),
            TrackerStatus.error => OutlinedButton(
              onPressed: () => repo.select(TrackerStatus.fresh),
              child: Text(s.retry),
            ),
            _ => null,
          },
        ),
        if (repo.hasDeviceData) ...[
          const SizedBox(height: SafeSpace.md),
          Panel(
            child: Column(
              children: [
                Metric(SafeIcons.battery, s.battery, '${repo.battery}%'),
                const SizedBox(height: SafeSpace.md),
                Metric(SafeIcons.network, s.network, networkLabel(s, repo)),
              ],
            ),
          ),
        ],
      ],
    ];
    if (wide) {
      return PageList(
        maxWidth: double.infinity,
        inset: SafeSpace.xl,
        storageKey: const PageStorageKey('map'),
        children: [
          SectionHeading(s.map, ''),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: map),
              const SizedBox(width: SafeSpace.lg),
              SizedBox(
                width: 308,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    selector,
                    const SizedBox(height: SafeSpace.md),
                    ...details,
                    const SizedBox(height: SafeSpace.md),
                    OutlinedButton.icon(
                      onPressed: onOpenDevice,
                      icon: const Icon(SafeIcons.tracker),
                      label: Text(s.device),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }
    return PageList(
      storageKey: const PageStorageKey('map'),
      children: [
        map,
        const SizedBox(height: SafeSpace.md),
        selector,
        const SizedBox(height: SafeSpace.md),
        ...details,
      ],
    );
  }
}

class DemoMap extends StatefulWidget {
  const DemoMap({super.key, required this.sample, required this.status});
  final LocationSample? sample;
  final TrackerStatus status;

  @override
  State<DemoMap> createState() => _DemoMapState();
}

class _DemoMapState extends State<DemoMap> {
  final controller = TransformationController();

  @override
  void didUpdateWidget(DemoMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sample != widget.sample) {
      controller.value = Matrix4.identity();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final sample = widget.sample;
    return ClipRRect(
      borderRadius: BorderRadius.circular(SafeRadius.map),
      child: ColoredBox(
        color: const Color(0xffe9eee7),
        child: LayoutBuilder(
          builder: (context, bounds) => Stack(
            fit: StackFit.expand,
            children: [
              ExcludeSemantics(
                child: InteractiveViewer(
                  transformationController: controller,
                  boundaryMargin: const EdgeInsets.all(72),
                  minScale: 1,
                  maxScale: 2.5,
                  child: SizedBox(
                    width: bounds.maxWidth,
                    height: bounds.maxHeight,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _MapPainter(
                              sample: sample,
                              labels: [s.park, s.square, s.river, s.lane],
                            ),
                          ),
                        ),
                        if (sample != null)
                          Positioned(
                            left: sample.x * bounds.maxWidth - 21,
                            top: sample.y * bounds.maxHeight - 21,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border.all(color: surface, width: 3),
                                shape: BoxShape.circle,
                                color: widget.status.accent,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x30000000),
                                    blurRadius: 8,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const SizedBox.square(
                                dimension: 42,
                                child: Icon(
                                  Icons.person,
                                  size: 22,
                                  color: surface,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                right: 68,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    color: surface,
                    borderRadius: BorderRadius.circular(SafeRadius.map),
                    child: Tag(s.mapLedger, Icons.layers_outlined),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: MapControls(
                  hasTracker: sample != null,
                  actions: MapActions(
                    zoom: (delta) {
                      final value = controller.value;
                      final previous = value.getMaxScaleOnAxis();
                      final next = (previous + delta * .35).clamp(1.0, 2.5);
                      final ratio = next / previous;
                      final center = Offset(
                        bounds.maxWidth / 2,
                        bounds.maxHeight / 2,
                      );
                      final translation = value.getTranslation();
                      controller.value = Matrix4.diagonal3Values(next, next, 1)
                        ..setTranslationRaw(
                          center.dx + (translation.x - center.dx) * ratio,
                          center.dy + (translation.y - center.dy) * ratio,
                          0,
                        );
                    },
                    recenter: () {
                      if (sample == null) return;
                      final scale = controller.value.getMaxScaleOnAxis();
                      controller.value =
                          Matrix4.diagonal3Values(scale, scale, 1)
                            ..setTranslationRaw(
                              bounds.maxWidth * (.5 - sample.x * scale),
                              bounds.maxHeight * (.5 - sample.y * scale),
                              0,
                            );
                    },
                  ),
                ),
              ),
              if (widget.status == TrackerStatus.loading)
                Center(
                  child: CircularProgressIndicator(semanticsLabel: s.loading),
                ),
              if (sample == null && widget.status != TrackerStatus.loading)
                Center(
                  child: Material(
                    shape: const CircleBorder(),
                    color: surface,
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Icon(
                        widget.status.icon,
                        color: widget.status.accent,
                        size: 32,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  const _MapPainter({required this.sample, required this.labels});
  final LocationSample? sample;
  final List<String> labels;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 360, size.height / 380);
    final paint = Paint()..color = const Color(0xffe9eee7);
    canvas.drawRect(const Rect.fromLTWH(-80, -90, 520, 560), paint);
    canvas.save();
    canvas.translate(182, 174);
    canvas.rotate(-.26);
    for (var row = -5; row < 7; row++) {
      for (var col = -5; col < 6; col++) {
        final x = col * 64.0;
        final y = row * 47.0;
        paint.color = (row + col) % 3 == 0
            ? const Color(0xffdbe7d8)
            : const Color(0xffdfe6de);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x + 5, y + 5, 54, 37),
            const Radius.circular(5),
          ),
          paint,
        );
        paint.color = const Color(0xffd4ded4);
        for (var unit = 0; unit < 3; unit++) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(
                x + 10 + 15.0 * unit,
                y + 9,
                10,
                10 + ((row + col + unit) % 3) * 7,
              ),
              const Radius.circular(2),
            ),
            paint,
          );
        }
      }
    }
    paint
      ..color = const Color(0xfff9faf4)
      ..strokeWidth = 6;
    for (var i = -5; i < 7; i++) {
      canvas.drawLine(Offset(-370, i * 47), Offset(380, i * 47), paint);
      canvas.drawLine(Offset(i * 64, -300), Offset(i * 64, 340), paint);
    }
    canvas.restore();
    final park = Path()
      ..moveTo(-20, 26)
      ..lineTo(60, 19)
      ..quadraticBezierTo(131, 38, 115, 93)
      ..lineTo(71, 127)
      ..quadraticBezierTo(40, 129, -20, 108)
      ..close();
    paint.color = const Color(0xffc8dfc8);
    canvas.drawPath(park, paint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(220, 256, 73, 53),
        const Radius.circular(12),
      ),
      paint,
    );
    final river = Path()
      ..moveTo(321, -80)
      ..cubicTo(255, 20, 388, 88, 338, 171)
      ..cubicTo(281, 252, 315, 315, 258, 454);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 28
      ..color = const Color(0xffb9d9dc);
    canvas.drawPath(river, paint);
    final avenue = Path()
      ..moveTo(-80, 302)
      ..cubicTo(40, 249, 80, 222, 153, 214)
      ..cubicTo(260, 201, 319, 214, 430, 128);
    paint
      ..strokeWidth = 13
      ..color = const Color(0xffdfd9bf);
    canvas.drawPath(avenue, paint);
    paint
      ..strokeWidth = 9
      ..color = const Color(0xfffff9e6);
    canvas.drawPath(avenue, paint);
    paint.style = PaintingStyle.fill;
    canvas.restore();
    final points = [
      const Offset(27, 76),
      const Offset(224, 275),
      const Offset(276, 106),
      const Offset(50, 244),
    ];
    for (var i = 0; i < labels.length; i++) {
      final text = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: const TextStyle(
            color: Color(0xff456358),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      text.paint(
        canvas,
        Offset(
          points[i].dx * size.width / 360,
          points[i].dy * size.height / 380,
        ),
      );
      text.dispose();
    }
    final location = sample;
    if (location != null) {
      final center = Offset(location.x * size.width, location.y * size.height);
      final radius = math.min(size.width * .24, 32 + location.accuracy * 1.2);
      canvas.drawCircle(
        center,
        radius,
        Paint()..color = primary.withValues(alpha: .14),
      );
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = primary.withValues(alpha: .55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(_MapPainter oldDelegate) =>
      oldDelegate.sample != sample ||
      oldDelegate.labels.join() != labels.join();
}
