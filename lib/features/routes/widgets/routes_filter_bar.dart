import 'package:flutter/material.dart';

class RoutesFilterBar extends StatelessWidget {
  final VoidCallback? onSortTap;
  final VoidCallback? onFilterTap;
  final VoidCallback? onTagTap;

  const RoutesFilterBar({
    super.key,
    this.onSortTap,
    this.onFilterTap,
    this.onTagTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onSortTap ?? () => _openPlaceholderSheet(context, '정렬'),
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
            onPressed: onFilterTap ?? () => _openPlaceholderSheet(context, '필터'),
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
            onTap: onTagTap ?? () => _openPlaceholderSheet(context, '태그'),
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

  void _openPlaceholderSheet(BuildContext context, String title) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$title (예시)', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Text('여기에 실제 $title 시트를 연결하세요.'),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('닫기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
