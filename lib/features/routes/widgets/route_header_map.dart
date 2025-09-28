import 'package:flutter/material.dart';
import 'package:routelog_project/core/widgets/soft_info_card.dart';

class RouteHeaderMap extends StatelessWidget {
  const RouteHeaderMap({
    super.key,
    this.height = 220
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SoftInfoCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [cs.primaryContainer, cs.secondaryContainer],
            ),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Center(
            child: Icon(
                Icons.route_rounded,
                size: 56,
                color: cs.onPrimaryContainer.withOpacity(0.9)
            ),
          ),
        ),
      ),
    );
  }
}
