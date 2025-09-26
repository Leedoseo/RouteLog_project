import 'package:flutter/material.dart';

class RecentSessionTile extends StatelessWidget {
  const RecentSessionTile({
    super.key,
    required this.date,
    required this.distance,
    required this.time,
    required this.pace,
  });

  final String date;
  final String distance;
  final String time;
  final String pace;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(Icons.directions_run_rounded, color: cs.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$date · $distance · $time · $pace',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
