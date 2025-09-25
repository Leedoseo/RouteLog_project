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

    Widget btn(IconData icon, String label, VoidCallback? onTap, {Color? bg, Color? fg, bool filled = false}) {
      final r = BorderRadius.circular(14);
      return Expanded(
        child: Material(
          color: filled ? (bg ?? cs.primary) : cs.surface,
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
                  Icon(icon, size: 20, color: fg ?? (filled ? cs.onPrimary : cs.onSurface)),
                  const SizedBox(width: 8),
                  Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700, color: fg ?? (filled ? cs.onPrimary : cs.onSurface),
                  )),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return SoftInfoCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          btn(
            _fav ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            _fav ? '즐겨찾기 해제' : '즐겨찾기',
                () { setState(() => _fav = !_fav); widget.onToggleFavorite?.call(_fav); },
          ),
          const SizedBox(width: 8),
          btn(Icons.ios_share_rounded, '내보내기', widget.onExport),
          const SizedBox(width: 8),
          btn(Icons.share_rounded, '공유', widget.onShare),
          const SizedBox(width: 8),
          btn(Icons.delete_forever_rounded, '삭제', widget.onDelete, bg: cs.errorContainer, fg: cs.onErrorContainer, filled: true),
        ],
      ),
    );
  }
}
