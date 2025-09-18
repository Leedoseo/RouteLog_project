import 'package:flutter/material.dart';
import 'package:routelog_project/features/routes/widgets/tag_selector.dart';
import 'package:routelog_project/features/routes/widgets/filter_section_title.dart';


/// 태그 전용 바텀시트 (목업)
Future<void> showRouteTagSheet(
  BuildContext context, {
List<String>? availableTags,
Set<String>? initialSelectedTags,
}) {
  return showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetCtx) {
      final tags = availableTags ??
          const ["러닝", "산책", "주말", "아침", "야간", "강변", "오르막", "내리막"];

      final selected = {...(initialSelectedTags ?? const <String>{})};

      void snack(String m) => ScaffoldMessenger.of(sheetCtx).showSnackBar(SnackBar(content: Text(m)));

      return StatefulBuilder(
        builder: (ctx, setState) {
          final bottom = MediaQuery.of(ctx).viewInsets.bottom;

          return Padding(
            padding: EdgeInsets.only(bottom: bottom),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        "태그",
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

                  const FilterSectionTitle("선택"),
                  TagSelector(
                    tags: tags,
                    selected: selected,
                    onToggle: (t) {
                      setState(() {
                        selected.contains(t) ? selected.remove(t) : selected.add(t);
                      });
                    },
                  ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => setState(selected.clear),
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
                            snack("태그 적용(목업) ${selected.join(', ')}");
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
    }
  );
}