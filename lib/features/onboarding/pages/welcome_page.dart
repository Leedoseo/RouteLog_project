import 'package:flutter/material.dart';
import 'package:routelog_project/features/onboarding/widgets/feature_slide.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeatureSlide(
      icon: Icons.route_rounded,
      title: "RouteLog에 오신 것을 환영합니다",
      description: "러닝/산책 루트를 기록하고 \n거리-시간-페이스를 한눈에 확인하세요",
    );
  }
}