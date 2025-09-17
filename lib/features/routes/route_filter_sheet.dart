import 'package:flutter/material.dart';
import 'package:routelog_project/features/routes/widgets/tag_selector.dart';
import 'package:routelog_project/features/routes/widgets/filter_section_title.dart';
// import 'package:routelog_project/features/routes/widgets/select_chip.dart'; 추후 추가 예정

/// 루트 목록 필터/정렬 바텀시트 (UI 목업)
/// - 실제 값 저장/적용은 아직 미구현: 스낵바로만 안내
Future<void> showRouteFilterSheet(
    BuildContext context, {
      String? initialSort,               // 예: "latest" | "distance" | "duration" | "name"
      Set<String>? initialSelectedTags,  // 예: {"러닝", "주말"}
      String? initialQuickRange,         // 예: "thisMonth" | "thisWeek" | "all"
    }) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetCtx) {
      String sort = initialSort ?? "latest";
      String quickRange = initialQuickRange ?? "all";
      final Set<String> selectedTags = {...(initialSelectedTags ?? {})};

      // 목업용 태그 목록
      final tags = const ["러닝", "산책", "주말", "아침", "야간", "강변", "오르막", "내리막"];

      void snack(String msg) =>
          ScaffoldMessenger.of(sheetCtx).showSnackBar(SnackBar(content: Text(msg)));

      return StatefulBuilder(
        builder: (ctx, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 헤더
                  Row(
                    children: [
                      Text(
                        "필터 / 정렬",
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

                  // 정렬 섹션
                  const FilterSectionTitle("정렬"),
                  RadioListTile<String>(
                    value: "latest",
                    groupValue: sort,
                    title: const Text("최신순"),
                    onChanged: (v) => setModalState(() => sort = v!),
                  ),
                  RadioListTile<String>(
                    value: "distance",
                    groupValue: sort,
                    title: const Text("거리순"),
                    onChanged: (v) => setModalState(() => sort = v!),
                  ),
                  RadioListTile<String>(
                    value: "duration",
                    groupValue: sort,
                    title: const Text("시간순"),
                    onChanged: (v) => setModalState(() => sort = v!),
                  ),
                  RadioListTile<String>(
                    value: "name",
                    groupValue: sort,
                    title: const Text("이름순"),
                    onChanged: (v) => setModalState(() => sort = v!),
                  ),

                  const SizedBox(height: 12),

                  // 날짜 퀵 필터(목업): 이번 주/이번 달/전체
                  const FilterSectionTitle("기간"),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      SelectChip(
                        label: "이번 주",
                        selected: quickRange == "thisWeek",
                        onSelected: () => setModalState(() => quickRange = "thisWeek"),
                      ),
                      SelectChip(
                        label: "이번 달",
                        selected: quickRange == "thisMonth",
                        onSelected: () => setModalState(() => quickRange = "thisMonth"),
                      ),
                      SelectChip(
                        label: "전체",
                        selected: quickRange == "all",
                        onSelected: () => setModalState(() => quickRange = "all"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // 태그 선택
                  const FilterSectionTitle("태그"),
                  TagSelector(
                    tags: tags,
                    selected: selectedTags,
                    onToggle: (t) {
                      setModalState(() {
                        selectedTags.contains(t)
                            ? selectedTags.remove(t)
                            : selectedTags.add(t);
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  // 하단 액션
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setModalState(() {
                              sort = "latest";
                              quickRange = "all";
                              selectedTags.clear();
                            });
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
                            snack("적용은 나중에 연결 (정렬:$sort, 기간:$quickRange, 태그:${selectedTags.join(', ')})");
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
