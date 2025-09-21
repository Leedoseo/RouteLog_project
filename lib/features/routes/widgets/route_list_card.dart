import 'package:flutter/material.dart';

class RouteListCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final VoidCallback onMoreTap;

  const RouteListCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            // 상단 썸네일(플레이스 홀더 - 리스트용은 12:5 비율
            AspectRatio(
              aspectRatio: 12 / 5,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: cs.outlineVariant)),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [cs.primaryContainer, cs.secondaryContainer],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.map_rounded, size: 40),
                ),
              ),
            ),

            // 제목/부제 + 더보기
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 8, 12),
              child: Row(
                children: [
                  // 텍스트 영역
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 제목
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700
                          ),
                          maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // 부제
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // 더보기 아이콘 (액션 메뉴 예정)
                  IconButton(
                    tooltip: "더보기 (미구현)",
                    icon: const Icon(Icons.more_vert_rounded),
                    onPressed: onMoreTap,
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