import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const routeName = "/onboarding";

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageCtrl = PageController();
  int _index = 0;

  void _goTo(int page) => _pageCtrl.animateToPage(
    page,
    duration: const Duration(milliseconds: 280),
    curve: Curves.easeOut,
  );

  void _next() {
    if (_index < 2) _goTo(_index + 1);
  }

  void _skip() {
    // 실제 앱에선 온보딩 완료 플래그 저장 후 홈으로 이동
    Navigator.of(context).maybePop();
  }

  void _start() {
    // 실제 앱에선 온보딩 완료 플래그 저장 후 홈으로 이동
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final total = 3;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 상단스킵
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _skip,
                child: const Text("건너뛰기"),
              ),
            ),

            // 본문: 페이지들
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                onPageChanged: (i) => setState(() => _index = i),
                children: const [
                  WelcomePage(),
                  PermissionPage(),
                ],
              ),
            ),

            // 하단 인디케이터 + CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  ProgressDots(currentIndex: _index, length: total),
                  const SizedBox(height: 12),
                  OnboardingFooterCta(
                    isLast: _index == total -1,
                    onNext: _next,
                    onStart: _start,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}