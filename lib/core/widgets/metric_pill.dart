import 'package:flutter/material.dart';

class MetricPill extends StatelessWidget {
  const MetricPill({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.color,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final base = color ?? cs.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: base.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: base.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: base),
            const SizedBox(width: 6),
          ],
          Text(value, style: t.labelLarge?.copyWith(fontWeight: FontWeight.w700, color: base)),
          const SizedBox(width: 6),
          Text(label, style: t.labelSmall?.copyWith(color: cs.onSurfaceVariant)),
        ],
      ),
    );
  }
}