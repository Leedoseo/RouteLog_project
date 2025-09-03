import 'package:flutter/material.dart';

// 태그
class TagChip extends StatelessWidget {
  final String label;
  const TagChip({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelLarge),
    );
  }
}