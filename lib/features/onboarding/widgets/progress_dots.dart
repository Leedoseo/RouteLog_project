import 'package:flutter/material.dart';

class ProgressDots extends StatelessWidget {
  final int currentIndex;
  final int length;

  const ProgressDots({
    super.key,
    required this.currentIndex,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (i) {
        final active = i == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: active ? 20 : 8,
          decoration: BoxDecoration(
            color: active ? cs.primary : cs.onSurfaceVariant,
            borderRadius: BorderRadius.circular(100),
          ),
        );
      }),
    );
  }
}