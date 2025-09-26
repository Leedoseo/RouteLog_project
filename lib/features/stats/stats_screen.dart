import 'package:flutter/material.dart';
import 'package:routelog_project/core/decoration/app_background.dart';
import 'package:routelog_project/features/stats/widgets/widgets.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  Period _period = Period.week;

  // 목업 데이터 (기간별로 값만 다르게 보여줌)
  Map<String, String> get _kpi {
    switch (_period) {
      case Period.week:
        return {
          'distance': '42.3 km',
          'time': '3:25:12',
          'pace': "5'18\"/km",
          'sessions': '5',
        };
      case Period.month:
        return {
          'distance': '168.4 km',
          'time': '13:42:10',
          'pace': "5'22\"/km",
          'sessions': '21',
        };
      case Period.all:
        return {
          'distance': '1,240 km',
          'time': '102:13:54',
          'pace': "5'30\"/km",
          'sessions': '152',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('통계')),
      body: AppBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          children: [
            PeriodTabs(
              value: _period,
              onChanged: (p) => setState(() => _period = p),
            ),
            const SizedBox(height: 12),

            // KPI 4장
            Row(
              children: [
                Expanded(child: StatKpiCard(label: '총 거리', value: _kpi['distance']!)),
                const SizedBox(width: 12),
                Expanded(child: StatKpiCard(label: '총 시간', value: _kpi['time']!)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: StatKpiCard(label: '평균 페이스', value: _kpi['pace']!)),
                const SizedBox(width: 12),
                Expanded(child: StatKpiCard(label: '세션 수', value: _kpi['sessions']!)),
              ],
            ),
            const SizedBox(height: 16),

            // 스파크라인(목업)
            SparklineCard(
              title: _period == Period.week ? '거리 추이(최근 7일)' : '거리 추이(최근 14일)',
              points: _period == Period.week
                  ? const [2, 6, 4, 8, 5, 7, 9]
                  : const [1, 3, 2, 6, 4, 7, 5, 9, 6, 8, 4, 7, 5, 8],
            ),
            const SizedBox(height: 16),

            // (선택) 분포 카드 – 요일/시간대 목업
            const DistributionCard(),

            const SizedBox(height: 24),
            Text('최근 기록', style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),

            // 최근 세션 3개
            const RecentSessionTile(date: '2025-09-10', distance: '5.2 km', time: '28분', pace: "5'25\"/km"),
            const SizedBox(height: 8),
            const RecentSessionTile(date: '2025-09-08', distance: '10.0 km', time: '54분', pace: "5'22\"/km"),
            const SizedBox(height: 8),
            const RecentSessionTile(date: '2025-09-05', distance: '7.5 km', time: '41분', pace: "5'30\"/km"),
          ],
        ),
      ),
    );
  }
}
