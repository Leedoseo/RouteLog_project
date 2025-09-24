import 'package:flutter/material.dart';
import 'package:routelog_project/core/widgets/soft_info_card.dart';

class MiniStat extends StatelessWidget {
  const MiniStat({
    super.key,
    required this.icon,
    required this.label,
    required this.value
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return SoftInfoCard(
      child: Row(
        children: [
          Icon(icon, color: cs.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: t.labelSmall?.copyWith(color: cs.onSurfaceVariant)),
                const SizedBox(height: 4),
                Text(value, style: t.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
