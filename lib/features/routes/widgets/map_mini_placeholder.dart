import 'package:flutter/material.dart';

// 상단 미니맵 플레이스 홀더(16:9)
class MapMiniPlaceholder extends StatelessWidget {
  final String title;
  const MapMiniPlaceholder({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [cs.primaryContainer, cs.secondaryContainer],
          ),
        ),
        child: Stack(
          children: [
            const Center(child: Icon(Icons.map_rounded, size: 56)),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: _MapCaption(title: title),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapCaption extends StatelessWidget {
  final String title;
  const _MapCaption({required this.title});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: cs.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
                overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("지도 크게 보기는 나중에 연결")),
              );
            },
            icon: const Icon(Icons.fullscreen_rounded),
            tooltip: "지도 크게 보기",
          ),
        ],
      ),
    );
  }
}