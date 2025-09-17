import 'package:flutter/material.dart';
import 'package:routelog_project/features/routes/widgets/filter_section_title.dart';

/// 루트 목록 필터/정렬 바텀시트 (UI 목업)
/// - 실제 값 저장/적용은 아직 미구현: 스낵바로만 안내
Future<void> showRouteFilterSheet(
    BuildContext context, {
      String? initialQuickRange, // "thisWeek" | "thisMonth" | "all"
    }) {
  return showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetCtx) {
      String quick = initialQuickRange ?? "all";

      void snack(String m) =>
          ScaffoldMessenger.of(sheetCtx).showSnackBar(SnackBar(content: Text(m)));

      return StatefulBuilder(
        builder: (ctx, setState) {
          final cs = Theme.of(ctx).colorScheme;
          final bottom = MediaQuery.of(ctx).viewInsets.bottom;

          Widget quickChip(String value, String label) {
            final selected = quick == value;
            return ChoiceChip(
              label: Text(label),
              selected: selected,
              onSelected: (_) => setState(() => quick = value),
              selectedColor: cs.primaryContainer,
              side: BorderSide(color: cs.outlineVariant),
              showCheckmark: false,
            );
          }

          return Padding(
            padding: EdgeInsets.only(bottom: bottom),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 헤더
                  Row(
                    children: [
                      Text(
                        "필터",
                        style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: "닫기",
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // 섹션: 기간(빠른 선택)
                  const FilterSectionTitle("기간"),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      quickChip("thisWeek", "이번 주"),
                      quickChip("thisMonth", "이번 달"),
                      quickChip("all", "전체"),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // (옵션) 추가 필터 섹션들 — 지금은 목업용 자리만
                  const FilterSectionTitle("추가 필터"),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Text(
                      "거리 범위, 페이스, 시간대 등의 필터는 나중에 추가",
                      style: Theme.of(ctx).textTheme.bodySmall,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 하단 액션
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // 초기화: 전체
                            setState(() => quick = "all");
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text("초기화"),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            snack("필터 적용(목업): quick=$quick");
                            Navigator.of(ctx).pop();
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text("적용"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}