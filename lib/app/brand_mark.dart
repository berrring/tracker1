import 'package:material_ui/material_ui.dart';

import 'design_tokens.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 38});
  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox.square(
      dimension: size,
      child: const CustomPaint(painter: _Mark()),
    ),
  );
}

class _Mark extends CustomPainter {
  const _Mark();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 40, size.height / 40);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, 40, 40),
        const Radius.circular(11),
      ),
      Paint()..color = primary,
    );
    final route = Path()
      ..moveTo(8, 29)
      ..cubicTo(13, 29, 16, 26, 17, 21)
      ..lineTo(18, 17)
      ..cubicTo(19, 13, 23, 11, 27, 11);
    canvas.drawPath(
      route,
      Paint()
        ..color = const Color(0xffbce5c2)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 2.8,
    );
    canvas.drawCircle(const Offset(29, 11), 4, Paint()..color = surface);
    canvas.drawCircle(const Offset(29, 11), 1.5, Paint()..color = primary);
    canvas.drawCircle(
      const Offset(11, 20),
      2.2,
      Paint()..color = const Color(0xffbce5c2),
    );
    canvas.drawCircle(
      const Offset(26, 26),
      2.2,
      Paint()..color = const Color(0xffbce5c2),
    );
  }

  @override
  bool shouldRepaint(covariant _Mark oldDelegate) => false;
}
