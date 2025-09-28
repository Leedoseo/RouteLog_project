import 'package:flutter/material.dart';

class TrendCard extends StatelessWidget {
  const TrendCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.periodLabel,
    required this.values,
    this.xDivisions = 7,
  });

  final String title;
  final String subtitle;
  final String periodLabel;
  final List<double> values;
  final int xDivisions;

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
          Text(title, style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          SizedBox(
            height: 160,
            child: _MiniTrendChart(
              values: values,
              xDivisions: xDivisions,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _LegendDot(color: cs.primary),
              const SizedBox(width: 6),
              Text(subtitle, style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
              const Spacer(),
              Text(periodLabel, style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniTrendChart extends StatelessWidget {
  const _MiniTrendChart({required this.values, this.xDivisions = 7});
  final List<double> values;
  final int xDivisions;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return CustomPaint(
      painter: _TrendPainter(
        values: values,
        gridColor: cs.outlineVariant,
        lineColor: cs.primary,
        fillColor: cs.primary.withOpacity(0.12),
        axisColor: cs.onSurface.withOpacity(0.06),
        xDivisions: xDivisions,
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  _TrendPainter({
    required this.values,
    required this.gridColor,
    required this.lineColor,
    required this.fillColor,
    required this.axisColor,
    required this.xDivisions,
  });

  final List<double> values;
  final Color gridColor;
  final Color lineColor;
  final Color fillColor;
  final Color axisColor;
  final int xDivisions;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty || size.width <= 0 || size.height <= 0) return;

    final padding = const EdgeInsets.fromLTRB(8, 8, 8, 12);
    final chart = Rect.fromLTWH(
      padding.left,
      padding.top,
      size.width - padding.horizontal,
      size.height - padding.vertical,
    );

    // grid
    final grid = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    // 수평 3줄
    const hLines = 3;
    for (int i = 0; i <= hLines; i++) {
      final dy = chart.top + chart.height * (i / hLines);
      canvas.drawLine(Offset(chart.left, dy), Offset(chart.right, dy), grid);
    }

    // 수직 xDivisions 줄
    for (int i = 0; i <= xDivisions; i++) {
      final dx = chart.left + chart.width * (i / xDivisions);
      canvas.drawLine(Offset(dx, chart.top), Offset(dx, chart.bottom), grid..color = gridColor.withOpacity(0.6));
    }

    // 스케일
    final maxV = (values.reduce((a, b) => a > b ? a : b)).clamp(1.0, double.infinity);
    const minV = 0.0;
    final dxStep = chart.width / (values.length - 1);

    Path line = Path();
    for (int i = 0; i < values.length; i++) {
      final x = chart.left + dxStep * i;
      final norm = (values[i] - minV) / (maxV - minV);
      final y = chart.bottom - chart.height * norm;
      if (i == 0) {
        line.moveTo(x, y);
      } else {
        line.lineTo(x, y);
      }
    }

    // fill
    final fillPath = Path.from(line)
      ..lineTo(chart.right, chart.bottom)
      ..lineTo(chart.left, chart.bottom)
      ..close();

    final fillPaint = Paint()..color = fillColor;
    canvas.drawPath(fillPath, fillPaint);

    // line
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(line, linePaint);
  }

  @override
  bool shouldRepaint(covariant _TrendPainter old) {
    return old.values != values ||
        old.gridColor != gridColor ||
        old.lineColor != lineColor ||
        old.fillColor != fillColor ||
        old.xDivisions != xDivisions;
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10, height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
