import 'package:flutter/material.dart';
import 'package:routelog_project/features/routes/route_actions_sheet.dart';
import 'package:routelog_project/features/routes/widgets/widgets.dart' show RouteListCard;
import 'package:routelog_project/features/search/widgets/widgets.dart';

import 'package:routelog_project/core/widgets/async_view.dart';
import 'package:routelog_project/core/widgets/empty_view.dart';
import 'package:routelog_project/core/widgets/error_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<String> _recent = ["한강", "퇴근길", "러닝",];
  final List<String> _suggested = const ["강변", "오르막", "주말", "아침", "야간"];

  String _keyword = "";
  int _resultCount = 0; // 검색 결과 개수(목업)

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _notImplemented(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _performSearch(String keyword) {
    final k = keyword.trim();
    if (k.isEmpty) return;

    setState(() {
      _keyword = k;
      _recent.remove(k);
      _recent.insert(0, k);
      if (_recent.length > 8) _recent.removeLast();
      // 목업: 키워드에 따라 0/5개 토글해보자
      _resultCount = (k.toLowerCase() == '없음' || k.toLowerCase() == 'none') ? 0 : 5;
    });

    _notImplemented('검색은 나중에 연결: "$k"');
  }

  @override
  Widget build(BuildContext context) {
    final hasKeyword = _keyword.isNotEmpty;

    // 상태 값 (컨트롤러 연동 시 교체)
    final bool loading = false;
    final Object? error = null;

    return Scaffold(
      appBar: AppBar(
        title: SearchField(
          controller: _controller,
          onSubmitted: _performSearch,
        ),
        actions: [
          IconButton(
            tooltip: "검색",
            icon: const Icon(Icons.search_rounded),
            onPressed: () => _performSearch(_controller.text),
          ),
        ],
      ),
      body: AsyncView(
        loading: loading,
        error: error,
        loadingView: const Center(child: CircularProgressIndicator()),
        errorView: ErrorView(
          message: "검색에 실패했어요.",
          onRetry: () => _performSearch(_controller.text),
        ),
        childBuilder: (_) {
          // 키워드가 있고 결과가 0개 => EmptyView
          if (hasKeyword && _resultCount == 0) {
            return const EmptyView(
              title: "검색 결과가 없어요",
              message: "다른 키워드나 태그를 사용해 보세요.",
              icon: Icons.search_off_rounded,
            );
          }

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
                        Text(
                          "최근 검색이 없어요.",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      for (final q in _recent)
                        SearchHistoryChip(
                          text: q,
                          onTap: () {
                            _controller.text = q;
                            _controller.selection = TextSelection.fromPosition(
                              TextPosition(offset: q.length),
                            );
                            _performSearch(q);
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
                            _controller.selection = TextSelection.fromPosition(
                              TextPosition(offset: k.length),
                            );
                            _performSearch(k);
                          },
                        ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // 결과 섹션 타이틀
              if (!hasKeyword)
                const SliverToBoxAdapter(child: SectionTitlePadding("결과")),
              if (!hasKeyword)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "검색어를 입력해 주세요",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),

              if (hasKeyword) const SliverToBoxAdapter(child: SectionTitlePadding("결과")),

              // 결과 리스트 (목업 N개)
              if (hasKeyword && _resultCount > 0)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  sliver: SliverList.separated(
                    itemCount: _resultCount,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final title = "$_keyword 루트 ${index + 1}";
                      final subtitle = "- km  -  - m  -  2025.09.0${(index % 7) + 1}";
                      return RouteListCard(
                        title: title,
                        subtitle: subtitle,
                        onTap: () => _notImplemented("상세 연결은 나중에"),
                        onMoreTap: () => showRouteActionsSheet(context),
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
}
