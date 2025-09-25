import 'package:flutter/material.dart';
import 'package:routelog_project/core/widgets/metric_pill.dart';

class RouteListTile extends StatefulWidget {
  const RouteListTile({
    super.key,
    required this.title,
    required this.meta,
    required this.distanceText,
    required this.paceText,
    this.isFavorited = false,
    this.onTap,
    this.onExport,
    this.onShare,
    this.onDelete,
    this.onToggleFavorite,
  });

  final String title;
  final String meta;
  final String distanceText;
  final String paceText;

  final bool isFavorited;
  final VoidCallback? onTap;
  final VoidCallback? onExport;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;
  final ValueChanged<bool>? onToggleFavorite;

  @override
  State<RouteListTile> createState() => _RouteListTileState();
}

class _RouteListTileState extends State<RouteListTile> {
  late bool _fav;

  @override
  void initState() {
    super.initState();
    _fav = widget.isFavorited;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 썸네일(지도 느낌의 그라데이션 박스)
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cs.outlineVariant),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [cs.primaryContainer, cs.secondaryContainer],
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.route_rounded, color: cs.onPrimaryContainer.withOpacity(0.9)),
              ),
              const SizedBox(width: 12),

              // 텍스트/메타
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 타이틀 + 액션
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                        IconButton(
                          tooltip: _fav ? '즐겨찾기 해제' : '즐겨찾기',
                          onPressed: () {
                            setState(() => _fav = !_fav);
                            widget.onToggleFavorite?.call(_fav);
                          },
                          icon: Icon(_fav ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                              color: _fav ? cs.primary : cs.onSurfaceVariant),
                        ),
                        PopupMenuButton<_ItemMenu>(
                          tooltip: '더보기',
                          onSelected: (v) {
                            switch (v) {
                              case _ItemMenu.export:
                                widget.onExport?.call();
                                break;
                              case _ItemMenu.share:
                                widget.onShare?.call();
                                break;
                              case _ItemMenu.delete:
                                widget.onDelete?.call();
                                break;
                            }
                          },
                          itemBuilder: (ctx) => const [
                            PopupMenuItem(value: _ItemMenu.export, child: Text('내보내기')),
                            PopupMenuItem(value: _ItemMenu.share,  child: Text('공유')),
                            PopupMenuItem(value: _ItemMenu.delete, child: Text('삭제')),
                          ],
                          icon: const Icon(Icons.more_vert_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.meta,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: 8),

                    // 메트릭 Pill (앱 공통 위젯 재사용)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        MetricPill(label: 'DISTANCE', value: widget.distanceText, icon: Icons.straighten_rounded),
                        MetricPill(label: 'PACE', value: widget.paceText, icon: Icons.speed_rounded),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _ItemMenu { export, share, delete }
