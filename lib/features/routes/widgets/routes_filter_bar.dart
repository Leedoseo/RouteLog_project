import 'package:flutter/material.dart';

class RoutesFilterBar extends StatelessWidget {
  final VoidCallback onSortTap;
  final VoidCallback onFilterTap;
  final VoidCallback onTagTap;

  const RoutesFilterBar({
    super.key,
    required this.onSortTap,
    required this.onFilterTap,
    required this.onTagTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onSortTap,
            icon: const Icon(Icons.sort_rounded),
            label: const Text("정렬"),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onFilterTap,
            icon: const Icon(Icons.filter_list_rounded),
            label: const Text("필터"),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: InkWell(
            onTap: onTagTap,
            borderRadius: BorderRadius.circular(12),
            child: Ink(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.sell_outlined),
                  const SizedBox(width: 6),
                  Text("태그", style: Theme.of(context).textTheme.labelLarge),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}