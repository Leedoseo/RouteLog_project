import 'package:flutter/material.dart';

/// 공용 설정 타일 (아이콘 + 타이틀 + 서브타이틀 + 트레일링)
/// - 패딩 통일: H16 / V8
/// - 라운드 통일: R12
class SettingsTile extends StatelessWidget {
  final IconData? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.title,
    this.leading,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final r = BorderRadius.circular(12);

    return InkWell(
      onTap: onTap,
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
                  // 굵기만 살짝 강화
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
            if (trailing != null) ...[
              const SizedBox(width: 12),
              trailing!,
            ],
            if (onTap != null) ...[
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
            ],
          ],
        ),
      ),
    );
  }
}
