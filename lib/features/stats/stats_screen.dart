import 'package:flutter/material.dart';
import 'package:routelog_project/features/stats/widgets/widgets.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  /// 현재 선택된 월 (1일로 고정 권장)
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month, 1);

  @override
  Widget build(BuildContext context) {
    // 목업용 합계 KPI 값 (실제 구현 시 _month 기준으로 교체)
    const totalDistance = "42.3km";
    const totalDuration = "3h 58m";
    const totalRuns = "12 회";

    // 목업용 주간 데이터 (실제 구현 시 _month 기준으로 교체)
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
          // 월 선택 바 (공용 위젯)
          SliverToBoxAdapter(
            child: MonthPickerBar(
              month: _month,
              onChanged: (m) => setState(() => _month = m),
              minMonth: DateTime(2023, 1, 1), // (옵션) 서비스 시작 월
              maxMonth: DateTime.now(),       // (옵션) 미래 제한
              // showThisMonthButton: false,
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
                  WeeklyDistanceChart(
                    title: "주간 거리",
                    subtitle: "지난 주 대비 +12%",
                    values: [0.3, 0.6, 0.2, 0.8, 0.5, 0.7, 0.4],
                    labels: ['월','화','수','목','금','토','일'],
                  ),
                  const SizedBox(height: 12),
                  WeeklyDistanceChart(
                    title: "주간 시간",
                    subtitle: "지난 주 대비 +8%",
                    values: [0.2, 0.4, 0.3, 0.7, 0.6, 0.8, 0.5],
                    labels: ['월','화','수','목','금','토','일'],
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
                  subtitle: "2025.09.0$rank",
                  distanceText: "5.$rank km",
                  durationText: "2$rank:1$rank",
                  paceText: "5:0$rank/km",
                  tags: const ["러닝", "야간"],
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
