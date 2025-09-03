import 'package:flutter/material.dart';

// 메모 카드
class MemoCard extends StatelessWidget {
  final String text;
  final VoidCallback onEditTap;

  const MemoCard({
    super.key,
    required this.text,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.notes_rounded),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
          IconButton(
            tooltip: "메포 편집(미구현)",
            icon: const Icon(Icons.edit_outlined),
            onPressed: onEditTap,
          ),
        ],
      ),
    );
  }
}