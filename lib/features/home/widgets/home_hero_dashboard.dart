import 'package:flutter/material.dart';
import 'package:routelog_project/core/widgets/soft_info_card.dart';
import 'package:routelog_project/core/widgets/radial_gauge.dart';
import 'package:routelog_project/core/widgets/metric_pill.dart';

class HomeHeroDashboard extends StatelessWidget {
  const HomeHeroDashboard({
    super.key,
    required this.durationMinutes,
    required this.progress, // 0~1
  });

  final int durationMinutes;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return SoftInfoCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          RadialGauge(
            progress: progress,
            size: 160,
            thickness: 14,
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$durationMinutes', style: t.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
                Text('MIN', style: t.labelLarge?.copyWith(color: cs.onSurfaceVariant)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DURATION', style: t.labelSmall?.copyWith(color: cs.onSurfaceVariant)),
                const SizedBox(height: 4),
                Text('$durationMinutes minutes', style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(
                  '오늘 러닝 세션이 진행 중이에요. 목표를 향해 계속 달려볼까요?',
                  style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: [
                    const MetricPill(label: 'DISTANCE', value: '5.0km', icon: Icons.route),
                    const MetricPill(label: 'PACE', value: '5\'15"/km', icon: Icons.speed),
                    MetricPill(label: 'HR', value: '148bpm', icon: Icons.favorite, color: cs.tertiary),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
