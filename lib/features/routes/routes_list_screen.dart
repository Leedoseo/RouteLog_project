import 'package:flutter/material.dart';
import 'package:routelog_project/features/routes/route_actions_sheet.dart';
import 'package:routelog_project/features/routes/route_detail_screen.dart';
import 'package:routelog_project/features/search/search_screen.dart';
import 'package:routelog_project/features/routes/widgets/widgets.dart';
import 'package:routelog_project/features/routes/route_sort_sheet.dart';
import 'package:routelog_project/features/routes/route_filter_sheet.dart';
import 'package:routelog_project/features/routes/route_tag_sheet.dart';
import 'package:routelog_project/features/routes/route_add_sheet.dart';
import 'package:routelog_project/core/widgets/widgets.dart';

/// - 내 루트 목록 화면(목업)

class RoutesListScreen extends StatefulWidget {
  const RoutesListScreen({super.key});

  @override
  State<RoutesListScreen> createState() => _RoutesListScreenState();
}

enum _ListState { loading, loaded, empty, error }

class _RoutesListScreenState extends State<RoutesListScreen> {
  _ListState _state = _ListState.loading;
  List<String> _items = const [];
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _mockLoad(); // 최초 진입 시 로딩 -> 데이터 도착(목업)
  }

  // --- 목업 로딩 시뮬레이션 ---
  Future<void> _mockLoad() async {
    setState(() {
      _state = _ListState.loading;
      _errorMsg = null;
    });
    await Future.delayed(const Duration(milliseconds: 600));
    // 여기서 원하는 시나리오로 바꿔보고 싶으면 아래 중 하나 주석 해제
    // setState(() { _state = _ListState.empty; _items = []; });
    // setState(() { _state = _ListState.error; _errorMsg = "네트워크 오류"; });
    setState(() {
      _items = List.generate(10, (i) => "루트 ${i + 1}");
      _state = _items.isEmpty ? _ListState.empty : _ListState.loaded;
    });
  }

  // --- 디버그용 상태 전환(테스트용) ---
  void _toLoading() => setState(() => _state = _ListState.loading);
  void _toEmpty()   => setState(() { _state = _ListState.empty; _items = []; });
  void _toError()   => setState(() { _state = _ListState.error; _errorMsg = "불러오기에 실패했어요"; });
  void _toData()    => setState(() {
    _items = List.generate(10, (i) => "루트 ${i + 1}");
    _state = _ListState.loaded;
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("내 루트"),
        actions: [
          IconButton(
            tooltip: "검색",
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            tooltip: "추가",
            icon: const Icon(Icons.add_rounded),
            onPressed: () => showRouteAddSheet(context),
          ),
          // 디버그: 상태 전환용 메뉴 (나중에 제거해도 됨)
          PopupMenuButton<String>(
            tooltip: "상태(디버그)",
            itemBuilder: (ctx) => const [
              PopupMenuItem(value: 'loading', child: Text('로딩 상태')),
              PopupMenuItem(value: 'empty',   child: Text('빈 상태')),
              PopupMenuItem(value: 'error',   child: Text('에러 상태')),
              PopupMenuItem(value: 'data',    child: Text('데이터 상태')),
            ],
            onSelected: (v) {
              switch (v) {
                case 'loading': _toLoading(); break;
                case 'empty':   _toEmpty();   break;
                case 'error':   _toError();   break;
                case 'data':    _toData();    break;
              }
            },
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 상단 필터/정렬 바
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: RoutesFilterBar(
                onSortTap: () => showRouteSortSheet(context, initialSort: "latest"),
                onFilterTap: () => showRouteFilterSheet(context),
                onTagTap: () => showRouteTagSheet(context),
              ),
            ),
          ),

          // 적용된 필터 요약 바(목업 값)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppliedFiltersBar(
                tags: const ["러닝", "퇴근길"],
                distanceLabel: "0–5km",
                durationLabel: "<30m",
                sortLabel: "최신 순",
                onClearTag: (t) => _snack("태그 제거: $t"),
                onClearDistance: () => _snack("거리 해제"),
                onClearDuration: () => _snack("시간 해제"),
                onClearSort: () => _snack("정렬 해제"),
                onClearAll: () => _snack("모두 지우기"),
              ),
            ),
          ),

          // 리스트 섹션 타이틀
          const SliverToBoxAdapter(
            child: SectionTitlePadding("전체 루트"),
          ),

          // ▼▼▼ 상태별 본문 ▼▼▼
          switch (_state) {
            _ListState.loading => SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: const SkeletonList(itemCount: 6, itemHeight: 92),
              ),
            ),

            _ListState.empty => SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                child: EmptyState(
                  icon: Icons.route_rounded,
                  title: "루트가 없어요",
                  message: "기록을 저장하면 목록에 나타나요.",
                  actionLabel: "루트 추가",
                  onAction: () => showRouteAddSheet(context),
                ),
              ),
            ),

            _ListState.error => SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                // ErrorState 위젯의 파라미터 이름이 다르면 맞게 교체
                child: ErrorState(
                  icon: Icons.wifi_off_rounded,
                  title: "불러오기에 실패했어요",
                  message: _errorMsg ?? "네트워크 상태를 확인하고 다시 시도해 주세요.",
                  actionLabel: "다시 시도",
                  onAction: _mockLoad,
                ),
              ),
            ),

            _ListState.loaded => SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverList.separated(
                itemCount: _items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final title = _items[index];
                  return RouteListCard(
                    title: title,
                    subtitle: "2025.09.03  -  --km  -  --m  -  #산책", // 목업 메타
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RouteDetailScreen()),
                      );
                    },
                    onMoreTap: () => showRouteActionsSheet(context),
                  );
                },
              ),
            ),
          },
        ],
      ),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
