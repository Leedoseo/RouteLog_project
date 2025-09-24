import 'package:flutter/material.dart';

/// 스위치가 포함된 설정 타일 (Stateless)
/// - 패딩 통일: H16 / V8
/// - 라운드 통일: R12

class SettingsSwitchTile extends StatelessWidget {
  final IconData? leading;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsSwitchTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.leading,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final r = BorderRadius.circular(12);

    return InkWell(
      onTap: () => onChanged(!value), // 전체 영역 탭으로도 토글
      borderRadius: r,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // ← 패딩 통일
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: r, // ← 라운드 통일
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              Icon(leading, size: 22, color: cs.onSurfaceVariant),
              const SizedBox(width: 12),
            ],
            // 본문
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      maxLines: 2, // ← 2줄 허용
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Switch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}
