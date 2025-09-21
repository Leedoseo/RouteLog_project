import 'dart:math' as math;
import 'package:flutter/material.dart';

class PhotoViewerScreen extends StatefulWidget {
  final int count; // 이미지 개수
  final int initialIndex; // 시작 인덱스

  const PhotoViewerScreen({
    super.key,
    required this.count,
    this.initialIndex = 0,
  });

  @override
  State<PhotoViewerScreen> createState() => _PhotoViewrScreenState();
}

class _PhotoViewrScreenState extends State<PhotoViewerScreen> {
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    if (widget.count <= 0) {
      _index = 0;
      _controller = PageController(initialPage: 0);
    } else {
      _index = math.max(0, math.min(widget.initialIndex, widget.count - 1));
      _controller = PageController(initialPage: _index);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (widget.count <= 0) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black.withOpacity(0.6),
          foregroundColor: Colors.white,
          title: const Text("0 / 0"),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: "닫기",
              icon: const Icon(Icons.close_rounded),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        body: const SafeArea(
          child: Center(
            child: Text(
              "표시할 사진이 없습니다.",
                style: TextStyle(color: Colors.white70),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.6),
        foregroundColor: Colors.white,
        title: Text("${_index + 1} / ${widget.count}"),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "닫기",
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: PageView.builder(
          controller: _controller,
          itemCount: widget.count,
          onPageChanged: (i) => setState(() => _index = i),
          itemBuilder: (context, i) {
            // 실제 이미지 위젯으로 교체( Image.network or PhotoView 등으로)
            return InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [cs.primaryContainer, cs.secondaryContainer],
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.photo_rounded, size: 64, color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      // 하단 인디케이터
      bottomNavigationBar: _DotsIndicator(
        count: widget.count,
        index: _index,
      ),
    );
  }
}

// 하단 도트 인디케이터
class _DotsIndicator extends StatelessWidget {
  final int count;
  final int index;

  const _DotsIndicator({
    required this.count,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 1) return const SizedBox.shrink();

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < count; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 0,
                width: i == index ? 18 : 8,
                decoration: BoxDecoration(
                  color: i == index ? Colors.white : Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
          ],
        ),
      ),
    );
  }
}