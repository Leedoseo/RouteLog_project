import 'package:flutter/material.dart';
import 'package:routelog_project/core/widgets/soft_info_card.dart';

class RouteActionBar extends StatefulWidget {
  const RouteActionBar({
    super.key,
    this.isFavorited = false,
    this.onToggleFavorite,
    this.onExport,
    this.onShare,
    this.onDelete,
  });

  final bool isFavorited;
  final ValueChanged<bool>? onToggleFavorite;
  final VoidCallback? onExport;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;

  @override
  State<RouteActionBar> createState() => _RouteActionBarState();
}

class _RouteActionBarState extends State<RouteActionBar> {
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

    Widget btn({
      required IconData icon,
      required String label,
      required VoidCallback? onTap,
      bool filled = false,
      Color? bg,
      Color? fg,
      double? width,
    }) {
      final r = BorderRadius.circular(14);
      final _bg = filled ? (bg ?? cs.primary) : cs.surface;
      final _fg = fg ?? (filled ? cs.onPrimary : cs.onSurface);

      return SizedBox(
        width: width, // ← 그리드 셀 폭 고정
        child: Material(
          color: _bg,
          shape: RoundedRectangleBorder(
            borderRadius: r,
            side: BorderSide(color: cs.outlineVariant),
          ),
          child: InkWell(
            borderRadius: r,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20, color: _fg),
                  const SizedBox(width: 8),
                  Flexible( // 긴 한글 대비
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.labelLarge?.copyWith(fontWeight: FontWeight.w700, color: _fg),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return SoftInfoCard(
      padding: const EdgeInsets.all(12),
      child: LayoutBuilder(
        builder: (context, c) {
          // 반응형: 넓으면 4열, 좁으면 2열
          // (iPhone 12/13/14/15 기본폭 ~390dp → 2열이 안정적)
          const gap = 8.0;
          final fourCols = c.maxWidth >= 560;
          final cols = fourCols ? 4 : 2;
          final cellWidth = (c.maxWidth - gap * (cols - 1)) / cols;

          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              btn(
                icon: _fav ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                label: _fav ? '즐겨찾기 해제' : '즐겨찾기',
                onTap: () {
                  setState(() => _fav = !_fav);
                  widget.onToggleFavorite?.call(_fav);
                },
                width: cellWidth,
              ),
              btn(
                icon: Icons.ios_share_rounded,
                label: '내보내기',
                onTap: widget.onExport,
                width: cellWidth,
              ),
              btn(
                icon: Icons.share_rounded,
                label: '공유',
                onTap: widget.onShare,
                width: cellWidth,
              ),
              btn(
                icon: Icons.delete_forever_rounded,
                label: '삭제',
                onTap: widget.onDelete,
                filled: true,
                bg: cs.errorContainer,
                fg: cs.onErrorContainer,
                width: cellWidth,
              ),
            ],
          );
        },
      ),
    );
  }
}
