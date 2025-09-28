import 'package:flutter/material.dart';

enum FinishAction { save, discard }

Future<FinishAction?> showFinishSessionSheet(BuildContext context) {
  return showModalBottomSheet<FinishAction>(
    context: context,
    useSafeArea: true,
    showDragHandle: true,
    isScrollControlled: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      final cs = Theme.of(ctx).colorScheme;
      final t = Theme.of(ctx).textTheme;

      Widget tile(IconData icon, String title, String sub, FinishAction value, {Color? color}) {
        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.of(ctx).pop(value),
            child: Ink(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Row(
                children: [
                  Icon(icon, color: color ?? cs.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: t.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text(sub, style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(child: Text('세션 종료', style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700))),
                IconButton(
                  tooltip: '닫기',
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            tile(Icons.check_circle_rounded, '저장하고 종료', '현재 기록을 저장하고 세션을 마칩니다', FinishAction.save),
            const SizedBox(height: 8),
            tile(Icons.delete_forever_rounded, '삭제하고 종료', '이번 세션을 저장하지 않습니다', FinishAction.discard, color: cs.error),
          ],
        ),
      );
    },
  );
}
