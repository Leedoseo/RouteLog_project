import 'package:flutter/material.dart';

/// 선택형 칩(토글) - 라벨만 노출. 선택시 강조

class SelectChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const SelectChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      showCheckmark: false,
      side: BorderSide(color: cs.outlineVariant),
      selectedColor: cs.primaryContainer,
      backgroundColor: cs.surfaceContainerHighest,
      labelStyle: Theme.of(context).textTheme.labelLarge,
    );
  }
}