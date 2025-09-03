import 'package:flutter/material.dart';

// 화면 내 제목
class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// 여백 포함 섹션 타이틀: 리스트 섹션 시작 전 아래 여백 포함 버전
class SectionTitlePadding extends StatelessWidget {
  final String text;
  const SectionTitlePadding(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Text(
        text,
        style: Theme
            .of(context)
            .textTheme
            .titleMedium
            ?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}