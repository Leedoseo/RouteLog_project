import 'package:flutter/material.dart';

/// 앱 전역/화면 상단에 까는 부드러운 그래디언트
/// Scaffold의 coloerScheme.surface 위에 덮는 용도

class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    this.child,
    this.intensity = 0.08
  });

  final Widget? child;
  final double intensity; // 0 ~ 1

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [
            cs.primary.withOpacity(intensity),
            Colors.transparent,
          ],
        ),
      ),
      child: child,
    );
  }
}