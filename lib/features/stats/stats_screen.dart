import 'package:flutter/material.dart';
import 'package:routelog_project/core/decoration/app_background.dart';
import 'package:routelog_project/features/stats/widgets/widgets.dart';
import 'package:routelog_project/core/navigation/app_router.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});
  static const routeName = "/stats";

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  // ── 목업 상태
  bool _isWeekly = true; // 주간/월간 토글
  int _weekIndex = 0;    // 0 = 이번 주, -1 저번 주 …
  int _monthIndex = 0;   // 0 = 이번 달, -1 저번 달 …

  // 더미 데이터(주/월 각각 다른 배열 사용)
  List<double> get _series {
    if (_isWeekly) {
      // 7일
      return const [3.2, 5.0, 0.0, 7.8, 4.6, 0.0, 10.2];
    } else {
      // 30일 간략 샘플
      return const [2,4,3,6,5,7,2,0,8,6,5,3,4,7,8,5,2,4,6,7,9,4,3,6,7,5,4,3,6,7]
          .map((e) => e.toDouble()).toList();
    }
  }

  String get _periodLabel {
    if (_isWeekly) {
      if (_weekIndex == 0) return "이번 주";
      if (_weekIndex == -1) return "지난 주";
      return "${-_weekIndex}주 전";
    } else {
      if (_monthIndex == 0) return "이번 달";
      if (_monthIndex == -1) return "지난 달";
      return "${-_monthIndex}개월 전";
    }
  }

  // 요약 수치 목업
  String get _totalDistance => _isWeekly ? "26.8 km" : "112.4 km";
  String get _totalTime => _isWeekly ? "2:43:12" : "11:28:05";
  String get _avgPace => _isWeekly ? "5'25\"/km" : "5'32\"/km";

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("통계")),
      body: AppBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            // ── 탭 토글 (주간/월간) + 기간 이동
            Row(
              children: [
                SegmentChip(
                  label: "주간",
                  selected: _isWeekly,
                  onTap: () => setState(() => _isWeekly = true),
                ),
                const SizedBox(width: 8),
                SegmentChip(
                  label: "월간",
                  selected: !_isWeekly,
                  onTap: () => setState(() => _isWeekly = false),
                ),
                const Spacer(),
                IconButton(
                  tooltip: "이전",
                  onPressed: () => setState(() {
                    if (_isWeekly) _weekIndex -= 1; else _monthIndex -= 1;
                  }),
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
                Text(_periodLabel, style: t.labelLarge),
                IconButton(
                  tooltip: "다음",
                  onPressed: () => setState(() {
                    if (_isWeekly) {
                      if (_weekIndex < 0) _weekIndex += 1;
                    } else {
                      if (_monthIndex < 0) _monthIndex += 1;
                    }
                  }),
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── 요약 카드(화면 폭에 따라 자동 레이아웃: 좁으면 2열, 넓으면 3열)
            LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;

                if (w < 380) {
                  // 좁은 화면: 2열(2개 + 1개)
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: SummaryCard(icon: Icons.route_rounded, label: "총 거리", value: _totalDistance)),
                          const SizedBox(width: 12),
                          Expanded(child: SummaryCard(icon: Icons.timer_outlined, label: "총 시간", value: _totalTime)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SummaryCard(icon: Icons.speed_rounded, label: "평균 페이스", value: _avgPace),
                    ],
                  );
                } else {
                  // 넓은 화면: 3열 고정
                  return Row(
                    children: [
                      Expanded(child: SummaryCard(icon: Icons.route_rounded, label: "총 거리", value: _totalDistance)),
                      const SizedBox(width: 12),
                      Expanded(child: SummaryCard(icon: Icons.timer_outlined, label: "총 시간", value: _totalTime)),
                      const SizedBox(width: 12),
                      Expanded(child: SummaryCard(icon: Icons.speed_rounded, label: "평균 페이스", value: _avgPace)),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 16),

            // ── 추세 차트 카드 (라인)
            TrendCard(
              title: "러닝 추세",
              subtitle: _isWeekly ? "일별 거리(km)" : "일별 거리(km)",
              periodLabel: _periodLabel,
              values: _series,
              xDivisions: _isWeekly ? 7 : 6,
            ),
            const SizedBox(height: 16),

            // ── 세션 요약 (각 항목 탭 → 상세 이동: Named route)
            Text("세션 요약", style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),

            InkWell(
              onTap: () => Navigator.pushNamed(context, Routes.routeDetail('mock_2025-09-21')),
              borderRadius: BorderRadius.circular(12),
              child: const SplitTile(title: "2025-09-21 (일)", meta: "7.8 km · 42:10 · 5'24\"/km"),
            ),
            const SizedBox(height: 8),

            InkWell(
              onTap: () => Navigator.pushNamed(context, Routes.routeDetail('mock_2025-09-19')),
              borderRadius: BorderRadius.circular(12),
              child: const SplitTile(title: "2025-09-19 (금)", meta: "10.2 km · 56:31 · 5'32\"/km"),
            ),
            const SizedBox(height: 8),

            InkWell(
              onTap: () => Navigator.pushNamed(context, Routes.routeDetail('mock_2025-09-17')),
              borderRadius: BorderRadius.circular(12),
              child: const SplitTile(title: "2025-09-17 (수)", meta: "5.0 km · 25:38 · 5'08\"/km"),
            ),
          ],
        ),
      ),
    );
  }
}
