import 'package:flutter/material.dart';

/// 러닝 중 상단에 떠있는 간단 HUD

class RecordHud extends StatelessWidget {
  final String distanceText;
  final String durationText;
  final String paceText;

  const RecordHud({
    super.key,
    required this.distanceText,
    required this.durationText,
    required this.paceText,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: const [
          _HudItem(label: "거리", icon: Icons.route_rounded),
          SizedBox(width: 12),
          _HudItem(label: "시간", icon: Icons.access_time_filled_rounded),
          SizedBox(width: 12),
          _HudItem(label: "페이스", icon: Icons.speed_rounded),
        ],
      ),
    );
  }
}

/// 내부 아이템 = 부모에서 InheritedWidget으로 값 주입

class _HudItem extends StatelessWidget {
  final String label;
  final IconData icon;

  const _HudItem({
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}