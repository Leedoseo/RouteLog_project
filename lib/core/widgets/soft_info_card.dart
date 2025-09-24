import 'package:flutter/material.dart';

/// 정보 카드: 라이트/다크 모두 은은한 그림자 + 테두리

class SoftInfoCard extends StatelessWidget {
  const SoftInfoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final r = BorderRadius.circular(16);
    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: r,
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.06),
            blurRadius: 20, spreadRadius: 2, offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      borderRadius: r,
      child: InkWell(
        borderRadius: r,
        onTap: onTap,
        child: card,
      ),
    );
  }
}