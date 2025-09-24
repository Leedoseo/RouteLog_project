import 'package:flutter/material.dart';

/// 내용 표시용 카드(탭 불가능)

class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.all(12),
    required this.child,
  });

  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: margin,
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
          padding: padding,
          child: child
      ),
    );
  }
}