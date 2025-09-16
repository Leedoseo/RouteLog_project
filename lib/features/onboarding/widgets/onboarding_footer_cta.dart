import 'package:flutter/material.dart';

class OnboardingFooterCta extends StatelessWidget {
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback onStart;

  const OnboardingFooterCta({
    super.key,
    required this.isLast,
    required this.onNext,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    if (isLast) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: onStart,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text("시작하기"),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onNext,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text("다음"),
        ),
      ),
    );
  }
}