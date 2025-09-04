import 'package:flutter/material.dart';
import 'package:routelog_project/features/stats/widgets/widgets.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 목업용 더미값
    const monthLabel = "2025년 9월";
    const totalDistance = "42.3km";
    const totalDuration = "3h 58m";
    const totalRuns = "12 회";

    final weeklyDistance = [0.3, 0.6, 0.2, 0.8, 0.5, 0.7, 0.4];
    final weeklyTime = [0.2, 0.4, 0.3, 0.7, 0.6, 0.8, 0.5];

    return Scaffold(
      appBar: AppBar(
        title: const Text("통계"),
        actions: [
          IconButton(
            tooltip: "공유 (미구현)",
            icon: const Icon(Icons.ios_share_rounded),
            onPressed: () => _notImplemented(context, "공유는 나중에 연결"),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 월 선택바
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    tooltip: "이전 달 (미구현)",
                    icon: const Icon(Icons.chevron_left_rounded),
                    onPressed: () => _notImplemented(context, "이전 달 전환 예정"),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        monthLabel,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: "다음 달 (미구현)",
                    icon: const Icon(Icons.chevron_right_rounded),
                    onPressed: () => _notImplemented(context, "다음 달 전환 예정"),
                  ),
                ],
              ),
            ),
          ),

          // KPI 카드 3개 (거리/시간/횟수)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: const [
                  Expanded(child: KpiCard(label: "합계 거리", value: totalDistance, icon: Icons.route_rounded)),
                  SizedBox(width: 8),
                  Expanded(child: KpiCard(label: "합계 시간", value: totalDuration, icon: Icons.access_time_rounded)),
                  SizedBox(width: 8),
                  Expanded(child: KpiCard(label: "러닝 횟수", value: totalRuns, icon: Icons.directions_run_rounded)),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // 요약 차트 섹션
          const SliverToBoxAdapter(child: SectionTitlePadding("요약 차트")),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  MiniChartPlaceholder(
                    title: "주간 거리",
                    subtitle: "지난 주 대비 +12%",
                    data: weeklyDistance,
                  ),
                  const SizedBox(height: 12),
                  MiniChartPlaceholder(
                    title: "주간 시간",
                    subtitle: "지난 주 대비 +8%",
                    data: weeklyTime,
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // Top 루트 섹션
          const SliverToBoxAdapter(child: SectionTitlePadding("Top 루트")),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverList.separated(
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final rank = index + 1;
                return TopRouteCard(
                  rank: rank,
                  title: "루트 $rank",
                  subtitle: "5.${rank} km - 2${rank}:1${rank} - 2025.09.0$rank",
                  onTap: () => _notImplemented(context, "상세 연결은 나중에"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _notImplemented(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
