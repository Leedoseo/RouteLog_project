import 'package:flutter/material.dart';

class ControlBar extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onStop;
  const ControlBar({
    required this.onStart,
    required this.onPause,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: onStart,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text("시작"),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: FilledButton(
            onPressed: onPause,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text("일시정지"),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: FilledButton(
            onPressed: onStop,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text("종료"),
            ),
          ),
        ),
      ],
    );
  }
}