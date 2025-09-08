import 'package:flutter/material.dart';
import 'package:routelog_project/features/routes/edit_note_sheet.dart';

// Route 액션 시트
Future<void> showRouteActionsSheet(
    BuildContext context, {
      String? memoText,
      List<String>? availableTags,
      Set<String>? selectedTags,
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

          // 공유
          ListTile(
            leading: const Icon(Icons.ios_share_rounded),
            title: const Text('공유하기'),
            onTap: () {
              Navigator.of(sheetCtx).pop();
              _snack('공유는 나중에 연결');
            },
          ),

          // 편집 (메모+태그 시트)
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('편집하기'),
            onTap: () async {
              Navigator.of(sheetCtx).pop(); // 시트 닫고
              await showEditNoteSheet(
                context,
                initialText: memoText,
                availableTags: availableTags,
                initialSelectedTags: selectedTags,
              );
            },
          ),

          // GPX 내보내기
          ListTile(
            leading: const Icon(Icons.file_upload_outlined),
            title: const Text('GPX 내보내기'),
            onTap: () {
              Navigator.of(sheetCtx).pop();
              _snack('내보내기는 나중에 연결');
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
