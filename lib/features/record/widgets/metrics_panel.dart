import 'package:flutter/material.dart';

class MetricsPanel extends StatelessWidget {
  final String distanceText;
  final String durationText;
  final String paceText;
  const MetricsPanel({
    required this.distanceText,
    required this.durationText,
    required this.paceText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _MetricTile(title: "거리", value: distanceText)),
          const SizedBox(width: 8),
          Expanded(child: _MetricTile(title: "시간", value: durationText)),
          const SizedBox(width: 8),
          Expanded(child: _MetricTile(title: "페이스", value: paceText)),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String title;
  final String value;
  const _MetricTile({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
          Text(title, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}