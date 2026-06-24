import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// Icon for the Pani Puri menu card — mirrors the inline SVG in index.html.
class PaniPuriIconPainter extends CustomPainter {
  const PaniPuriIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 100;
    canvas.scale(s);

    // Outer circle
    canvas.drawCircle(
      const Offset(50, 50),
      45,
      Paint()
        ..color = puriGold
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      const Offset(50, 50),
      45,
      Paint()
        ..color = puriGoldDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Filling ellipse
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(50, 35), width: 50, height: 24),
      Paint()
        ..color = const Color(0xFF8D6E63).withOpacity(0.6)
        ..style = PaintingStyle.fill,
    );

    // Green water arc
    final arcPath = Path()
      ..moveTo(35, 35)
      ..quadraticBezierTo(50, 45, 65, 35);
    canvas.drawPath(
      arcPath,
      Paint()
        ..color = paniGreen
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(PaniPuriIconPainter _) => false;
}

/// Icon for the Masala Chai menu card — mirrors the inline SVG in index.html.
class MasalaChaiIconPainter extends CustomPainter {
  const MasalaChaiIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 100;
    canvas.scale(s);

    // Tumbler body
    final tumblerPath = Path()
      ..moveTo(30, 30)
      ..lineTo(70, 30)
      ..lineTo(65, 90)
      ..lineTo(35, 90)
      ..close();

    canvas.drawPath(
      tumblerPath,
      Paint()
        ..color = const Color(0xFFB06D45)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      tumblerPath,
      Paint()
        ..color = const Color(0xFF8D4A2A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Tea surface ellipse
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(50, 30), width: 40, height: 10),
      Paint()
        ..color = const Color(0xFF5D4037)
        ..style = PaintingStyle.fill,
    );

    // Steam lines
    final steamPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final dx in [0.0, 10.0, 20.0]) {
      canvas.drawPath(
        Path()
          ..moveTo(40 + dx, 22)
          ..quadraticBezierTo(45 + dx, 12, 40 + dx, 5),
        steamPaint,
      );
    }
  }

  @override
  bool shouldRepaint(MasalaChaiIconPainter _) => false;
}
