import 'package:flutter/material.dart';

class PermissionPage extends StatelessWidget {
  const PermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 실제 권한 요청은 나중에 연결
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: const [
        PermissionCard(
          icon: Icons.my_location_rounded,
          title: "정확한 위치",
          description: "기록 중 실시간 위치와 거리 계산에 필요해요",
        ),
        SizedBox(height: 12),

        PermissionCard(
          icon: Icons.location_searching_rounded,
          title: "백그라운드 위치(선택)",
          description: "화면이 꺼져도 기록을 이어가려면 권장해요",
        ),
        SizedBox(height: 12),

        PermissionCard(
          icon: Icons.notifications_active_rounded,
          title: "알림(선택)",
          description: "기록 상태, 목표 달성, 요약 결과를 알려드려요",
        ),
        SizedBox(height: 12),
      ],
    );
  }
}