import 'package:flutter/material.dart';
import 'package:routelog_project/core/widgets/soft_info_card.dart';

class RecentRouteTile extends StatelessWidget {
  const RecentRouteTile({super.key, required this.title, required this.meta, this.onTap});
  final String title; final String meta; final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return SoftInfoCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: cs.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: const Icon(Icons.map_rounded),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: t.titleSmall?.copyWith(fontWeight: FontWeight.w700, height: 1.2)),
                const SizedBox(height: 4),
                Text(meta, style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant, height: 1.2)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}
