import 'package:flutter/material.dart';
import 'package:routelog_project/core/widgets/soft_info_card.dart';
import 'package:routelog_project/core/widgets/radial_gauge.dart';
import 'package:routelog_project/core/widgets/metric_pill.dart';

class HomeHeroDashboard extends StatelessWidget {
  const HomeHeroDashboard({
    super.key,
    required this.durationMinutes, // 최근(또는 진행 중) 세션 분
    required this.progress,        // 0~1 (목표 대비 진행률)
    this.distanceKm,               // 배지: km
    this.paceSecPerKm,             // 배지: 초/킬로
    this.avgHr,                    // 배지: bpm (없으면 null)
  });

  final int durationMinutes;
  final double progress;
  final double? distanceKm;
  final double? paceSecPerKm;
  final int? avgHr;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    final distanceText = _fmtDistance(distanceKm);
    final paceText     = _fmtPace(paceSecPerKm);
    final hrText       = avgHr != null ? '${avgHr}bpm' : '-';

    return SoftInfoCard(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
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
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DURATION',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.labelSmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$durationMinutes minutes',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '오늘 러닝 세션이 진행 중이에요. 목표를 향해 계속 달려볼까요?',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        MetricPill(label: 'DISTANCE', value: distanceText, icon: Icons.route),
                        MetricPill(label: 'PACE', value: paceText, icon: Icons.speed),
                        MetricPill(label: 'HR', value: hrText, icon: Icons.favorite, color: cs.tertiary),
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

  static String _fmtDistance(double? km) {
    if (km == null || km.isNaN || km.isInfinite || km <= 0) return '-';
    return km >= 10 ? '${km.toStringAsFixed(0)} km' : '${km.toStringAsFixed(1)} km';
  }

  static String _fmtPace(double? secPerKm) {
    if (secPerKm == null || secPerKm.isNaN || secPerKm.isInfinite || secPerKm <= 0) return '-';
    final m = secPerKm ~/ 60;
    final s = (secPerKm % 60).round().toString().padLeft(2, '0');
    return "$m'$s\"/km";
  }
}
