import 'package:flutter/material.dart';

class SearchHistoryChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final bool dense;

  const SearchHistoryChip({
    super.key,
    required this.text,
    required this.onTap,
    this.onDelete,
    this.dense = false
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return InputChip(
      avatar: Icon(
        Icons.history_rounded,
        size: 18,
        color: theme.iconTheme.color?.withOpacity(0.8),
      ),
      label: Text(text),
      onPressed: onTap,
      onDeleted: onDelete,
      side: BorderSide(color: cs.outlineVariant),
      selectedColor: cs.primaryContainer,
      backgroundColor: cs.surfaceContainerHighest,
      labelStyle: theme.textTheme.labelLarge,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: dense ? const VisualDensity(horizontal: -2, vertical: -2) : null,
    );
  }
}