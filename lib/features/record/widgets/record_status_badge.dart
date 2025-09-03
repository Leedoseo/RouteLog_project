import 'package:flutter/material.dart';

class RecordStatusBadge extends StatelessWidget {
  final String statusText;
  const RecordStatusBadge({
    super.key,
    required this.statusText,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: cs.secondaryContainer,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.circle, size: 10),
            const SizedBox(width: 6),
            Text(statusText, style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}