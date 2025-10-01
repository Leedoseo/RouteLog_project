import 'package:flutter/material.dart';
import 'package:routelog_project/features/routes/route_actions_sheet.dart';
import 'package:routelog_project/features/routes/widgets/widgets.dart' show RouteListCard;
import 'package:routelog_project/features/search/widgets/widgets.dart';
import 'package:routelog_project/core/navigation/app_router.dart';
import 'package:routelog_project/core/utils/notifier_provider.dart';
import 'package:routelog_project/features/search/state/route_search_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<String> _recent = ["한강", "퇴근길", "러닝"];
  final List<String> _suggested = const ["강변", "오르막", "주말", "아침", "야간"];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitToController(String keyword, RouteSearchController ctrl) {
    final k = keyword.trim();
    if (k.isEmpty) return;

    setState(() {
      _recent.remove(k);
      _recent.insert(0, k);
      if (_recent.length > 8) _recent.removeLast();
    });

    ctrl.setQuery(k);
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = NotifierProvider.of<RouteSearchController>(context);
    final hasKeyword = ctrl.query.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: SearchField(
          controller: _controller,
          onSubmitted: (v) => _submitToController(v, ctrl),
        ),
        actions: [
          IconButton(
            tooltip: "검색",
            icon: const Icon(Icons.search_rounded),
            onPressed: () => _submitToController(_controller.text, ctrl),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: ctrl,
        builder: (context, _) {
          return CustomScrollView(
            slivers: [
              // 최근 검색
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Row(
                    children: [
                      Text(
                        "최근 검색",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      if (_recent.isNotEmpty)
                        TextButton(
                          onPressed: () => setState(() => _recent.clear()),
                          child: const Text("지우기"),
                        ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (_recent.isEmpty)
                        Text("최근 검색이 없어요.", style: Theme.of(context).textTheme.bodySmall),
                      for (final q in _recent)
                        SearchHistoryChip(
                          text: q,
                          onTap: () {
                            _controller.text = q;
                            _controller.selection =
                                TextSelection.fromPosition(TextPosition(offset: q.length));
                            _submitToController(q, ctrl);
                          },
                          onDelete: () => setState(() => _recent.remove(q)),
                        ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // 추천 태그
              const SliverToBoxAdapter(child: SectionTitlePadding('추천 태그')),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final tag in _suggested)
                        FilterChip(
                          label: Text("#$tag"),
                          selected: false,
                          onSelected: (_) {
                            final k = "#$tag";
                            _controller.text = k;
                            _controller.selection =
                                TextSelection.fromPosition(TextPosition(offset: k.length));
                            _submitToController(k, ctrl);
                          },
                        ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // 결과
              const SliverToBoxAdapter(child: SectionTitlePadding("결과")),

              if (!hasKeyword && ctrl.items.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text("검색어를 입력해 주세요",
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                ),

              if (hasKeyword && ctrl.loading)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),

              if (hasKeyword && !ctrl.loading && ctrl.items.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: Text('결과가 없어요')),
                  ),
                ),

              if (hasKeyword && !ctrl.loading && ctrl.items.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  sliver: SliverList.separated(
                    itemCount: ctrl.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = ctrl.items[index];
                      final km = item.distanceMeters / 1000.0;
                      final distanceText =
                      km >= 10 ? '${km.toStringAsFixed(0)} km' : '${km.toStringAsFixed(2)} km';
                      final pace = item.avgPaceSecPerKm;
                      final paceText = pace == null
                          ? '-'
                          : "${(pace ~/ 60)}'${(pace % 60).round().toString().padLeft(2, '0')}\"/km";
                      final subtitle =
                          '$distanceText  ·  ${_fmtDur(item.movingTime)}  ·  $paceText';

                      return RouteListCard(
                        title: item.title,
                        subtitle: subtitle,
                        onTap: () => Navigator.pushNamed(context, Routes.routeDetail(item.id)),
                        onMoreTap: () => showRouteActionsSheet(
                          context,
                          route: item,                 // 필수 파라미터 전달
                          routeTitle: item.title,      // (옵션) 헤더 표기용
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  String _fmtDur(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    if (h > 0) return '${h}h ${m}m';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }
}
