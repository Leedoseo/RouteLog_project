import 'package:flutter/material.dart';

class QuickActionButton extends StatelessWidget {
  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final r = BorderRadius.circular(14);

    return Material(
      color: cs.surface,
      shape: RoundedRectangleBorder(side: BorderSide(color: cs.outlineVariant), borderRadius: r),
      child: InkWell(
        borderRadius: r,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: cs.primary),
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 44),
                child: Center(
                    child: Text(
                      label,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      textScaler: const TextScaler.linear(1.0), // 라벨만 스케일 고정 (선택)
                      style: t.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
