import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
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
    final t  = Theme.of(context).textTheme;

    // ✅ 접근성 큰글자에서도 레이아웃 붕괴 방지 (필요시 1.2~1.4로 조정)
    final mq = MediaQuery.of(context);
    final clampedScaler = mq.textScaler.clamp(maxScaleFactor: 1.2);

    return MediaQuery(
      data: mq.copyWith(textScaler: clampedScaler),
      child: Container(
        // height: 94, // ❌ 고정 높이 제거
        constraints: const BoxConstraints(minHeight: 94), // ✅ 최소 높이만 보장
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(icon, size: 26, color: cs.primary),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── 라벨: 길면 …, 1~2줄 허용
                  Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    // textScaler: const TextScaler.linear(1.0), // ❌ 고정 스케일 제거
                    style: t.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // ── 값: 길어도 잘리지 않게 자동 축소
                  FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      value,                  // 예: 8.86 km / 31:56 / 3'36"/km
                      maxLines: 1,
                      softWrap: false,
                      textWidthBasis: TextWidthBasis.longestLine,
                      // textScaler: const TextScaler.linear(1.0), // ❌ 고정 스케일 제거
                      style: t.titleLarge?.copyWith( // 유지: 너가 쓰던 titleLarge
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
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
