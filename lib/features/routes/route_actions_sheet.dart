import 'package:flutter/material.dart';
import 'package:routelog_project/features/routes/edit_note_sheet.dart';
import 'package:routelog_project/features/routes/route_export_sheet.dart';

/// Route 액션 시트
/// - 공유/GPX를 하나의 "내보내기"로 통합 -> `showRouteExportSheet` 호출
/// - 메모/태그 편집 시 `showEditNoteSheet`
/// - 삭제는 확인 다이얼로그 후 스낵바(목업)
Future<void> showRouteActionsSheet(
    BuildContext context, {
      String? routeTitle,                 // 내보내기 시트 헤더에 표기하고 싶을 때 옵션
      String? memoText,                   // 편집 시 초기 메모
      List<String>? availableTags,        // 편집 시 선택 가능한 태그
      Set<String>? selectedTags,          // 편집 시 처음 선택된 태그
    }) {
  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  return showModalBottomSheet(
    context: context,
    useSafeArea: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetCtx) {
      final cs = Theme.of(sheetCtx).colorScheme;

      // 삭제 확인 다이얼로그
      Future<void> _confirmDelete() async {
        final ok = await showDialog<bool>(
          context: sheetCtx,
          builder: (dCtx) => AlertDialog(
            title: const Text('삭제하시겠어요?'),
            content: const Text('이 루트를 삭제하면 복구할 수 없습니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dCtx).pop(false),
                child: const Text('취소'),
              ),
              FilledButton.tonal(
                onPressed: () => Navigator.of(dCtx).pop(true),
                child: const Text('삭제'),
              ),
            ],
          ),
        );

        if (ok == true) {
          Navigator.of(sheetCtx).pop(); // 시트 닫기
          _snack('삭제는 나중에 연결');
        }
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 헤더
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Row(
              children: [
                Text(
                  '루트 액션',
                  style: Theme.of(sheetCtx).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // 내보내기 (공유/GPX 통합)
          ListTile(
            leading: const Icon(Icons.ios_share_rounded),
            title: const Text('내보내기'),
            onTap: () {
              // 현재 시트 닫고, 바깥 context로 Export 시트 띄우기
              Navigator.of(sheetCtx).pop();
              Future.microtask(() => showRouteExportSheet(
                context,
                routeTitle: routeTitle,
              ));
            },
          ),

          // 편집 (메모+태그)
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('편집하기'),
            onTap: () async {
              Navigator.of(sheetCtx).pop(); // 시트 닫기
              await showEditNoteSheet(
                context,
                initialText: memoText,
                availableTags: availableTags,
                initialSelectedTags: selectedTags,
              );
            },
          ),

          // 삭제
          ListTile(
            leading: Icon(Icons.delete_forever_rounded, color: cs.error),
            title: Text('삭제', style: TextStyle(color: cs.error)),
            onTap: _confirmDelete,
          ),

          const Divider(height: 1),

          // 취소
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(sheetCtx).pop(),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('취소'),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}