import 'package:flutter/material.dart';

class RouteDetailScreen extends StatelessWidget {
  const RouteDetailScreen({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cs.outlineVariant),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.map_rounded, size: 48, color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          Text('메트릭', style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('거리 5.2km · 28분 · 5\'25"/km', style: t.bodyMedium),
        ],
      ),
    );
  }
}
