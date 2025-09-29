import 'package:flutter/material.dart';

class RouteListCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;

  const RouteListCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cs.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap ??
                () {
              // 기본 동작(개발 편의용): 콜백 없으면 안내만
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('루트 상세로 이동 연결 필요')),
              );
            },
        child: Column(
          children: [
            // 상단 썸네일(플레이스홀더 - 리스트용은 12:5 비율)
            AspectRatio(
              aspectRatio: 12 / 5,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [cs.primaryContainer, cs.secondaryContainer],
                  ),
                  border: Border(
                    bottom: BorderSide(color: cs.outlineVariant),
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
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // 부제
                        Text(
                          subtitle,
                          style: theme.textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // 더보기 아이콘
                  if (onMoreTap != null)
                    IconButton(
                      tooltip: "더보기",
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
