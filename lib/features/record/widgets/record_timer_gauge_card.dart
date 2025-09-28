import 'package:flutter/material.dart';
import 'package:routelog_project/core/widgets/soft_info_card.dart';
import 'package:routelog_project/core/widgets/radial_gauge.dart';
import 'package:routelog_project/core/widgets/metric_pill.dart';

class RecordTimerGaugeCard extends StatelessWidget {
  const RecordTimerGaugeCard({
    super.key,
    required this.progress,
    required this.durationText,
    required this.distanceText,
    required this.paceText,
    required this.heartRateText,
  });

  final double progress;
  final String durationText;
  final String distanceText;
  final String paceText;
  final String heartRateText;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return SoftInfoCard(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, c) {
          final size = (c.maxWidth * 0.6).clamp(160.0, 220.0);
          return Column(
            children: [
              RadialGauge(
                size: size,
                progress: progress,
                thickness: 16,
                center: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      durationText,
                      maxLines: 3,
                      softWrap: false,
                      style: t.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                        'DURATION',
                        style: t.labelLarge?.copyWith(
                            color: cs.onSurfaceVariant
                        ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  MetricPill(label: 'DISTANCE', value: distanceText, icon: Icons.route),
                  MetricPill(label: 'PACE', value: paceText, icon: Icons.speed),
                  MetricPill(label: 'HR', value: heartRateText, icon: Icons.favorite, color: cs.tertiary),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}