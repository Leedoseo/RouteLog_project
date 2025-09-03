import 'package:flutter/material.dart';

// 최근 루트 1건을 보여주는 컴포넌트
class RouteCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const RouteCard({required this.title,
    required this.subtitle,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap, // 상세 화면으로 전환 예정(현재는 미구현)
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 지도 썸네일 자리 (현재는 플레이스 홀더)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: cs.outlineVariant),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      cs.primaryContainer,
                      cs.secondaryContainer,
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.map_rounded, size: 48),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Row(
                children: [
                  // 제목/부제(날짜/시간/거리)영역
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right_rounded), // 상세 진입 암시 아이콘
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}