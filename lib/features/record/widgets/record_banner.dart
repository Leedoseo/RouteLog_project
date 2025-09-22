import 'package:flutter/material.dart';

enum BannerVariant { recording, paused, idle }

class RecordBanner extends StatelessWidget {
  final String text;
  final BannerVariant variant;
  final VoidCallback? onTap;

  const RecordBanner({
    super.key,
    required this.text,
    this.variant = BannerVariant.idle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Color bg;
    Color fg;
    switch (variant) {
      case BannerVariant.recording:
        bg = cs.errorContainer;
        fg = cs.onErrorContainer;
        break;
      case BannerVariant.paused:
        bg = cs.secondaryContainer;
        fg = cs.onSecondaryContainer;
        break;
      case BannerVariant.idle:
      default:
        bg = cs.primaryContainer;
        fg = cs.onPrimaryContainer;
    }

    final banner = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bg.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, size: 18, color: fg),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: fg,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: fg),
          ],
        ],
      ),
    );

    // 잉크 리플을 살리고 싶다면 InkWell 주변에 Material을 두는 게 가장 깔끔
    return onTap == null
        ? banner
        : Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: banner,
      ),
    );
  }
}
