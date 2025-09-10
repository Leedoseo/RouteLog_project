import 'package:flutter/material.dart';
import 'package:routelog_project/features/routes/route_actions_sheet.dart';
import 'package:routelog_project/features/routes/widgets/widgets.dart';
import 'package:routelog_project/core/widgets/widgets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  // 최근 검색 (간단 메모리 보관, 실제 앱에선 로컬 저장소 사용 예정
  final List<String> _recent = ["한강", "퇴근길", "러닝",];
  // 추천 태그(목업)
  final List<String> _suggested = const ["강변", "오르막", "주말", "아침", "야간"];

  // 검색 결과(목업), 현재는 키워드 기반으로 목업 카드 5개 생성
  String _keyword = "";

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
      // 최근 검색 갱신(중복 제거 후 맨 앞에)
      _recent.remove(k);
      _recent.insert(0, k);
      if (_recent.length > 8) _recent.removeLast();
    });

    // 실제 검색은 나중에
    _notImplemented('검색은 나중에 연결: "$k"');
  }

  @override
  Widget build(BuildContext context) {
    final hasKeyword = _keyword.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        // AppBar 안에 직접 검색바 배치(타이틀 대신 TextField)
        title: _SearchField(
          controller: _controller,
          onSubmitted: _performSearch, // 키보드 검색
        ),
        actions: [
          IconButton(
            tooltip: "검색",
            icon: const Icon(Icons.search_rounded),
            onPressed: () => _performSearch(_controller.text),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 최근 검색 섹션
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
                      onPressed: () {
                        setState(() => _recent.clear());
                      },
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
                    ActionChip(
                      label: Text(q),
                      onPressed: () {
                        _controller.text = q;
                        _controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: q.length),
                        );
                        _performSearch(q);
                      },
                    ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // 추천 태그 섹션
          const SliverToBoxAdapter(child: _SectionTitlePadding("추천 태그")),
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

          // 결과 섹션(목업)
          if (!hasKeyword)
            const SliverToBoxAdapter(
              child: _SectionTitlePadding("결과"),
            ),
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

          if (hasKeyword) const SliverToBoxAdapter(child: _SectionTitlePadding("결과")),

          if (hasKeyword)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverList.separated(
                itemCount: 5, // 목업 5개
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  // RouteListCard 재사용 (실제 데이터 연결은 나중에)
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
      ),
    );
  }
}

// AppBar에 들어가는 검색 입력 필드
class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  const _SearchField({
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      autofocus: true,
      textInputAction: TextInputAction.search,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: "루트 이름, 태그, 위치로 검색",
        isDense: true,
        filled: true,
        fillColor: cs.surfaceContainerHighest,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: IconButton(
          tooltip: "지우기",
          icon: const Icon(Icons.close_rounded),
          onPressed: () => controller.clear(),
        ),
      ),
    );
  }
}

class _SectionTitlePadding extends StatelessWidget {
  final String text;
  const _SectionTitlePadding(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}