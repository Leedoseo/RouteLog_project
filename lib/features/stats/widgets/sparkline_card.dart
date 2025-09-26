import 'dart:math' as math;
import 'package:flutter/material.dart';

class SparklineCard extends StatelessWidget {
  const SparklineCard({super.key, required this.title, required this.points});

  final String title;
  final List<double> points;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: t.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          SizedBox(
            height: 160,
            child: CustomPaint(
              painter: _SparklinePainter(cs: cs, data: points.isEmpty ? _mock : points),
            ),
          ),
        ],
      ),
    );
  }

  static List<double> get _mock {
    final n = 14;
    return List.generate(n, (i) {
      final t = i / (n - 1);
      return 5 + 3 * math.sin(t * math.pi * 2) + 1.2 * math.sin(t * math.pi * 6);
    });
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({required this.cs, required this.data});

  final ColorScheme cs;
  final List<double> data;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final pad = const EdgeInsets.fromLTRB(8, 8, 8, 8);
    final rect = Rect.fromLTWH(
      pad.left, pad.top, size.width - pad.horizontal, size.height - pad.vertical,
    );

    final minY = data.reduce(math.min);
    final maxY = data.reduce(math.max);
    double sx(int i) => rect.left + i / (data.length - 1) * rect.width;
    double sy(double v) => rect.bottom - (v - minY) / ((maxY - minY) == 0 ? 1 : (maxY - minY)) * rect.height;

    // area
    final area = Path()..moveTo(sx(0), rect.bottom);
    for (int i = 0; i < data.length; i++) {
      area.lineTo(sx(i), sy(data[i]));
    }
    area.lineTo(sx(data.length - 1), rect.bottom);
    area.close();
    final areaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [cs.primary.withOpacity(0.20), cs.primary.withOpacity(0.05)],
      ).createShader(rect);
    canvas.drawPath(area, areaPaint);

    // line
    final line = Path()..moveTo(sx(0), sy(data[0]));
    for (int i = 1; i < data.length; i++) {
      line.lineTo(sx(i), sy(data[i]));
    }
    canvas.drawPath(line, Paint()
      ..color = cs.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter old) => old.data != data || old.cs != cs;
}
