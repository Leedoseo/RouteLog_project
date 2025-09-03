import 'package:flutter/material.dart';

// 사진 그리드
class PhotoGrid extends StatelessWidget {
  final int count;
  final void Function(int index) onTap;

  const PhotoGrid({
    super.key,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final clamped = count < 0
        ? 0
        : (count > 6 ? 6 : count); // int.clamp 캐스팅 이슈 피하기 위한 수동 클램프
    final items = List.generate(clamped, (i) => i);

    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            const Icon(Icons.photo_outlined),
            const SizedBox(width: 8),
            Text("등록된 사진이 없어요", style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 8),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 6,
        crossAxisSpacing: 6,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onTap(index),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: cs.outlineVariant),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [cs.secondaryContainer, cs.primaryContainer],
              ),
            ),
            child: const Center(child: Icon(Icons.photo_rounded, size: 28)),
          ),
        );
      },
    );
  }
}