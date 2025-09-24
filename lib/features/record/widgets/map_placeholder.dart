import 'package:flutter/material.dart';
import 'package:routelog_project/core/widgets/soft_info_card.dart';

class MapPlaceholder extends StatelessWidget {
  const MapPlaceholder({super.key, this.height = 180});

  final double height;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SoftInfoCard(
      padding: EdgeInsets.zero, // 카드 패딩 제거(지도를 꽉 채우는 룩)
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            // 현재 앱 톤에 맞춘 은은한 그라데이션 + 테두리
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [cs.primaryContainer, cs.secondaryContainer],
            ),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Center(
            child: Icon(
              Icons.my_location_rounded,
              size: 56,
              color: cs.onPrimaryContainer.withOpacity(0.9),
            ),
          ),
        ),
      ),
    );
  }
}
