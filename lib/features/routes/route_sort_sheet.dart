import 'package:flutter/material.dart';
import 'package:routelog_project/features/routes/widgets/filter_section_title.dart';

/// 정렬 전용 바텀시트(목업)

Future<void> showRouteSortSheet(
  BuildContext context,{
  String? initialSort, // "latest" | "distance" | "duration" | "name"
}) {
  return showModalBottomSheet(
    context: context,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetCtx) {
      String sort = initialSort ?? "latest";
      void snack(String m) =>
          ScaffoldMessenger.of(sheetCtx).showSnackBar(SnackBar(content: Text(m)));

      return StatefulBuilder(
        builder: (ctx, setState) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      "정렬",
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

                const FilterSectionTitle("기준"),
                RadioListTile<String>(
                  value: "latest",
                  groupValue: sort,
                  title: const Text("최신순"),
                  onChanged: (v) => setState(() => sort = v!),
                ),
                RadioListTile<String>(
                  value: "distance",
                  groupValue: sort,
                  title: const Text("거리순"),
                  onChanged: (v) => setState(() => sort = v!),
                ),
                RadioListTile<String>(
                  value: "duration",
                  groupValue: sort,
                  title: const Text("시간순"),
                  onChanged: (v) => setState(() => sort = v!),
                ),
                RadioListTile<String>(
                  value: "name",
                  groupValue: sort,
                  title: const Text("이름순"),
                  onChanged: (v) => setState(() => sort = v!),
                ),

                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text("취소"),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          snack("정렬 적용(목업): $sort");
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
          );
        },
      );
    }
  );
}