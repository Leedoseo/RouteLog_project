import 'package:flutter/material.dart';

// 날짜 - 거리 - 시간 - 페이스 한 줄 메타
class MetaRow extends StatelessWidget {
  final String dateText;
  final String distanceText;
  final String durationText;
  final String paceText;

  const MetaRow({super.key,
    required this.dateText,
    required this.distanceText,
    required this.durationText,
    required this.paceText,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget tile(String label, String value, {IconData? icon}) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: Theme.of(context).textTheme.labelSmall),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        Expanded(child: tile("날짜", dateText, icon: Icons.event)),
        const SizedBox(width: 8),
        Expanded(child: tile("거리", distanceText, icon: Icons.route_rounded)),
        const SizedBox(width: 8),
        Expanded(child: tile("시간", durationText, icon : Icons.access_time_rounded)),
        const SizedBox(width: 8),
        Expanded(child: tile("페이스", paceText, icon: Icons.directions_run_rounded)),
      ],
    );
  }
}