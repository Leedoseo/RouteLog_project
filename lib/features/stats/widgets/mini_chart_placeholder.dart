import 'package:flutter/material.dart';

class MiniChartPlaceholder extends StatelessWidget {
  final String title;
  final List<double> data;
  final String? subtitle;

  const MiniChartPlaceholder({
    super.key,
    required this.title,
    required this.data,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bars = data.isEmpty ? List.filled(7, 0.0) : data;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 타이틀
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
          ],
          const SizedBox(height: 12),

          // 막대 그래프 목업
          SizedBox(
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final v in bars) ...[
                  Expanded(
                    child: Container(
                      height: (v.clamp(0, 1) as double) * 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [cs.secondaryContainer, cs.primaryContainer],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
              ]..removeLast(), // 마지막 간격 제거
            ),
          ),
        ],
      ),
    );
  }
}