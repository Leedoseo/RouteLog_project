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
      child: LayoutBuilder(
        builder: (context, constraints) {
          // 화면/카드 폭에 따라 게이지 크기 자동 조절 (작은 기기에서 overflow 방지)
          final cardWidth = constraints.maxWidth;
          final gaugeSize = (cardWidth * 0.36).clamp(120.0, 160.0);

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RadialGauge(
                progress: progress,
                size: gaugeSize,
                thickness: 14,
                center: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$durationMinutes',
                      maxLines: 1,
                      softWrap: false,
                      style: t.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'MIN',
                      maxLines: 1,
                      softWrap: false,
                      style: t.labelLarge?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // 폭이 좁을 때 오른쪽 칼럼이 자연스럽게 줄어들도록 Flexible
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DURATION',
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: t.labelSmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$durationMinutes minutes',
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '오늘 러닝 세션이 진행 중이에요. 목표를 향해 계속 달려볼까요?',
                      maxLines: 2, // 설명은 두 줄까지만
                      overflow: TextOverflow.ellipsis,
                      style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: 12),
                    // Pill들은 줄바꿈 가능한 Wrap 유지 (Row면 overflow 발생)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
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
          );
        },
      ),
    );
  }
}
