import 'package:flutter/material.dart';

/// 통계 화면의 "Top 루트" 항목 카드
class TopRouteCard extends StatelessWidget {
  final int rank; // 순위 (1,2,3…)
  final String title; // 루트 제목
  final String subtitle; // 보조 텍스트(날짜 등)
  final VoidCallback onTap; // 카드 탭
  final VoidCallback? onMoreTap; // 더보기 버튼
  // 메타 배지들: 제공되면 아이콘+배지로 그려줌
  final String? distanceText;
  final String? durationText;
  final String? paceText;
  // 태그 리스트
  final List<String>? tags;

  const TopRouteCard({
    super.key,
    required this.rank,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.onMoreTap,
    this.distanceText,
    this.durationText,
    this.paceText,
    this.tags,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 순위 원형 뱃지
                _RankBadge(rank: rank),

                const SizedBox(width: 12),

                // 본문
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 제목 + 더보기
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (onMoreTap != null)
                            IconButton(
                              tooltip: "더보기",
                              icon: const Icon(Icons.more_horiz_rounded),
                              onPressed: onMoreTap,
                              splashRadius: 20,
                            ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // 서브 타이틀(날짜 등)
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // 메타 배지(거리/시간/페이스) - 하나라도 있으면 렌더되게
                      if (distanceText != null ||
                          durationText != null ||
                          paceText != null) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (distanceText != null)
                              _MetaChip(
                                icon: Icons.route,
                                label: distanceText!,
                              ),
                            if (durationText != null)
                              _MetaChip(
                                icon:Icons.access_time_rounded,
                                label: durationText!,
                              ),
                            if (paceText != null)
                              _MetaChip(
                                icon: Icons.speed_rounded,
                                label: paceText!,
                              ),
                          ],
                        ),
                      ],

                      // 태그 칩 - 있으면 표시
                      if (tags != null && tags!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            for (final t in tags!)
                              _TagChip(label: "#$t"),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // 우측 진입 아이콘(상세 암시)
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
        ),
      ),
    );
  }
}

/// 순위 랭크 배지
class _RankBadge extends StatelessWidget {
  final int rank;
  const _RankBadge({required this.rank});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Text(
        "$rank",
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

/// 메타 정보용 작은 칩(아이콘+텍스트)
class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}

/// 태그 칩
class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }
}