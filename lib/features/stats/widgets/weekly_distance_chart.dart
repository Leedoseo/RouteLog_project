import 'package:flutter/material.dart';

/// WeeklyDistanceChart (목업용 간단 바 차트)
/// - 외부 차트 라이브러리 없이 막대 차트 느낌만 구현
/// - 값은 0.0~1.0 범위를 권장(자동 클램프)
/// - 실제 데이터 연동은 나중에 하고, 지금은 목업 시각화만 담당
class WeeklyDistanceChart extends StatelessWidget {
  final String title; // 제목
  final String? subtitle; // 부제목
  final List<double> values; // 막대 값 리스트
  final List<String>? labels; // 월 ~ 일
  final double barSpacing; // 막대 사이 간격
  final double barRadius;
  final double chartHeight; // 차트 영역 높이
  final double barVisualWidth; // 막대의 시각적 두께

  const WeeklyDistanceChart({
    super.key,
    required this.title,
    required this.values,
    this.subtitle,
    this.labels,
    this.barSpacing = 8,
    this.barRadius = 8,
    this.chartHeight = 140,
    this.barVisualWidth = 14,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final clamped = values.map((v) {
      if (v.isNaN || v.isInfinite) return 0.0;
      return v.clamp(0.0, 1.0);
    }).toList();

    final _labels = labels ?? const ["월", "화", "수", "목", "금", "토", "일"];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더: 제목/부제
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 차트 본문: 막대
          SizedBox(
            height: chartHeight,
            child: (clamped.isEmpty)
                ? Center(
              child: Text(
                '표시할 데이터가 없어요',
                style: theme.textTheme.bodySmall,
              ),
            )
                : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int i = 0; i < clamped.length; i++) ...[
                  // 각 막대를 동일 폭으로 분배(Expanded)하되,
                  // 실제 보이는 막대는 barVisualWidth로 제한해 날씬하게 보이게 함.
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        heightFactor: clamped[i], // 0~1
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: barVisualWidth,
                          decoration: BoxDecoration(
                            color: cs.primaryContainer,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(barRadius),
                              topRight: Radius.circular(barRadius),
                              bottomLeft: const Radius.circular(4),
                              bottomRight: const Radius.circular(4),
                            ),
                            border: Border.all(color: cs.outlineVariant),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (i != clamped.length - 1) SizedBox(width: barSpacing),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),

          // x축 라벨
          if (_labels.isNotEmpty) ...[
            Row(
              children: [
                for (int i = 0; i < clamped.length && i < _labels.length; i++) ...[
                  Expanded(
                    child: Center(
                      child: Text(
                        _labels[i],
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.textTheme.labelSmall?.color?.withOpacity(0.85),
                        ),
                      ),
                    ),
                  ),
                  if (i != clamped.length - 1) SizedBox(width: barSpacing),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
