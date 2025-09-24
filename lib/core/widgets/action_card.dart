import 'package:flutter/material.dart';

/// 탭 가능한 카드

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.all(12),
    required this.onTap,
    required this.child,
  });

  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = BorderRadius.circular(16);

    return Card(
      margin: margin,
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: r),
      child: InkWell(
        onTap: onTap,
        borderRadius: r,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}