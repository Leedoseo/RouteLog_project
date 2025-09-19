import 'package:flutter/material.dart';

/// 적용된 필터들을 칩 형태로 보여주는 바(요약 UI개념)

class AppliedFiltersBar extends StatelessWidget {
  final List<String> tags;
  final String? distanceLabel;
  final String? durationLabel;
  final String? sortLabel;

  final void Function(String tag)? onClearTag;
  final VoidCallback? onClearDistance;
  final VoidCallback? onClearDuration;
  final VoidCallback? onClearSort;
  final VoidCallback? onClearAll;

  const AppliedFiltersBar({
    super.key,
    this.tags = const [],
    this.distanceLabel,
    this.durationLabel,
    this.sortLabel,
    this.onClearTag,
    this.onClearDistance,
    this.onClearDuration,
    this.onClearSort,
    this. onClearAll,d
  });

  bool get _hasAny =>
      tags.isNotEmpty ||
      (distanceLabel != null && distanceLabel!.isNotEmpty) ||
      (durationLabel != null && durationLabel!.isNotEmpty) ||
      (sortLabel != null && sortLabel!.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    if (!_hasAny) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    Widget chip({
      required Widget label,
      VoidCallback? onDeleted,
      IconData icon = Icons.filter_alt_rounded,
      String? tooltip,
    }) {
      return InputChip(
        label: label,
        avatar: Icon(icon, size: 18),
        onDeleted: onDeleted,
        deleteIcon: const Icon(Icons.close_rounded, size: 16),
        tooltip: tooltip,
        side: BorderSide(color: cs.outlineVariant),
        backgroundColor: cs.surfaceContainerHighest,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          // 태그 칩들
          for (final t in tags)
            chip(
              label: Text("#$t"),
              icon: Icons.tag_rounded,
              tooltip: "태그 제거",
              onDeleted: onClearTag == null ? null : () => onClearTag!(t),
            ),

          // 거리/시간/정렬 요약 칩
          if (distanceLabel != null && distanceLabel!.isNotEmpty)
            chip(
              label: Text("거리: ${distanceLabel!}"),
              icon: Icons.straighten_rounded,
              tooltip: "거리 필터 제거",
              onDeleted: onClearDistance,
            ),
          if (durationLabel != null && durationLabel!.isNotEmpty)
            chip(
              label: Text("시간: ${durationLabel!}"),
              icon: Icons.access_time_rounded,
              tooltip: "시간 필터 제거",
              onDeleted: onClearDuration,
            ),
          if (sortLabel != null && sortLabel!.isNotEmpty)
            chip(
              label: Text("정렬: ${sortLabel!}"),
              icon: Icons.swap_vert_rounded,
              tooltip: "정렬 해제",
              onDeleted: onClearSort,
            ),
        ],
      ),
    );
  }
}