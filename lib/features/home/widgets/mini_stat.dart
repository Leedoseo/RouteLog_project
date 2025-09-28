import 'dart:ui' show FontFeature;
import 'package:flutter/material.dart';
import 'package:routelog_project/core/widgets/soft_info_card.dart';

/// 홈 상단 요약 카드(아이콘 + 라벨 + 값)
/// - 상자 높이: 고정 80
/// - 라벨/값: FittedBox(scaleDown)로 폭 넘치면 자동 축소 (… 방지)
/// - 숫자 가독성: tabular figures 적용
class MiniStat extends StatelessWidget {
  const MiniStat({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return SizedBox(
      height: 80, // ← 박스 크기 고정
      child: SoftInfoCard(
        child: Row(
          children: [
            Icon(icon, size: 24, color: cs.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 라벨: 길면 자동 축소 + 한 줄 고정
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      label,
                      maxLines: 1,
                      softWrap: false,
                      // 접근성 글자 확대가 레이아웃을 깨뜨리지 않도록 라벨만 고정
                      textScaler: const TextScaler.linear(1.0),
                      style: t.labelLarge?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // 값: 길면 자동 축소 + 한 줄 고정 + 숫자 자리폭 균일
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      maxLines: 1,
                      softWrap: false,
                      // 시스템 폰트 스케일과 무관하게 박스 안에서만 축소/확대
                      textScaler: const TextScaler.linear(1.0),
                      style: t.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
