import 'dart:math' as math;
import 'package:flutter/material.dart';

class RadialGauge extends StatelessWidget {
  const RadialGauge({
    super.key,
    required this.progress,
    this.size = 140,
    this.thickness = 12,
    this.backgroundOpacity = 0.15,
    this.center,
    this.color,
  });

  final double progress;
  final double size;
  final double thickness;
  final double backgroundOpacity;
  final Widget? center;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final active = color ?? cs.primary;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RadialPainter(
          progress: progress.clamp(0, 1),
          color: active,
          bg: cs.onSurface.withOpacity(backgroundOpacity),
          thickness: thickness,
        ),
        child: Center(child: center),
      ),
    );
  }
}

class _RadialPainter extends CustomPainter {
  _RadialPainter({
    required this.progress,
    required this.color,
    required this.bg,
    required this.thickness,
  });

  final double progress;
  final Color color, bg;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final radius = (size.shortestSide - thickness) / 2;
    final rect = Rect.fromCircle(center: c, radius: radius);
    final start = -math.pi / 2; // 12시 방향
    final sweep = 2 * math.pi * progress;

    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round
      ..color = bg;
    final fgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: [color, color.withOpacity(0.6)],
      ).createShader(rect);

    // 배경 링
    canvas.drawArc(rect, 0, 2 * math.pi, false, bgPaint);
    // 진행 링
    canvas.drawArc(rect, start, sweep, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant _RadialPainter old) =>
      old.progress != progress || old.color != color || old.thickness != thickness;
}