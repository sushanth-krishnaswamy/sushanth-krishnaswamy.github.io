import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// Data for one rain-drop particle; values mirror the JS original.
class RainDropData {
  final double speed;
  final double drift;
  final double burstY;
  final double delay;
  final double size;

  const RainDropData({
    required this.speed,
    required this.drift,
    required this.burstY,
    required this.delay,
    required this.size,
  });
}

/// Generate [count] deterministic rain-drop particles (fixed seed).
List<RainDropData> generateRainDrops({int count = 180, int seed = 42}) {
  final rng = Random(seed);
  return List.generate(
    count,
    (_) => RainDropData(
      speed: rng.nextDouble() * 2 + 1.2,
      drift: (rng.nextDouble() - 0.5) * 1400,
      burstY: (rng.nextDouble() - 0.5) * 450,
      delay: rng.nextDouble() * 0.25,
      size: rng.nextDouble() * 8 + 4,
    ),
  );
}

/// Draws the two-half puri shape and the exploding pani rain drops,
/// driven entirely by [scrollProgress] (0.0 → 1.2).
class PuriRainPainter extends CustomPainter {
  final double scrollProgress;
  final double scrollOffset;
  final List<RainDropData> rainDrops;
  final Size screenSize;

  const PuriRainPainter({
    required this.scrollProgress,
    required this.scrollOffset,
    required this.rainDrops,
    required this.screenSize,
  });

  // ── puri geometry ────────────────────────────────────────────────────────
  static const double _svgSize = 200;
  static const double _containerSize = 300;
  static const double _puriScale = _containerSize / _svgSize;

  double get _containerLeft => (screenSize.width - _containerSize) / 2;

  /// Mirrors JS: top: 55%; transform: translateY(-50%) + parallax
  double get _containerTop =>
      screenSize.height * 0.55 -
      _containerSize / 2 +
      scrollOffset * 0.05;

  // ── animation math (mirrors JS updateVisuals) ─────────────────────────
  double get _breakProgress => max(0.0, scrollProgress - 0.02);

  double get _yMove => _breakProgress * 550;
  double get _xMove => _breakProgress * 100;
  double get _rotateRad => _breakProgress * 50 * pi / 180;
  double get _puriOpacity =>
      scrollProgress < 0.02 ? 1.0 : max(0.0, 1.0 - _breakProgress * 1.8);

  @override
  void paint(Canvas canvas, Size size) {
    _drawPuriHalf(canvas, isTop: true);
    _drawPuriHalf(canvas, isTop: false);
    _drawRain(canvas);
  }

  void _drawPuriHalf(Canvas canvas, {required bool isTop}) {
    final opacity = _puriOpacity;
    if (opacity <= 0) return;

    canvas.save();

    // Position the 300×300 container on screen
    canvas.translate(_containerLeft, _containerTop);

    // Apply split-animation translation
    if (isTop) {
      canvas.translate(-_xMove, -_yMove);
    } else {
      canvas.translate(_xMove, _yMove);
    }

    // Rotate around the visual centre of each half
    // Top half centre in container coords ≈ (150, 105); bottom ≈ (150, 195)
    final pivotY = isTop ? 105.0 : 195.0;
    canvas.translate(150.0, pivotY);
    canvas.rotate(isTop ? -_rotateRad : _rotateRad);
    canvas.translate(-150.0, -pivotY);

    // Scale from 200-unit SVG space to 300px container
    canvas.scale(_puriScale);

    final fillPaint = Paint()
      ..color = puriGold.withOpacity(opacity)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = puriGoldDark.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    if (isTop) {
      // SVG: M30,100 Q30,40 100,40 Q170,40 170,100 L30,100
      path.moveTo(30, 100);
      path.quadraticBezierTo(30, 40, 100, 40);
      path.quadraticBezierTo(170, 40, 170, 100);
      path.lineTo(30, 100);
    } else {
      // SVG: M30,100 Q30,160 100,160 Q170,160 170,100 L30,100
      path.moveTo(30, 100);
      path.quadraticBezierTo(30, 160, 100, 160);
      path.quadraticBezierTo(170, 160, 170, 100);
      path.lineTo(30, 100);
    }

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);

    canvas.restore();
  }

  void _drawRain(Canvas canvas) {
    // Rain bursts from the puri centre, mirroring JS: left 50%, top 35%
    final originX = screenSize.width / 2;
    final originY = screenSize.height * 0.35;
    const rainStartThreshold = 0.04;

    for (final d in rainDrops) {
      final localProgress =
          max(0.0, scrollProgress - rainStartThreshold - d.delay);
      if (localProgress <= 0) continue;

      final y = localProgress * screenSize.height * 2.8 * d.speed +
          d.burstY * localProgress;
      final x = localProgress * d.drift;

      double opacity;
      if (localProgress < 0.04) {
        opacity = localProgress * 25;
      } else if (localProgress > 0.8) {
        opacity = max(0.0, 1.0 - (localProgress - 0.8) * 5);
      } else {
        opacity = 1.0;
      }
      if (opacity <= 0) continue;

      final scale = 1.0 + localProgress;
      final cx = originX + x;
      final cy = originY + y;

      canvas.save();
      canvas.translate(cx, cy);
      canvas.scale(scale);

      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: d.size, height: d.size),
        Paint()
          ..color = paniGreen.withOpacity(opacity)
          ..style = PaintingStyle.fill,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(PuriRainPainter old) =>
      old.scrollProgress != scrollProgress ||
      old.scrollOffset != scrollOffset ||
      old.screenSize != screenSize;
}
