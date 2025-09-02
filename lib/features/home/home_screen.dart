import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // 앱 타이틀 및 검색 기능(현재는 미구현 상태 추후 구현)
        title: const Text("RouteLog"),
        actions: [
          IconButton(
            onPressed: () {
              _notImplemented(context, "검색은 미구현");
            },
            icon: const Icon(Icons.search),
            tooltip: "검색 (미구현)",
          ),
        ],
      ),

      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  // 섹션 타이틀 : 오늘 요약 [거리, 시간 간단 타일]
                  _SectionTitle("오늘 요약"),
                  SizedBox(height: 8),

                  // SummaryTile 2개 : 거리/시간 값 표시. 현재는 "--"로 고정
                  Row(
                    children: [
                      Expanded(child: _SummaryTile(title: '거리', value: '-- km')), // 오늘 이동 거리
                      SizedBox(width: 8),
                      Expanded(child: _SummaryTile(title: '시간', value: '-- m')), // 오늘 이동 시간
                    ],
                  ),

                  SizedBox(height: 20),
                  _SectionTitle("빠른 동작"),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _QuickActionButton(
                      label: "기록 시작", // 추후 record 화면으로 네비게이션 예정
                      icon: Icons.play_arrow_rounded,
                      onTap: () => _notImplemented(context, "Record 연결 예정"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _QuickActionButton(
                      label: "내 루트",
                      icon: Icons.route_rounded,
                      onTap: () => _notImplemented(context, "Routes List 연결 예정"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _QuickActionButton(
                      label: "통계",
                      icon: Icons.insights_rounded,
                      onTap: () => _notImplemented(context, "Stats 연결 예정"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // 최근 루트 섹션 타이틀
          const SliverToBoxAdapter(child: _SectionTitlePadding("최근 루트")),

          // 최근 루트 리스트 : RouteCard 3개 고정 목업. 실제 데이터 연결은 나중에.
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverList.separated(
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _RouteCard(
                  title: "루트 ${index + 1}", // 루트 이름/태그 요약 표시 예정
                  subtitle: "2025.09.03  -  --km  -  --m", // 날짜/거리/시간 메타 표시 예정
                  onTap: () => _notImplemented(context, "Route Detail 연결 예정"),
                );
              },
            ),
          ),
        ],
      ),

      // FAB: 기록 시작 플로우 진입. 현재는 스낵바만 띄움.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _notImplemented(context, "기록 시작 연결 예정"),
        icon: const Icon(Icons.play_circle_fill_rounded),
        label: const Text("기록 시작"),
      ),
    );
  }
}

void _notImplemented(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg)),
  );
}
// 화면 내 제목
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// 여백 포함 섹션 타이틀: 리스트 섹션 시작 전 아래 여백 포함 버전
class _SectionTitlePadding extends StatelessWidget {
  final String text;
  const _SectionTitlePadding(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Text(
        text,
        style: Theme
            .of(context)
            .textTheme
            .titleMedium
            ?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// 핵심 수치(거리/시간 등)를 큰 글씨로 보여주는 카드형 타일. Home 상단 "오늘 요약"에 사용
class _SummaryTile extends StatelessWidget {
  final String title;
  final String value;
  const _SummaryTile({
    required this.title,
    required this.value
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// 기록 시작 / 내 루트 / 통계 3열 버튼
class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: cs.primaryContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}

// 최근 루트 1건을 보여주는 컴포넌트
class _RouteCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _RouteCard({required this.title,
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