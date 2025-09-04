import 'package:flutter/material.dart';
/// - 토글 가능한 칩들(UI만). 선택 상태는 부모에서 Set<String>으로 관리.
/// - props:
///   - tags: 전체 태그 리스트
///   - selected: 선택된 태그 집합(참조 전달)
///   - onToggle: 태그 눌렀을 때 호출(String tag)
class TagSelector extends StatelessWidget {
  final List<String> tags;
  final Set<String> selected;
  final void Function(String tag) onToggle;

  const TagSelector({
    super.key,
    required this.tags,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final tag in tags)
          FilterChip(
            label: Text("#$tag"),
            selected: selected.contains(tag),
            onSelected: (_) => onToggle(tag),
            showCheckmark: false,
            side: BorderSide(color: cs.outlineVariant),
            selectedColor: cs.primaryContainer,
            backgroundColor: cs.surfaceContainerHighest,
            labelStyle: theme.textTheme.labelLarge,
          ),
      ],
    );
  }
}